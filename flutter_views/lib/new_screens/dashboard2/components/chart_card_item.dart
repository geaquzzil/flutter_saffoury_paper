import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChartCardItem extends StatelessWidget {
  const ChartCardItem({Key? key}) : super(key: key);

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
        decoration: const BoxDecoration(
          // color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                const Icon(
                  Icons.more_vert,
                )
              ],
            ),
            Text(
              "TITLdfscsdfdsE",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption!,
            ),
            Text(
              "Descriptiewwasdsdsasfdsdsfdson",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("32%", style: Theme.of(context).textTheme.caption!),
                Text("Since last month",
                    style: Theme.of(context).textTheme.caption!),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    required this.percentage,
  }) : super(key: key);
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
