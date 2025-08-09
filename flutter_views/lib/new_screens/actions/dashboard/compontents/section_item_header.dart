import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SectionItemHeader extends MultiSliver {
  SectionItemHeader({
    super.key,
    required BuildContext context,
    required DashableGridHelper dgh,
    required GlobalKey buttonKey,
    required       SecoundPaneHelperWithParentValueNotifier  basePage,
    Widget? child,
  }) : super(
         pushPinnedChildren: true,
         children: [
           if (dgh.title != null)
             SliverPadding(
               padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
               sliver: SliverPinnedHeader(
                 child: Container(
                   padding: const EdgeInsets.all(kDefaultPadding),
                   color: Theme.of(context).scaffoldBackgroundColor,
                   child: ListTile(
                     title: Text(
                       dgh.title!,
                       style: Theme.of(context).textTheme.titleLarge,
                     ),
                     trailing: dgh.headerListToAdd == null
                         ? null
                         : ElevatedButton.icon(
                             key: buttonKey,
                             style: TextButton.styleFrom(
                               padding: const EdgeInsets.symmetric(
                                 horizontal: kDefaultPadding * 1.5,
                                 vertical: kDefaultPadding / 2,
                               ),
                             ),
                             onPressed: () async {
                               if (dgh.headerListToAdd == null) return;
                               await showPopupMenu(
                                 context,
                                 buttonKey,
                                 list: dgh.headerListToAdd!
                                     .map(
                                       (e) => buildMenuItem(
                                         context,
                                         MenuItemBuild(


                                           e.getMainHeaderLabelTextOnly(
                                             context,
                                           ),
                                           Icons.add,

                                           "",
                                         ),
                                         onTap: () {
                                           basePage.notifyViewAbstract(context,e,ServerActions.edit);
                                         },
                                       ),
                                     )
                                     .toList(),
                               ).then(
                                 (value) => debugPrint("showPopupMenu $value"),
                               );
                             },
                             icon: const Icon(Icons.add),
                             label: Text(AppLocalizations.of(context)!.add_new),
                           ),
                   ),

                   //  Column(
                   //   children: [
                   //     Row(
                   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //       children: [
                   //         Text(
                   //           dgh.title,
                   //           style: Theme.of(context).textTheme.titleLarge,
                   //         ),
                   //         if (dgh.headerListToAdd != null)
                   //           ElevatedButton.icon(
                   //             key: buttonKey,
                   //             style: TextButton.styleFrom(
                   //               padding: const EdgeInsets.symmetric(
                   //                 horizontal: kDefaultPadding * 1.5,
                   //                 vertical: kDefaultPadding / 2,
                   //               ),
                   //             ),
                   //             onPressed: () async {
                   //               if (dgh.headerListToAdd == null) return;
                   //               await showPopupMenu(context, buttonKey,
                   //                       list: dgh.headerListToAdd!
                   //                           .map((e) => buildMenuItem(
                   //                               context,
                   //                               MenuItemBuild(
                   //                                   e.getMainHeaderLabelTextOnly(
                   //                                       context),
                   //                                   Icons.add,
                   //                                   "")))
                   //                           .toList())
                   //                   .then((value) =>
                   //                       debugPrint("showPopupMenu $value"));
                   //             },
                   //             icon: const Icon(Icons.add),
                   //             label: Text(AppLocalizations.of(context)!.add_new),
                   //           ),
                   //       ],
                   //     ),
                   //   ],
                   // ),
                 ),
               ),
             ),
           SliverToBoxAdapter(child: child),
         ],
       );
}

// @deprecated
// class DashableItemHeaderBuilder extends StatelessWidget {
//   DashableGridHelper dgh;
//   DashableItemHeaderBuilder({Key? key, required this.dgh}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     GlobalKey buttonKey = GlobalKey();
//     return SliverPinnedHeader(
//       child: Text(dgh.title),
//     );
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: kDefaultPadding, vertical: kDefaultPadding),
//       sliver: SliverPersistentHeader(
//         floating: true,
//         pinned: true,

