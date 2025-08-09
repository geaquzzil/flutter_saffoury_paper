import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggerdGridViewWidget extends StatelessWidget {
  List<StaggeredGridTile>? list;

  ///int 1: is crossCount
  ///int 2: is suggested crossCount for StraggeredGrid
  ///int 3: is suggested crossCountMod
  List<StaggeredGridTile> Function(
    int fullCrossAxisCount,
    int crossCountFundCalc,
    int crossAxisCountMod,
    num heightMainAxisCellCount,
  )?
  builder;
  bool isSliver;
  bool wrapWithCard;
  double? hasWidth;
  StaggerdGridViewWidget({
    super.key,
    this.childAspectRatio = 1,
    this.wrapWithCard = false,
    this.builder,
    this.hasWidth,
    this.isSliver = false,
    this.list,
  }) : assert(list != null || builder != null);

  final double childAspectRatio;

  int getCrossAxisCount(double width) {
    int val = ((width / 150)).toInt();
    debugPrint("getCrossAxisCount val width:$width  $val");
    return val;
    if (width < 500 && width > 0) {
      return 1;
    } else if (width < 1000 && width > 500) {
      return 3;
    } else {
      int val = ((width / 300)).toInt();
      debugPrint("getCrossAxisCount val   $val");
      return val;
    }
  }

  num getHeightMainAxisCellCount(double height) {
    if (height < 500 && height > 0) {
      return .7;
    } else if (height < 1000 && height > 500) {
      return .8;
    } else {
      return 1;
      int val = ((height / 300)).toInt();
      debugPrint("getCrossAxisCount val   $val");
      return val;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("FileInfoStaggerdGridView====> wrapWithCard $wrapWithCard");
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = getCrossAxisCount(constraints.maxWidth);
        bool isMezouj = crossAxisCount % 2 == 0;
        double pixel = View.of(context).devicePixelRatio;
        debugPrint(
          "FileInfoStaggerdGridView====> width:${constraints.maxWidth} height:${constraints.maxHeight} getHeightMainAxisCellCount ${getHeightMainAxisCellCount(constraints.maxHeight)} isMezouj: $isMezouj   crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4} ",
        );
        int crossCountFund = crossAxisCount ~/ 4;
        int crossAxisCountMod = crossAxisCount % 4;
        int crossCountFundCalc = crossAxisCountMod == 0 ? crossCountFund : 1;
        num height = getHeightMainAxisCellCount(constraints.maxHeight);
        debugPrint(
          "FileInfoStaggerdGridView====> isMezouj: $isMezouj  crossCountFundCalc $crossCountFundCalc crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4}  crossCountFundCalc + crossAxisCountMod =${crossCountFundCalc + crossAxisCountMod} height:$height maxHegiht: ${constraints.maxHeight}",
        );
        if (builder != null) {
          list = builder!.call(
            crossAxisCount,
            crossCountFundCalc,
            crossAxisCountMod,
            getHeightMainAxisCellCount(MediaQuery.of(context).size.height),
          );
        }

        Widget w = StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          // axisDirection: AxisDirection.down,
          children: wrapWithCard
              ? list!.map((e) => Card(child: e)).toList()
              : list!,
        );
        // return w;
        if (isSliver) {
          return SliverToBoxAdapter(child: w);
        }
        return w;
      },
    );
  }
}
