import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:shimmer/shimmer.dart';

// class NewsCardSkelton extends StatelessWidget {
//   const NewsCardSkelton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Skeleton(height: 120, width: 120),
//         const SizedBox(width: defaultPadding),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Skeleton(width: 80),
//               const SizedBox(height: defaultPadding / 2),
//               const Skeleton(),
//               const SizedBox(height: defaultPadding / 2),
//               const Skeleton(),
//               const SizedBox(height: defaultPadding / 2),
//               Row(
//                 children: const [
//                   Expanded(
//                     child: Skeleton(),
//                   ),
//                   SizedBox(width: defaultPadding),
//                   Expanded(
//                     child: Skeleton(),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.outline,
      highlightColor: Theme.of(context).colorScheme.onSurface,
      period: const Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: 100,
                height: 75,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    height: 10,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 150,
                    height: 10,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerLoadingListGrid extends StatelessWidget {
  const ShimmerLoadingListGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.outline,
      highlightColor: Theme.of(context).colorScheme.onSurface,
      period: const Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Theme.of(context).colorScheme.outline)),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 30,
                  child: Container(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      height: 10,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 150,
                      height: 10,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