//         // floating: true,
//         delegate: SliverAppBarDelegate(

//             // 2
//             minHeight: 50,
//             maxHeight: 50,
//             // 3
//             child: Container(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         dgh.title,
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       ElevatedButton.icon(
//                         key: buttonKey,
//                         style: TextButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: kDefaultPadding * 1.5,
//                             vertical: kDefaultPadding / 2,
//                           ),
//                         ),
//                         onPressed: () async {
//                           if (dgh.headerListToAdd == null) return;
//                           await showPopupMenu(context, buttonKey,
//                                   list: dgh.headerListToAdd!
//                                       .map((e) => buildMenuItem(
//                                           context,
//                                           MenuItemBuild(
//                                               e.getMainHeaderLabelTextOnly(
//                                                   context),
//                                               Icons.add,
//                                               "")))
//                                       .toList())
//                               .then((value) =>
//                                   debugPrint("showPopupMenu $value"));
//                         },
//                         icon: const Icon(Icons.add),
//                         label: Text(AppLocalizations.of(context)!.add_new),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }

// class TicPackage extends StatelessWidget {
//   TicPackage(
//       {this.heroTag,
//       this.package,
//       this.onTap,
//       this.isSmall = false,
//       this.animation});

//   final String heroTag;
//   final Animation<double> ?animation;
//   final Package package;
//   final bool isSmall;
//   final Function() onTap;

//   final NumberFormat currencyFormatter =
//       NumberFormat.currency(locale: "nl", decimalDigits: 2, symbol: "€");

//   Widget _animationWidget({Widget child}) {
//     return animation != null
//         ? FadeTransition(
//             opacity: animation,
//             child: SizeTransition(
//                 axisAlignment: 1.0, sizeFactor: animation, child: child))
//         : !isSmall ? child : Container();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget eventCountText = _animationWidget(
//         child: Padding(
//             padding: EdgeInsets.only(bottom: 10),
//             child: Text("${package.eventCount} evenementen",
//                 style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))));

//     Widget goodsText = _animationWidget(
//       child: Padding(
//           padding: EdgeInsets.only(top: 12),
//           child: Text(package.goods,
//               style:
//                   TextStyle(color: Colors.white, fontStyle: FontStyle.italic))),
//     );

//     Widget discountText = _animationWidget(
//         child: Padding(
//             padding: EdgeInsets.only(top: 10),
//             child: Container(
//               child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                   child: Text(
//                     "${currencyFormatter.format(package.discount)} korting",
//                     style: TextStyle(color: Colors.white),
//                   )),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.5)),
//                   borderRadius: BorderRadius.circular(100)),
//             )));

//     Widget titleText = Text(
//       package.name,
//       style: TextStyle(
//           color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//     );

//     Widget card = Card(
//         color: package.color,
//         borderRadius: BorderRadius.circular(10),
//         margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.all(15),
//           child: Stack(
//             children: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   eventCountText,
//                   titleText,
//                   Padding(
//                       padding: EdgeInsets.only(top: 2),
//                       child: Text(package.description,
//                           style: TextStyle(color: Colors.white))),
//                   goodsText,
//                   discountText,
//                 ],
//               ),
//               Positioned(
//                   child: Text(
//                     "${currencyFormatter.format(package.price)}",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   top: 0,
//                   right: 0)
//             ],
//           ),
//         ));

//     if (heroTag == null) {
//       return card;
//     }

//     return Hero(
//         tag: heroTag,
//         flightShuttleBuilder: (
//           BuildContext flightContext,
//           Animation<double> animation,
//           HeroFlightDirection flightDirection,
//           BuildContext fromHeroContext,
//           BuildContext toHeroContext,
//         ) {
//           return TicPackage(
//             package: package,
//             animation: ReverseAnimation(animation),
//           );
//         },
//         child: card);
//   }
// }
