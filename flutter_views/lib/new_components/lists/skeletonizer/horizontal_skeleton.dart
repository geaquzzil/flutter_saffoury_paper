// import 'package:flutter/material.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class HorizontalSkeleton extends StatelessWidget {
//   final bool isSliver;
//   final bool isLoading;
//   final int itemCount;
//   final Widget child;
//   const HorizontalSkeleton(
//       {super.key,
//       required this.isSliver,
//       required this.itemCount,
//       required this.isLoading});

//   @override
//   Widget build(BuildContext context) {
//     if (isSliver) {
//       return Skeletonizer.sliver(

//         enabled: isLoading,
//         child: !isLoading
//             ? child
//             : 
            
//             ListView.builder(
//                 itemCount: itemCount,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text('Item number $index as title'),
//                       subtitle: const Text('Subtitle here'),
//                       trailing: const Icon(Icons.ac_unit),
//                     ),
//                   );
//                 },
//               ),
//       );
//     } else {
//       return Skeletonizer(
//         enabled: isLoading,
//         child: !isLoading
//             ? child
//             : ListView.builder(
//                 itemCount: itemCount,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text('Item number $index as title'),
//                       subtitle: const Text('Subtitle here'),
//                       trailing: const Icon(Icons.ac_unit),
//                     ),
//                   );
//                 },
//               ),
//       );
//     }
//   }
// }
