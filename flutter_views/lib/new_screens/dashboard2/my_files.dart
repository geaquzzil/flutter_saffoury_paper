import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../interfaces/dashable_interface.dart';
import 'components/chart_card_item.dart';
import 'dashboard.dart';

class MyFiles extends StatelessWidget {
  DashableGridHelper dgh;
  MyFiles({super.key, required this.dgh});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (dgh.title != null)
              Text(
                dgh.title!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (SizeConfig.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.add_new),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoStaggerdGridView(
            list: dgh.widgets.map((e) => e.widget).toList(),
            childAspectRatio: size.width < 750 && size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoStaggerdGridView(
            list: dgh.widgets.map((e) => e.widget).toList(),
          ),
          desktop: FileInfoStaggerdGridView(
            list: dgh.widgets.map((e) => e.widget).toList(),
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
        const SizedBox(height: kDefaultPadding)
      ],
    );
  }
}

class TestExpanded extends StatefulWidget {
  const TestExpanded({super.key});

  @override
  State<TestExpanded> createState() => _TestExpandedState();
}

class _TestExpandedState extends State<TestExpanded> {
  int width = 1;
  int length = 1;
  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
        crossAxisCellCount: length,
        mainAxisCellCount: width,
        child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
                // color: Theme.of(context).colorScheme.outline,
                ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              // color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(defaultPadding / 8),
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          // color: Colors.orange.withOpacity(0.1),
                          // color: info.color!.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Icon(Icons.file_copy)),
                    IconButton(
                      icon: const Icon(Icons.file_copy),
                      onPressed: () => setState(() {
                        width = width == 4 ? 1 : 4;
                        length = length == 2 ? 1 : 2;
                      }),
                    )
                  ],
                ),
                Text(
                  "TITLdfscsdfdsE",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
                Text(
                  "Descriptiewwasdsdsasfdsdsfdson",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("32%", style: Theme.of(context).textTheme.bodySmall!),
                    Text("Since last month",
                        style: Theme.of(context).textTheme.bodySmall!),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class FileInfoStaggerdGridView extends StatelessWidget {
  List<StaggeredGridTile>? list;

  ///int 1: is crossCount
  ///int 2: is suggested crossCount for StraggeredGrid
  ///int 3: is suggested crossCountMod
  List<StaggeredGridTile> Function(int, int, int)? builder;
  bool wrapWithCard;
  FileInfoStaggerdGridView(
      {super.key,
      this.childAspectRatio = 1,
      this.wrapWithCard = false,
      this.builder,
      this.list})
      : assert(list != null || builder != null);

  final double childAspectRatio;

  int getCrossAxisCount(double width) {
    if (width < 500 && width > 0) {
      return 2;
    } else if (width < 1000 && width > 500) {
      return 4;
    } else {
      int val = ((width / 300)).toInt();
      debugPrint("getCrossAxisCount val   $val");
      return val;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("FileInfoStaggerdGridView====> wrapWithCard $wrapWithCard");
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = getCrossAxisCount(constraints.maxWidth);
      bool isMezouj = crossAxisCount % 2 == 0;
      debugPrint(
          "FileInfoStaggerdGridView====> width:${constraints.maxWidth} isMezouj: $isMezouj   crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4} ");
      int crossCountFund = crossAxisCount ~/ 4;
      int crossAxisCountMod = crossAxisCount % 4;
      int crossCountFundCalc = crossAxisCountMod == 0 ? crossCountFund : 1;

      debugPrint(
          "FileInfoStaggerdGridView====> isMezouj: $isMezouj  crossCountFundCalc $crossCountFundCalc crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4}  crossCountFundCalc + crossAxisCountMod =${crossCountFundCalc + crossAxisCountMod}");
      if (builder != null) {
        list = builder!
            .call(crossAxisCount, crossCountFundCalc, crossAxisCountMod);
      }
      return StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: wrapWithCard
              ? list!
                  .map((e) => Card(
                        child: e,
                      ))
                  .toList()
              : list!);
    });
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => const ChartCardItem(),
    );
  }
}
