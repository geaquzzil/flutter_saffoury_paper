import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_search_api.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';
import 'package:flutter_view_controller/screens/web/components/header_text.dart';
import 'package:flutter_view_controller/screens/web/components/web_button.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProductWebPage extends BaseWebPageSlivers {
  final String? searchQuery;
  late ViewAbstract viewAbstract;
  ValueNotifier<Map<String, FilterableProviderHelper>?> onFilterable =
      ValueNotifier<Map<String, FilterableProviderHelper>?>(null);
  late ListMultiKeyProvider listProvider;
  ProductWebPage({Key? key, this.searchQuery}) : super(key: key);
  void fetshListWidgetBinding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }

  void fetshList() {
    String customKey = findCustomKey();
    if (listProvider.getCount(customKey) == 0) {
      if (searchQuery == null) {
        listProvider.fetchList(customKey, viewAbstract);
      } else {
        listProvider.fetchListSearch(
            findCustomKey(), viewAbstract, searchQuery!);
      }
    }
  }

  Widget getEmptyWidget(BuildContext context, {bool isError = false}) {
    return SliverFillRemaining(
      child: _getEmptyWidget(context, isError),
    );
  }

  EmptyWidget _getEmptyWidget(BuildContext context, bool isError) {
    return EmptyWidget(
        onSubtitleClicked: isError
            ? () {
                fetshList();
              }
            : null,
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        title: isError
            ? AppLocalizations.of(context)!.cantConnect
            : AppLocalizations.of(context)!.noItems,
        subtitle: isError
            ? AppLocalizations.of(context)!.cantConnectConnectToRetry
            : AppLocalizations.of(context)!.no_content);
  }

  Widget getShimmerLoading(BuildContext context, BoxConstraints constraints) {
    return getSliverPadding(
      context,
      constraints,
      ResponsiveSliverGridList(
          horizontalGridSpacing: 50, // Horizontal space between grid items
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
          children: [
            ...List.generate(5 + Random().nextInt(10 - 5),
                (index) => ListHorizontalItemShimmer())
          ]),
    );
  }

  Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>> getListSelector(
      BuildContext context, BoxConstraints constraints) {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        // List<Widget> widgets;
        debugPrint("SliverApiMaster building widget: ${findCustomKey()}");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;

        if (isLoading) {
          if (count == 0) {
            return getShimmerLoading(context, constraints);
          }
        } else {
          if (count == 0 || isError) {
            return getEmptyWidget(context, isError: isError);
          }
        }
        return getGridList(
            constraints, listProvider.getList(findCustomKey()), isLoading);
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
          p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
    );
  }

  String findCustomKey() {
    String key = viewAbstract.getListableKey();
    return key + (searchQuery == null ? "" : searchQuery!);
  }

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    viewAbstract = context.read<AuthProvider>().getWebCategories()[0];

    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    fetshListWidgetBinding();
    return [
      if (searchQuery != null)
        SliverToBoxAdapter(
          child: Column(
            children: [
              HeaderText(
                  fontSize: 25,
                  text: "Search results: “$searchQuery“",
                  description: Html(
                    data:
                        "Search results may appear roughly depending on the user's input and may take some time, so please be patient :)",
                  )),
              ResponsiveWebBuilder(
                  builder: (context, width) => WebButton(
                        title: "TRY FILTER THINGS",
                        onPressed: () async {
                          await showDialogExt(
                            barrierDismissible: true,
                            // anchorPoint: const Offset(1000, 1000),
                            context: context,
                            builder: (p0) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 500,
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: 500,
                                        child: BaseFilterableMainWidget(
                                          onDoneClickedPopResults: () {},
                                          viewAbstract: viewAbstract,
                                          useDraggableWidget: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).then((value) {
                            //                             ViewAbstract? v = context.read<DrawerMenuControllerProvider>().getObject;
                            // v.setFilterableMap(context.read<FilterableProvider>().getList);
                            // context.read<DrawerMenuControllerProvider>().changeWithFilterable(context, v);
                          });
                        },
                      ))
            ],
          ),
        ),

      getListSelector(context, constraints)
      // SliverToBoxAdapter(
      //   child: WebProductList(
      //       searchQuery: searchQuery,
      //       customHeight: MediaQuery.of(context).size.height,
      //       viewAbstract: context.read<AuthProvider>().getWebCategories()[0]),
      // ),
      // FutureBuilder<List<dynamic>?>(
      //   future: searchQuery != null
      //       ? viewAbstract.search(20, 0, searchQuery!)
      //       : viewAbstract.listCall(
      //           count: ScreenHelper.isDesktop(context) ? 20 : 4, page: 0),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const SliverFillRemaining(
      //           child: Center(child: CircularProgressIndicator()));
      //     }
      //     List<ViewAbstract>? list = snapshot.data?.cast();
      //     if (list == null) {
      //       return Container();
      //     }

      //     return getGridList(constraints, list);
      //   },
      // ),

      // SliverSearchApi(
      //     viewAbstract: context.read<AuthProvider>().getWebCategories()[0],
      //     searchQuery: searchQuery ?? "")
    ];
    // return Expanded(
  }

  @override
  void isScrolled(BuildContext context) {
    if (searchQuery == null) {
      listProvider.fetchList(findCustomKey(), viewAbstract);
    } else {
      listProvider.fetchListSearch(findCustomKey(), viewAbstract, searchQuery!);
    }
  }

  SliverPadding getGridList(BoxConstraints constraints,
      List<ViewAbstract<dynamic>> list, bool isLoading) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: max((constraints.maxWidth - 1200) / 2, 0) > 15
              ? max((constraints.maxWidth - 1200) / 2, 0)
              : 15),
      sliver: ResponsiveSliverGridList(
          horizontalGridSpacing: 50, // Horizontal space between grid items
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
          children: [
            ...list
                .map((e) => WebGridViewItem(
                      item: e,
                      setDescriptionAtBottom: true,
                    ))
                .toList(),
            if (isLoading)
              ...List.generate(5, (index) => ListHorizontalItemShimmer())
          ]),
    );
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
