import 'package:flutter/material.dart';

import '../../constants.dart';

class StarageDetailsCustom extends StatelessWidget {
  List<StorageInfoCardCustom>? list;
  Widget chart;
  StarageDetailsCustom({Key? key, this.list, required this.chart})
      : super(key: key);

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
            SizedBox(width: double.infinity, height: 400, child: chart), if (list != null) ...list!,
          ],
        ),
      ),
    );
  }
}

class StorageInfoCardCustom extends StatelessWidget {
  const StorageInfoCardCustom({
    Key? key,
    required this.title,
    required this.description,
    required this.trailing,
    required this.svgSrc,
  }) : super(key: key);

  final String title, description, trailing;
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
                    style: Theme.of(context).textTheme.caption!,
                  ),
                ],
              ),
            ),
          ),
          Text(trailing)
        ],
      ),
    );
  }
}
