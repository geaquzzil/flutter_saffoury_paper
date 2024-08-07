import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class BaseSharedHeaderDescription extends StatelessWidget {
  ViewAbstract viewAbstract;
  BaseSharedHeaderDescription({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          viewAbstract.getCardLeading(context),
          const SizedBox(width: kDefaultPadding),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              // text: viewAbstract.getMainHeaderTextOnly(context),
                              style: Theme.of(context).textTheme.labelLarge,
                              children: [
                                TextSpan(
                                    text: viewAbstract
                                        .getMainHeaderLabelTextOnly(context),
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Text(
                            viewAbstract.getMainHeaderTextOnly(context),
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 2),
                    // Text(
                    //   viewAbstract.getDateTextOnly() ?? "",
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                  ],
                ),
              ]))
        ]);
  }
}
