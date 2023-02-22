import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/header.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/filterables/horizontal_selected_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_search_api.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';
import 'package:flutter_view_controller/screens/web/components/header_text.dart';
import 'package:flutter_view_controller/screens/web/components/web_button.dart';
import 'package:flutter_view_controller/screens/web/parallex/parallexes.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProductWebPage extends BaseWebPageSlivers {
  final String? searchQuery;
  final String? customFilter;
  Map<String, FilterableProviderHelper>? customFilterChecker;
  late ViewAbstract viewAbstract;
  ValueNotifier<Map<String, FilterableProviderHelper>?> onFilterable =
      ValueNotifier<Map<String, FilterableProviderHelper>?>(null);

  late ListMultiKeyProvider listProvider;

  ProductWebPage({Key? key, this.searchQuery, this.customFilter})
      : super(key: key);
  void fetshListWidgetBinding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }

  @override
  void init(BuildContext context) {
    super.init(context);
    if (customFilter != null) {
      Map<String, dynamic> map = jsonDecode(customFilter!);
      Map<String, FilterableProviderHelper> jsonMap = {};
      for (var element in map.entries) {
        jsonMap[element.key] = FilterableProviderHelper.fromJson(element.value);
      }
      customFilterChecker = jsonMap;
      onFilterable.value = jsonMap;
      debugPrint("onFilterable ${onFilterable.value}");
    } else {
      customFilterChecker = null;
    }
  }

  void fetshList() {
    String customKey = findCustomKey();
    if (listProvider.getCount(customKey) == 0) {
      fetshListNotCheckingZero();
    }
  }

  void fetshListNotCheckingZero() {
    String customKey = findCustomKey();
    if (customFilterChecker != null) {
      viewAbstract.setFilterableMap(customFilterChecker!);
      customKey = findCustomKey();
      listProvider.fetchList(customKey, viewAbstract);
    } else if (searchQuery == null) {
      listProvider.fetchList(customKey, viewAbstract);
    } else {
      listProvider.fetchListSearch(customKey, viewAbstract, searchQuery!);
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
    viewAbstract =
        context.read<AuthProvider>().getWebCategories()[0].getNewInstance();

    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    fetshListWidgetBinding();
    return [
      if (searchQuery == null)
        SliverToBoxAdapter(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                    fontSize: 25,
                    text: "Showing products",
                    description: Html(
                      data:
                          "Search results may appear roughly depending on the user's input and may take some time, so please be patient :)",
                    )),
                ResponsiveWebBuilder(
                  builder: (context, width) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WebButton(
                          title: "TRY FILTER THINGS",
                          primary: false,
                          onPressed: () async {
                            await showFilterDialog(context).then((value) {
                              onFilterable.value = value;
                              if (value == null) return;
                              // ViewAbstract? v = viewAbstract.getCopyInstance();
                              context.goNamed(indexWebOurProducts,
                                  queryParams: {'filter': jsonEncode(value)});
                              // viewAbstract.setFilterableMap(value);
                              // fetshList();

                              // context.read<DrawerMenuControllerProvider>().changeWithFilterable(context, v);
                            });
                          },
                        ),
                        ValueListenableBuilder(
                            valueListenable: onFilterable,
                            builder: (context, value, child) =>
                                HorizontalFilterableSelectedList(
                                    onFilterable: onFilterable)),
                        FiltersAndSelectionListHeader(
                          customKey: findCustomKey(),
                          listProvider: listProvider,
                          viewAbstract: viewAbstract,
                        ),
                      ],
                    );
                  },
                ),
              ]),
        ),
      if (searchQuery != null)
        SliverToBoxAdapter(
          child: ResponsiveWebBuilderSliver(
            builder: (context, width) => Column(
              children: [
                HeaderText(
                    fontSize: 25,
                    text: "Search results: “$searchQuery“",
                    description: Html(
                      data:
                          "Search results may appear roughly depending on the user's input and may take some time, so please be patient :)",
                    )),
                ValueListenableBuilder(
                    valueListenable: onFilterable,
                    builder: (context, value, child) =>
                        HorizontalFilterableSelectedList(
                            onFilterable: onFilterable)),
                WebButton(
                  title: "TRY FILTER THINGS",
                  onPressed: () async {
                    await showFilterDialog(context).then((value) {
                      onFilterable.value = value;
                      if (value == null) return;
                      // ViewAbstract? v = viewAbstract.getCopyInstance();

                      viewAbstract.setFilterableMap(value);
                      fetshList();
                      // context.read<DrawerMenuControllerProvider>().changeWithFilterable(context, v);
                    });
                  },
                )
              ],
            ),
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

  Future<dynamic> showFilterDialog(BuildContext context) {
    return showDialogExt(
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
                  borderRadius: BorderRadius.circular(15)),
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
    );
  }

  @override
  void isScrolled(BuildContext context) {
    fetshListNotCheckingZero();
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
