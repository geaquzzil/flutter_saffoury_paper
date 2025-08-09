// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_view_controller/constants.dart';
// import 'package:flutter_view_controller/l10n/app_localization.dart';
// import 'package:flutter_view_controller/new_screens/dashboard2/components/staggerd_grid_view_widget.dart';
// import 'package:flutter_view_controller/new_screens/dashboard2/components/test_expanded.dart';
// import 'package:flutter_view_controller/size_config.dart';

// import '../../interfaces/dashable_interface.dart';
// import 'components/chart_card_item.dart';
// class MyFiles extends StatelessWidget {
//   DashableGridHelper dgh;
//   MyFiles({super.key, required this.dgh});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             if (dgh.title != null)
//               Text(dgh.title!, style: Theme.of(context).textTheme.titleMedium),
//             ElevatedButton.icon(
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: defaultPadding * 1.5,
//                   vertical:
//                       defaultPadding / (SizeConfig.isMobile(context) ? 2 : 1),
//                 ),
//               ),
//               onPressed: () {},
//               icon: const Icon(Icons.add),
//               label: Text(AppLocalizations.of(context)!.add_new),
//             ),
//           ],
//         ),
//         const SizedBox(height: defaultPadding),
//         Responsive(
//           mobile: StaggerdGridViewWidget(
//             list: dgh.widgets.map((e) => e.widget).toList(),
//             childAspectRatio: size.width < 750 && size.width > 350 ? 1.3 : 1,
//           ),
//           tablet: StaggerdGridViewWidget(
//             list: dgh.widgets.map((e) => e.widget).toList(),
//           ),
//           desktop: StaggerdGridViewWidget(
//             list: dgh.widgets.map((e) => e.widget).toList(),
//             childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
//           ),
//         ),
//         const SizedBox(height: kDefaultPadding),
//       ],
//     );
//   }
// }

