// import 'package:flutter/material.dart';
// import 'package:flutter_view_controller/constants.dart';
// import 'package:flutter_view_controller/models/view_abstract.dart';
// import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
// import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
// import 'package:flutter_view_controller/new_screens/home/base_home_shared_with_widget.dart';
// import 'package:flutter_view_controller/l10n/app_localization.dart';
// import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';

// class HomeCameraNavigationWidget extends BaseHomeSharedWithWidgets {
//   HomeCameraNavigationWidget({super.key});

//   @override
//   Widget? getEndPane(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: readerViewAbstract,
//       builder: (context, value, _) {
//         if (value == null) {
//           return EmptyWidget(
//             expand: true,
//             lottiUrl:
//                 "https://assets3.lottiefiles.com/packages/lf20_oqfmttib.json",
//           );
//         }
//         return BaseViewNewPage(viewAbstract: value as ViewAbstract);
//       },
//     );
//   }

//   @override
//   Widget? getSilverAppBarTitle(BuildContext context) {
//     return null;
//     return ListTile(
//       title: Text(AppLocalizations.of(context)!.scan),
//       leading: const Icon(Icons.qr_code),
//     );
//   }

//   @override
//   List<Widget>? getSliverAppBarActions(BuildContext context) {
//     return null;
//   }

//   @override
//   Widget? getSliverHeader(BuildContext context) {
//     return null;
//   }

//   @override
//   List<Widget> getSliverList(BuildContext context) {
//     return [
//       SliverFillRemaining(
//           child: QrCodeReader(
//         getViewAbstract: true,

//       ))
//     ];
//   }

//   @override
//   EdgeInsets? hasBodyPadding(BuildContext context) {
//     return EdgeInsets.symmetric(horizontal: 40, vertical: 80);
//   }

//   @override
//   void init(BuildContext context) {
//     // TODO: implement init
//   }

//   @override
//   EdgeInsets? hasMainBodyPadding(BuildContext context) {
//     return EdgeInsets.symmetric(horizontal: kDefaultPadding);
//   }
// }
