import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CartableDraggableHeader extends StatelessWidget {
  final List<CartableProductItemInterface> listableInterface;
  const CartableDraggableHeader({super.key, required this.listableInterface});

  @override
  Widget build(BuildContext context) {
    if (listableInterface.isEmpty) {
      return SizedBox();
    }
    return Column(
      children: [
        FadeInLeft(
          duration: const Duration(milliseconds: 500),
          child: getRow(context, [
            TitleAndDescription(
                title: AppLocalizations.of(context)!.itemCount,
                description: listableInterface.length.toCurrencyFormat()),
          ]),
        ),
        FadeInLeft(
          duration: const Duration(milliseconds: 500),
          child: getRow(context, [
            TitleAndDescription(
                title: AppLocalizations.of(context)!.total,
                description: listableInterface
                    .map((e) => e.getCartableProductQuantity())
                    .reduce((value, element) =>
                        value.toNonNullable() + element.toNonNullable())
                    .toCurrencyFormat())
          ]),
        ),
      ],
    );
  }

  Widget getRow(BuildContext context, List<TitleAndDescription> tile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: tile
          .map((e) => Expanded(
                child: ListTile(
                  title: Text(e.title,
                      style: Theme.of(context).textTheme.bodySmall),
                  subtitle: e.descriptionWidget ??
                      Text(
                        e.description ?? "",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                  leading: e.icon == null ? null : Icon(e.icon),
                ),
              ))
          .toList(),
    );
  }
}

class TitleAndDescription {
  String title;
  String? description;
  Widget? descriptionWidget;
  IconData? icon;
  TitleAndDescription(
      {required this.title,
      this.description,
      this.descriptionWidget,
      this.icon});
}
