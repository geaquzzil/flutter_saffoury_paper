import 'package:flutter/material.dart';

import '../../constants.dart';

class StorageDetailsCustom extends StatelessWidget {
  List<StorageInfoCardCustom>? list;
  Widget chart;
  StorageDetailsCustom({super.key, this.list, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        // decoration: const BoxDecoration(
        //   color: secondaryColor,
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: double.infinity, height: 200, child: chart),
            if (list != null) ...list!,
          ],
        ),
      ),
    );
  }
}

@Deprecated("use OutLinedCard instead with ListTile")
class StorageInfoCardCustom extends StatelessWidget {
  StorageInfoCardCustom({
    super.key,
    required this.title,
    required this.description,
    required this.trailing,
    required this.svgSrc,
  });

  final String title, description;
  Widget trailing;
  final IconData svgSrc;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border:
            Border.all(width: 2, color: Theme.of(context).colorScheme.outline),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(height: 20, width: 20, child: Icon(svgSrc)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                ],
              ),
            ),
          ),
          (trailing)
        ],
      ),
    );
  }
}
