import 'package:flutter/material.dart';

import '../../constants.dart';

class StarageDetails extends StatelessWidget {
  const StarageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Storage Details",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: defaultPadding),
          const Chart(),
          const StorageInfoCard(
            svgSrc: Icons.document_scanner,
            title: "Documents Files",
            amountOfFiles: "1.3GB",
            numOfFiles: 1328,
          ),
          const StorageInfoCard(
            svgSrc: Icons.media_bluetooth_off,
            title: "Media Files",
            amountOfFiles: "15.3GB",
            numOfFiles: 1328,
          ),
          const StorageInfoCard(
            svgSrc: Icons.other_houses,
            title: "Other Files",
            amountOfFiles: "1.3GB",
            numOfFiles: 1328,
          ),
          const StorageInfoCard(
            svgSrc: Icons.unarchive,
            title: "Unknown",
            amountOfFiles: "1.3GB",
            numOfFiles: 140,
          ),
        ],
      ),
    );
  }
}

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
  }) : super(key: key);

  final String title, amountOfFiles;
  final IconData svgSrc;
  final int numOfFiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
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
                    "$numOfFiles Files",
                    style: Theme.of(context).textTheme.caption!,
                  ),
                ],
              ),
            ),
          ),
          Text(amountOfFiles)
        ],
      ),
    );
  }
}

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          const Text("PIE"),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  "29.1",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                const Text("of 128GB")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// List<PieChartSectionData> paiChartSelectionDatas = [
//   PieChartSectionData(
//     color: primaryColor,
//     value: 25,
//     showTitle: false,
//     radius: 25,
//   ),
//   PieChartSectionData(
//     color: Color(0xFF26E5FF),
//     value: 20,
//     showTitle: false,
//     radius: 22,
//   ),
//   PieChartSectionData(
//     color: Color(0xFFFFCF26),
//     value: 10,
//     showTitle: false,
//     radius: 19,
//   ),
//   PieChartSectionData(
//     color: Color(0xFFEE2727),
//     value: 15,
//     showTitle: false,
//     radius: 16,
//   ),
//   PieChartSectionData(
//     color: primaryColor.withOpacity(0.1),
//     value: 25,
//     showTitle: false,
//     radius: 13,
//   ),
// ];