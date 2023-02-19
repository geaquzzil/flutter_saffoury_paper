import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_search_api.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';
import 'package:flutter_view_controller/screens/web/components/header_text.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class ProductWebPage extends BaseWebPageSlivers {
  final String? searchQuery;
  ProductWebPage({Key? key, this.searchQuery}) : super(key: key);

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    ViewAbstract viewAbstract =
        context.read<AuthProvider>().getWebCategories()[0];
    return [
      if (searchQuery != null)
        SliverToBoxAdapter(
          child: HeaderText(
              fontSize: 25,
              text: "Search results: “$searchQuery“",
              description: Html(
                data: "Showing 1 - 6 of 31 results",
              )),
        ),
      // SliverToBoxAdapter(
      //   child: WebProductList(
      //       searchQuery: searchQuery,
      //       customHeight: MediaQuery.of(context).size.height,
      //       viewAbstract: context.read<AuthProvider>().getWebCategories()[0]),
      // ),
      FutureBuilder<List<dynamic>?>(
        future: searchQuery != null
            ? viewAbstract.search(20, 0, searchQuery!)
            : viewAbstract.listCall(
                count: ScreenHelper.isDesktop(context) ? 20 : 4, page: 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()));
          }
          List<ViewAbstract>? list = snapshot.data?.cast();
          if (list == null) {
            return Container();
          }

          return SliverPadding(
            padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: max((constraints.maxWidth - 1200) / 2, 0) > 15
                    ? max((constraints.maxWidth - 1200) / 2, 0)
                    : 15),
            sliver: ResponsiveSliverGridList(
                horizontalGridSpacing:
                    50, // Horizontal space between grid items
                verticalGridSpacing: 50, // Vertical space between grid items
                horizontalGridMargin: 50, // Horizontal space around the grid
                verticalGridMargin: 50, // Vertical space around the grid
                minItemsPerRow:
                    2, // The minimum items to show in a single row. Takes precedence over minItemWidth
                maxItemsPerRow:
                    4, // The maximum items to show in a single row. Can be useful on large screens
                sliverChildBuilderDelegateOptions:
                    SliverChildBuilderDelegateOptions(),
                minItemWidth: 200,
                children: list.map((e) => WebGridViewItem(item: e)).toList()),
          );
        },
      ),

      // SliverSearchApi(
      //     viewAbstract: context.read<AuthProvider>().getWebCategories()[0],
      //     searchQuery: searchQuery ?? "")
    ];
    // return Expanded(
    //   child: ResponsiveGridList(
    //     horizontalGridMargin: 50,
    //     verticalGridMargin: 50,
    //     minItemWidth: 100,
    //     children: List.generate(
    //       100,
    //       (index) => ColoredBox(
    //         color: Colors.lightBlue,
    //         child: Padding(
    //           padding: const EdgeInsets.all(32),
    //           child: Text(
    //             '$index',
    //             textAlign: TextAlign.center,
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     ScreenHelper(
    //       desktop: _buildUi(kDesktopMaxWidth),
    //       tablet: _buildUi(kTabletMaxWidth),
    //       mobile: _buildUi(getMobileMaxWidth(context)),
    //     )
    //   ],
    // );
  }

  Widget _buildUi(double width) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveWrapper(
            maxWidth: width,
            minWidth: width,
            defaultScale: false,
            child: Container(
              child: Flex(
                direction: constraints.maxWidth > 720
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  // Expanded(
                  //     flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  //     child: Container(
                  //       color: Colors.green,
                  //       child: Center(
                  //           child: Column(
                  //         children: [
                  //           ExpansionTile(title: Text("TISSUES")),
                  //           ExpansionTile(title: Text("Paper And Cardboard")),
                  //         ],
                  //       )),
                  //     )),
                  // Divider(),

                  // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                  Expanded(
                    flex: constraints.maxWidth > 720.0 ? 1 : 0,
                    child: WebProductList(
                        customHeight: MediaQuery.of(context).size.height - 100,
                        viewAbstract:
                            context.read<AuthProvider>().getWebCategories()[0]),
                  ),
                  // Divider(),
                  // Expanded(
                  //     flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  //     child:
                  //         Container(color: Colors.green, child: Text("END"))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
