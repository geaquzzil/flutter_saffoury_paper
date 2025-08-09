import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SectionItemHeaderI extends MultiSliver {
  bool pinHeader;
  double pinHeaderPrefferedSize;
  

  SectionItemHeaderI({
    super.key,
    required BuildContext context,
    required Widget title,
    required GlobalKey buttonKey,
    super.pushPinnedChildren = true,
    this.pinHeader = true,
    this.pinHeaderPrefferedSize = 80,
    Widget? child,
  }) : super(
         children: [
           if (pinHeader)
             SliverPinnedHeader(
               child: Container(
                 padding: const EdgeInsets.all(kDefaultPadding),
                 //todo
                 color: ElevationOverlay.colorWithOverlay(
                   Theme.of(context).colorScheme.surface,
                   Theme.of(context).colorScheme.surfaceBright,
                   10,
                 ),
                 child: title,
               ),
             )
           else
             SliverPadding(
               padding: const EdgeInsets.all(kDefaultPadding),
               sliver: SliverPersistentHeader(
                 pinned: false,
                 delegate: SliverAppBarDelegatePreferedSize(
                   shouldRebuildWidget: true,
                   child: PreferredSize(
                     preferredSize: Size.fromHeight(pinHeaderPrefferedSize),
                     child: title,
                   ),
                 ),
               ),
             ),
           SliverToBoxAdapter(child: child),
         ],
       );
}
