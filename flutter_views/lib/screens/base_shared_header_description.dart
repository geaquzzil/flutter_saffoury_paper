import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class BaseSharedHeaderDescription extends StatelessWidget {
  ViewAbstract viewAbstract;
  BaseSharedHeaderDescription({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(
          maxRadius: 24,
          backgroundColor: Colors.transparent,
          child: viewAbstract.getCardLeadingImage(context)),
      const SizedBox(width: kDefaultPadding),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      // text: viewAbstract.getMainHeaderTextOnly(context),
                      style: Theme.of(context).textTheme.button,
                      children: [
                        TextSpan(
                            text: viewAbstract
                                .getMainHeaderLabelTextOnly(context),
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                  Text(
                    viewAbstract.getMainHeaderTextOnly(context),
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            ),
            const SizedBox(width: kDefaultPadding / 2),
            Text(
              viewAbstract.getDateTextOnly() ?? "",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ]))
    ]);
  }
}
