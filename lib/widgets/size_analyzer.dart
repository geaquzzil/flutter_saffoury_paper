import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/products/analysis/products_analyzer_calc.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/cruds/components/skeleton_paragraph.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class SizeAnalyzerPage extends BasePage {
  RequestOptions requestOptions;
  final dynamic searchQuery;
  SizeAnalyzerPage({
    super.key,
    super.onBuild,
    super.parent,
    super.buildDrawer = false,
    super.isFirstToSecOrThirdPane = true,
    this.searchQuery,
    required this.requestOptions,
  });

  @override
  State<SizeAnalyzerPage> createState() => _SizeAnalyzerPageState();
}

class _SizeAnalyzerPageState extends BasePageState<SizeAnalyzerPage>
    with BasePageSecoundPaneNotifierState<SizeAnalyzerPage> {
  late RequestOptions _requestOptions;
  final ValueNotifier<bool> _onListBuilded = ValueNotifier<bool>(false);
  final listKey = GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'list');
  SortFieldValue? _sortFieldValue;

  final ValueNotifier<List?> _listNotifier = ValueNotifier(null);
  WasteEnum _wasteEnum = WasteEnum.waste2;
  @override
  void initState() {
    super.initState();
    _requestOptions = widget.requestOptions;
    _sortFieldValue = Product().getSortByInitialType();
  }

  @override
  Widget? getAppbarTitle({bool? firstPane, TabControllerHelper? tab}) {
    return firstPane == true
        ? HeaderDescription(
            title: AppLocalizations.of(
              context,
            )!.searchInFormat(widget.searchQuery),
          )
        : null;
  }

  @override
  Widget? getFloatingActionButton({bool? firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableExpandedHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) {
    return null;
  }

  @override
  bool enableAutomaticFirstPaneNullDetector() {
    return false;
  }

  @override
  List<Widget>? getPaneNotifier({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
    SecondPaneHelper? valueNotifier,
  }) {
    if (firstPane) {
      return [
        SliverPersistantContainer(
          // floating: true,
          pinned: true,
          minExtent: 110,
          maxExtent: 110,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: _listNotifier,
                  builder: (context, value, child) {
                    debugPrint("ListToDet=> fff $value");
                    return FiltersAndSelectionListHeaderValueNotifier(
                      width: firstPaneWidth,
                      preWidgets: [
                        DropdownEnumControllerListenerByIcon(
                          initialValue: _wasteEnum,
                          showSelectedValueBeside: true,
                          viewAbstractEnum: _wasteEnum,
                          onSelected: (object) {
                            RequestOptions? op = Product()
                                .getOnlyInventory()
                                .copyWithObjcet(
                                  option: Product()
                                      .getRequestOptionsPassedOnString(
                                        widget.searchQuery,
                                        maxWaste: object?.value,
                                      ),
                                );
                            if (op == _requestOptions) {
                              return;
                            }
                            if (object == null) return;
                            setState(() {
                              _wasteEnum = object;
                              _requestOptions = op;
                            });
                          },
                        ),
                      ],
                      disableFiltering: true,
                      viewAbstract: Product(),
                      valueNotifer: _listNotifier,
                      sortInitial: _sortFieldValue,

                      onDoneSort: (sort) {
                        setState(() {
                          _sortFieldValue = sort;
                          _requestOptions = _requestOptions.copyWith(
                            sortBy: _sortFieldValue,
                          );
                        });
                      },
                      // onDoneFilter: ,
                      secPaneNotifer: getSecoundPaneHelper(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SliverApiMixinViewAbstractWidget(
          key: listKey,
          valueListProviderNotifier: _listNotifier,

          // onFinishCalling: _onListBuilded,
          requiresFullFetsh: true,
          isSelectForCard: (object) {
            return isSelectForCard(object);
          },
          header: HeaderDescription(
            isSliver: true,
            title: "",
            // trailing: SizedBox(
            //   width: firstPaneWidth * .4,
            //   child:
            // ),
          ),
          toListObject: Product().setRequestOption(option: _requestOptions),
          state: getSecoundPaneHelper(),
          hasCustomCardItemBuilder: (idx, item) {
            return ProductSizeAnalyzerCard(
              state: getSecoundPaneHelper(),
              product: item as Product,
              requestOptions: _requestOptions,
            );
          },

          // onClickForCard: (object) {

          // },
          onResponseAddCustomWidget: (_, _, _, _) {
            var totals = listKey.currentState
                ?.getList<Product>()
                .getTotalQuantityGrouped();
            if (totals == null) return null;
            return [
              StaggerdGridViewWidget(
                isSliver: false,
                childAspectRatio: 1,
                wrapWithCard: false,
                builder:
                    (
                      fullCrossAxisCount,
                      crossCountFundCalc,
                      crossAxisCountMod,
                      heightMainAxisCellCount,
                    ) {
                      return [
                        ...totals.entries.map(
                          (e) => StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: .5,
                            child: ChartCardItemCustom(
                              title: e.key.getFieldLabelString(context, e.key),
                              // color: list[0].getMainColor(),
                              description: e.value.toCurrencyFormat(symbol: ""),
                            ),
                          ),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: .5,
                          child: ChartCardItemCustom(
                            title: AppLocalizations.of(context)!.total,
                            // color: list[0].getMainColor(),
                            description:
                                listKey.currentState
                                    ?.getList<Product>()
                                    .getTotalQuantityGroupedFormattedText(
                                      context,
                                    ) ??
                                "-",
                          ),
                        ),
                      ];
                    },
              ),
            ];
          },
        ),

        // ValueListenableBuilder<bool>(
        //   valueListenable: _onListBuilded,
        //   builder: (_, value, _) {
        //     // return LoadingScreen(
        //     //   isSliver: true,
        //     //   isPage: false,
        //     //   width: secPaneWidth,
        //     // );
        //     if (!value) {
        //       return SliverToBoxAdapter(child: SizedBox());
        //     }
        //     // return SliverToBoxAdapter(child: SizedBox());
        //     var totals = listKey.currentState
        //         ?.getList<Product>()
        //         .getTotalQuantityGrouped();
        //     debugPrint("tototo $totals");
        //     if (totals == null) {
        //       return SliverToBoxAdapter(child: SizedBox());
        //     }
      ];
    }
    return [];
    return [
      ValueListenableBuilder<bool>(
        valueListenable: _onListBuilded,
        builder: (_, value, _) {
          // return LoadingScreen(
          //   isSliver: true,
          //   isPage: false,
          //   width: secPaneWidth,
          // );
          if (!value) {
            return LoadingScreen(
              isSliver: true,
              isPage: false,
              width: secPaneWidth,
            );
          }
          return SliverFillRemaining(
            child: Product().getPrintPage(
              context,
              list: listKey.currentState?.getList(),
              type: PrintPageType.self_list,
              parent: getSecoundPaneHelper(),
            ),
          );
        },
      ),
    ];
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) => false;

  @override
  String onActionInitial() => AppLocalizations.of(context)!.size_analyzer;

  @override
  bool setClipRect(bool? firstPane) => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) => firstPane;
}
