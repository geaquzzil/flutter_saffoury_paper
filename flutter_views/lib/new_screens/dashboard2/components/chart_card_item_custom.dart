import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChartCardItemCustom extends StatelessWidget {
  IconData? icon;
  String title;
  String description;
  String? footer;
  String? footerRight;
  Color? color;
  ChartCardItemCustom(
      {Key? key,
      this.color,
      required this.title,
      required this.description,
      this.icon,
      this.footer,
      this.footerRight})
      : super(key: key);

  // final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
            // color: Theme.of(context).colorScheme.outline,
            ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.all(defaultPadding / 8),
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      // color: Colors.orange.withOpacity(0.1),
                      // color: info.color!.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Icon(Icons.file_copy)),
                if (icon != null)
                  Icon(
                    icon,
                  )
              ],
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption!,
            ),
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (footer != null)
                  Text(footer!, style: Theme.of(context).textTheme.caption!),
                if (footerRight != null)
                  Text(footerRight!,
                      style: Theme.of(context).textTheme.caption!),
              ],
            )
          ],
        ),
      ),
    );
  }
}
