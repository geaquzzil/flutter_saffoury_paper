import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import '../models/invoices/cuts_invoices/cut_requests.dart';
import 'cut_request_top_widget.dart';

class CutRequestCustomListableHeader extends StatelessWidget {
  CutRequest cutRequest;
  CutRequestCustomListableHeader({super.key, required this.cutRequest});

  @override
  Widget build(BuildContext context) {
    int totalWidth = cutRequest.getTotalRequestSizesWidth();
    int totalRemaining = cutRequest.getTotalRemainingRequestSizesWidth();
    return Column(
      children: [
        FadeInLeft(
          duration: const Duration(milliseconds: 500),
          child: getRow(context, [
            TitleAndDescription(
                title: AppLocalizations.of(context)!.total_count,
                description:
                    cutRequest.getListableList().length.toCurrencyFormat()),
          ]),
        ),
        FadeInLeft(
          duration: const Duration(milliseconds: 500),
          child: getRow(context, [
            TitleAndDescription(
                title:
                    "${AppLocalizations.of(context)!.total}: ${AppLocalizations.of(context)!.product_width}",
                description: totalWidth.toCurrencyFormat()),
            TitleAndDescription(
                title: AppLocalizations.of(context)!.remainingBalance,
                description: totalRemaining.toCurrencyFormat()),
          ]),
        ),
        if (totalRemaining != 0)
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: getRow(context, [
              TitleAndDescription(
                  icon: Icons.error,
                  isError: true,
                  title: AppLocalizations.of(context)!.warning,
                  description: AppLocalizations.of(context)!
                      .errQuantityNotEqualsToProduct),
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
                      style: e.isError
                          ? Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error)
                          : Theme.of(context).textTheme.bodySmall),
                  subtitle: e.descriptionWidget ??
                      Text(
                        e.description ?? "",
                        style: e.isError
                            ? Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error)
                            : Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                  leading: e.icon == null
                      ? null
                      : Icon(e.icon,
                          color: e.isError
                              ? Theme.of(context).colorScheme.error
                              : null),
                ),
              ))
          .toList(),
    );
  }
}
