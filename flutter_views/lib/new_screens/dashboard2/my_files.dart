import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';

import 'components/chart_card_item.dart';
import 'dashboard.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Files",
              style: Theme.of(context).textTheme.subtitle1,
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
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoStaggerdGridView(
            crossAxisCount: _size.width < 750 ? 2 : 4,
            childAspectRatio: _size.width < 750 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoStaggerdGridView(),
          desktop: FileInfoStaggerdGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class TestExpanded extends StatefulWidget {
  TestExpanded({Key? key}) : super(key: key);

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
          shape: RoundedRectangleBorder(
            side: BorderSide(
                // color: Theme.of(context).colorScheme.outline,
                ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              // color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.all(defaultPadding / 8),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          // color: Colors.orange.withOpacity(0.1),
                          // color: info.color!.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(Icons.file_copy)),
                    IconButton(
                      icon: Icon(Icons.file_copy),
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
                  style: Theme.of(context).textTheme.caption!,
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
                    Text("32%", style: Theme.of(context).textTheme.caption!),
                    Text("Since last month",
                        style: Theme.of(context).textTheme.caption!),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class FileInfoStaggerdGridView extends StatelessWidget {
  const FileInfoStaggerdGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        TestExpanded(),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: wrapContainer("2", Colors.brown),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: wrapContainer("3", Colors.amber),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: wrapContainer("4", Colors.blue),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: wrapContainer("5", Colors.orange),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: .75,
          child: wrapContainer("5", Colors.orange),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: .75,
          child: wrapContainer("5", Colors.orange),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: .75,
          child: wrapContainer("5", Colors.orange),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: .75,
          child: wrapContainer("5", Colors.orange),
        ),
      ],
    );
  }

  Widget wrapContainer(String text, Color color) {
    return Container(
      // color: color,
      child: ChartCardItem(),
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => ChartCardItem(),
    );
  }
}
