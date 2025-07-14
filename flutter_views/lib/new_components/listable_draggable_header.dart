import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';

class HeaderListableDraggable extends StatelessWidget {
  final ListableInterface listableInterface;
  const HeaderListableDraggable({super.key, required this.listableInterface});

  @override
  Widget build(BuildContext context) {
    if (listableInterface.isListableIsImagable()) {
      int count = listableInterface.getListableList().length;
      return Column(
        children: [
          MaterialBanner(
            content: Text('This is a MaterialBanner list=> $count'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // scaffold.hideCurrentMaterialBanner();
                },
                child: Text('DISMISS count => $count'),
              ),
            ],
          ),
        ],
      );
    }
    return Column(
      children: [
        if (listableInterface.getListableList().isEmpty)
          MaterialBanner(
            content: const Text('This is a MaterialBanner'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // scaffold.hideCurrentMaterialBanner();
                },
                child: const Text('DISMISS'),
              ),
            ],
          ),
        FadeInLeft(
          duration: const Duration(milliseconds: 500),
          child: getRow(context, [
            TitleAndDescription(
                title: AppLocalizations.of(context)!.total_quantity,
                description:
                    listableInterface.getListableTotalQuantity(context)),
          ]),
        ),
        FadeInLeft(
          duration: const Duration(milliseconds: 500),
          child: getRow(context, [
            TitleAndDescription(
                title: AppLocalizations.of(context)!.discount,
                description: listableInterface
                    .getListableTotalDiscount(context)
                    .toNonNullable()
                    .toCurrencyFormatFromSetting(context)),
            TitleAndDescription(
                title: AppLocalizations.of(context)!.total_price,
                description: listableInterface
                    .getListableTotalPrice(context)
                    ?.toNonNullable()
                    .toCurrencyFormatFromSetting(context)),
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
