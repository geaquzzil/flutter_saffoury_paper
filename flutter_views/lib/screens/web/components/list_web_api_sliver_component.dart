import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/encyptions/compressions.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
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
import 'package:flutter_view_controller/screens/on_hover_button.dart';
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

import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ListWebApiSliverComponent extends StatelessWidget {
  final String? searchQuery;
  final String? customFilter;
  Map<String, FilterableProviderHelper>? customFilterChecker;
  ViewAbstract viewAbstract;

  late ListMultiKeyProvider listProvider;
  ValueNotifier<bool>? valueNotifierGrid;
  ValueNotifier<ViewAbstract?>? onCardTap;

  ///web version converts to hover actions and changed to list item from 20 to 10 if desktop or 4 if mobile and adds button on hover to go to next page
  final bool buildWebVersion;
  ListWebApiSliverComponent(
      {Key? key,
      this.searchQuery,
      this.customFilter,
      required this.viewAbstract,
      this.onCardTap,
      this.buildWebVersion = false,
      bool buildFooter = false,
      bool useSmallFloatingBar = true,
      this.valueNotifierGrid,
      Widget? customSliverWidget,
      bool buildHeader = false})
      : super(
          key: key,
        );
  void fetshListWidgetBinding(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList(context);
    });
  }

  void init(BuildContext context) {
    if (customFilter != null) {
      Map<String, dynamic> map =
          Compression.uncompress(customFilter!) as Map<String, dynamic>;

      Map<String, FilterableProviderHelper> jsonMap = {};
      for (var element in map.entries) {
        jsonMap[element.key] = FilterableProviderHelper.fromJson(element.value);
      }
      customFilterChecker = jsonMap;
      // onFilterable.value = jsonMap;
      // debugPrint("onFilterable ${onFilterable.value}");
    } else {
      customFilterChecker = null;
    }
    valueNotifierGrid ??= ValueNotifier<bool>(false);
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    fetshListWidgetBinding(context);
  }

  void fetshList(BuildContext context) {
    String customKey = findCustomKey();
    if (listProvider.getCount(customKey) == 0) {
      fetshListNotCheckingZero(context);
    }
  }

  void fetshListNotCheckingZero(BuildContext context) {
    String customKey = findCustomKey();
    if (customFilterChecker != null) {
      viewAbstract.setFilterableMap(customFilterChecker!);
      customKey = findCustomKey();
      listProvider.fetchList(customKey,
          viewAbstract: viewAbstract,
          customCount: buildWebVersion == false
              ? null
              : isDesktop(context)
                  ? 8
                  : 4);
    } else if (searchQuery == null) {
      listProvider.fetchList(customKey,
          viewAbstract: viewAbstract,
          customCount: buildWebVersion == false
              ? null
              : isDesktop(context)
                  ? 8
                  : 4);
    } else {
      listProvider.fetchListSearch(customKey, viewAbstract, searchQuery!);
    }
  }

  Widget getEmptyWidget(BuildContext context, {bool isError = false}) {
    return SliverFillRemaining(
      child: _getEmptyWidget(context, isError),
    );
  }

  Widget _getEmptyWidget(BuildContext context, bool isError) {
    return Center(
      child: EmptyWidget(
          expand: false,
          onSubtitleClicked: isError
              ? () {
                  fetshList(context);
                }
              : null,
          lottiUrl:
              "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
          title: isError
              ? AppLocalizations.of(context)!.cantConnect
              : AppLocalizations.of(context)!.noItems,
          subtitle: isError
              ? AppLocalizations.of(context)!.cantConnectConnectToRetry
              : AppLocalizations.of(context)!.no_content),
    );
  }

  Widget getShimmerLoading(
      BuildContext context, SliverConstraints constraints) {
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
      BuildContext context, SliverConstraints constraints) {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        // List<Widget> widgets;
        debugPrint("SliverApiMaster building widget: ${findCustomKey()}");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;

        if (isLoading) {
          if (count == 0) {
            if (valueNotifierGrid!.value) {
              return getShimmerLoading(context, constraints);
            } else {
              return getShimmerLoadingList();
            }
          }
        } else {
          if (count == 0 || isError) {
            return getEmptyWidget(context, isError: isError);
          }
        }
        return ValueListenableBuilder<bool>(
          valueListenable: valueNotifierGrid!,
          builder: (context, value, child) {
            if (value) {
              return getGridList(constraints,
                  listProvider.getList(findCustomKey()), isLoading);
            } else {
              return getSliverList(context, constraints, count, isLoading);
            }
          },
        );
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
          p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
    );
  }

  Widget getShimmerLoadingList() {
    return SliverFillRemaining(
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [
            Color(0xFFD8E3E7),
            Color(0xFFC8D5DA),
            Color(0xFFD8E3E7),
          ],
          stops: [
            0.1,
            0.5,
            0.9,
          ],
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [
            Color(0xFF222222),
            Color(0xFF242424),
            Color(0xFF2B2B2B),
            Color(0xFF242424),
            Color(0xFF222222),
            // Color(0xFF242424),
            // Color(0xFF2B2B2B),
            // Color(0xFF242424),
            // Color(0xFF222222),
          ],
          stops: [
            0.0,
            0.2,
            0.5,
            0.8,
            1,
          ],
          // begin: Alignment(-2.4, -0.2),
          // end: Alignment(2.4, 0.2),
          // tileMode: TileMode.clamp,
        ),
        child: SkeletonListView(
          itemCount: viewAbstract.getPageItemCount,
        ),
      ),
    );
  }

  Widget getSharedLoadingItem(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(kDefaultPadding / 2),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget getSliverList(BuildContext context, SliverConstraints constraints,
      int count, bool isLoading) {
    return getSliverPadding(
      context,
      constraints,
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        if (isLoading && index == count) {
          return getSharedLoadingItem(context);
        }
        ViewAbstract va = listProvider.getList(findCustomKey())[index];
        return ListCardItemWeb(
          object: va,
          onTap: () {
            onCardTap?.value = va;
          },
        );
      }, childCount: count + (isLoading ? 1 : 0))),
    );
  }

  String findCustomKey() {
    String key = viewAbstract.getListableKey();
    return key + (searchQuery == null ? "" : searchQuery!);
  }

  Widget _getFilterHeader(BuildContext context) {
    return SliverToBoxAdapter(
        child: ResponsiveWebBuilderSliver(
      builder: (context, width) => Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FiltersAndSelectionListHeader(
              customKey: findCustomKey(),
              listProvider: listProvider,
              viewAbstract: viewAbstract,
            ),
            HorizontalFilterableSelectedList(
              onFilterable: customFilterChecker,
              onFilterableChanged: (onFilter) {
                if (onFilter == null) {
                  context.goNamed(indexWebOurProducts);
                } else {
                  context.goNamed(indexWebOurProducts, queryParameters: {
                    "filter": Compression.compress(onFilter)
                  });
                }
              },
            )
          ],
        ),
      ),
    ));
  }

  Widget _getHeaderTitle(BuildContext context) {
    return SliverToBoxAdapter(
      child: HeaderText(
          fontSize: 25,
          text: searchQuery != null
              ? "Search results: “$searchQuery“"
              : customFilterChecker != null
                  ? "Showing products by filter"
                  : "Showing products",
          description: searchQuery != null || customFilterChecker != null
              ? Html(
                  data:
                      "Search results may appear roughly depending on the user's input and may take some time, so please be patient :)",
                )
              : null),
    );
  }

  static Future<dynamic> showFilterDialog(
      BuildContext context, ViewAbstract viewAbstract) {
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

  Widget getSliverPadding(
      BuildContext context, SliverConstraints constraints, Widget child,
      {double padd = 2}) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: max((constraints.crossAxisExtent - 1200) / padd, 0) > 15
                ? max((constraints.crossAxisExtent - 1200) / padd, 0)
                : 15),
        sliver: child);
  }

  SliverPadding getGridList(SliverConstraints constraints,
      List<ViewAbstract<dynamic>> list, bool isLoading) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: max((constraints.crossAxisExtent - 1200) / 2, 0) > 15
              ? max((constraints.crossAxisExtent - 1200) / 2, 0)
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

  @override
  Widget build(BuildContext context) {
    init(context);
    return SliverLayoutBuilder(
        builder: (p0, constraints) => getListSelector(context, constraints));
  }
}
