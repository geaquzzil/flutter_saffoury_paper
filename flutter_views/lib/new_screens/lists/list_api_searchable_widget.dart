import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_list_page.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page.dart';
import 'package:flutter_view_controller/printing_generator/pdf_self_list_api.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:skeletons/skeletons.dart';

import '../../new_components/edit_listeners/controller_dropbox_enum_icon.dart';
import '../../new_components/loading_shimmer.dart';
import '../../printing_generator/page/pdf_self_list_page.dart';
import '../../providers/filterables/filterable_provider.dart';
import '../filterables/filterable_icon_widget.dart';
import '../filterables/horizontal_selected_filterable.dart';
import '../home/components/ext_provider.dart';

class ListApiSearchableWidget<T extends ViewAbstract> extends StatefulWidget {
  const ListApiSearchableWidget({Key? key}) : super(key: key);

  @override
  State<ListApiSearchableWidget> createState() => _ListApiWidgetState();
}

class _ListApiWidgetState<T extends ViewAbstract>
    extends State<ListApiSearchableWidget<T>> {
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  late DrawerViewAbstractListProvider drawerViewAbstractObsever;
  TextEditingController controller = TextEditingController();
  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    drawerViewAbstractObsever =
        Provider.of<DrawerViewAbstractListProvider>(context, listen: false);
    drawerViewAbstractObsever.addListener(onChangedViewAbstract);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listProvider.fetchList(
          getCustomKey(), drawerViewAbstractObsever.getObject);
    });
  }

  String getCustomKey({String? searchTextKey}) {
    String key =
        "${drawerViewAbstractObsever.getObject.getTableNameApi()}listAPI";
    return searchTextKey == null ? key : key + searchTextKey;
  }

  String findCustomKey() {
    return getCustomKey(
        searchTextKey: controller.text.isEmpty ? null : controller.text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.text = "";
  }

  List getList() {
    return listProvider.getList(findCustomKey());
  }

  dynamic getFirstObject() {
    List list = listProvider.getList(findCustomKey());
    dynamic first = list[0];
    return first;
  }

  bool hasItems() {
    List l = getList();
    return l.isNotEmpty && l.length > 2;
  }

  bool hasPrintWidget() {
    if (!hasItems()) return false;
    var first = getFirstObject();

    return first is PrintableSelfListInterface || first is PrintableMaster;
  }

  Widget? getFilterWidget() {
    return FilterablePopupIconWidget();
  }

  Widget? getPrintWidget() {
    var first = getFirstObject();
    if (first is PrintableSelfListInterface && first is PrintableMaster) {
      String? printListSetting =
          "${AppLocalizations.of(context)!.printAllAs(AppLocalizations.of(context)!.list)} ${AppLocalizations.of(context)!.action_settings.toLowerCase()}";
      ;
      String? printSelfListSetting =
          "${AppLocalizations.of(context)!.printAllAs(drawerViewAbstractObsever.getObject.getMainHeaderLabelTextOnly(context))} ${AppLocalizations.of(context)!.action_settings.toLowerCase()}";
      return DropdownStringListControllerListenerByIcon(
        icon: Icons.print,
        hint: AppLocalizations.of(context)!.printType,
        list: [
          DropdownStringListItem(
              Icons.print,
              AppLocalizations.of(context)!
                  .printAllAs(AppLocalizations.of(context)!.list)),
          DropdownStringListItem(
              Icons.print,
              AppLocalizations.of(context)!.printAllAs(drawerViewAbstractObsever
                  .getObject
                  .getMainHeaderLabelTextOnly(context))),
          DropdownStringListItem(
              Icons.settings,
              enabled: false,
              AppLocalizations.of(context)!.printerSetting),
          DropdownStringListItem(Icons.settings, printListSetting),
          DropdownStringListItem(Icons.settings, printSelfListSetting),
        ],
        onSelected: (object) {
          if (object?.label ==
              AppLocalizations.of(context)!
                  .printAllAs(AppLocalizations.of(context)!.list)) {
            changeToPrintPdfSelfList();
          } else if (object?.label == printListSetting) {
            context
                .read<ActionViewAbstractProvider>()
                .changeCustomWidget(BaseEditNewPage(
                  onFabClickedConfirm: (obj) {
                    context
                        .read<ActionViewAbstractProvider>()
                        .changeCustomWidget(PdfSelfListPage(
                            setting: obj as PrintLocalSetting,
                            list:
                                getList().cast<PrintableSelfListInterface>()));
                  },
                  viewAbstract: (drawerViewAbstractObsever.getObject
                          as PrintableSelfListInterface)
                      .getModifiablePrintableSelfPdfSetting(context),
                ));
          } else if (object?.label == printSelfListSetting) {
          } else {
            changeToPrintPdfList();
          }
        },
      );
    }
    if (first is PrintableMaster) {
      return IconButton(
          onPressed: () {
            changeToPrintPdfList();
          },
          icon: const Icon(Icons.print));
    } else if (first is PrintableSelfListInterface) {
      return IconButton(
          onPressed: () {
            changeToPrintPdfSelfList();
          },
          icon: const Icon(Icons.print));
    } else {
      return null;
    }
  }

  void changeToPrintPdfList() {
    context.read<ActionViewAbstractProvider>().changeCustomWidget(PdfListPage(
        list: listProvider
            .getList(findCustomKey())
            .whereType<PrintableMaster>()
            .toList()));
  }

  void changeToPrintPdfSelfList() {
    context
        .read<ActionViewAbstractProvider>()
        .changeCustomWidget(PdfSelfListPage(
          list: listProvider
              .getList(findCustomKey())
              .whereType<PrintableSelfListInterface>()
              .toList(),
        ));
  }

  Widget getRefreshWidget() => IconButton(
      onPressed: () {
        _refresh();
      },
      icon: const Icon(Icons.refresh));

  Widget getAddBotton() => IconButton(
      onPressed: () {
        drawerViewAbstractObsever.getObject.onDrawerLeadingItemClicked(context);
      },
      icon: const Icon(Icons.add));
  Widget getTrailingWidget() {
    return IconButton(
      icon: const Icon(Icons.cancel),
      onPressed: () {
        controller.clear();
        onSearchTextChanged('');
      },
    );
    return controller.text.isEmpty
        ? IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          )
        : const CircularProgressIndicator(
            strokeWidth: 2,
          );
  }

  void _refresh() {
    listProvider.refresh(findCustomKey(), drawerViewAbstractObsever.getObject);
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.search),
          title: TextField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: 'Search', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: getTrailingWidget(),
        ),
      ),
    );
  }

  Widget _listItems(
      List<ViewAbstract> data, ListMultiKeyProvider listProvider) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: listProvider.isLoading(findCustomKey())
          ? (data.length + 1)
          : (data.length),
      itemBuilder: (context, index) {
        if (listProvider.isLoading(findCustomKey()) && index == data.length) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Loading..."),
                SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )),
              ],
            ),
          ));
        }
        return ListCardItem(object: data[index]);
        // return data[index].getCardView(context);
      },
      // ),
    );
  }

  bool hasFilterable() {
    return context
        .watch<FilterableProvider>()
        .getList
        .values
        .toList()
        .isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    Widget? printButton =
        (context.watch<ListMultiKeyProvider>().getList(findCustomKey()).length >
                2)
            ? getPrintWidget()
            : null;

    Widget? filterButton =
        (context.watch<ListMultiKeyProvider>().getList(findCustomKey()).length >
                2)
            ? getFilterWidget()
            : null;
    return Column(
      children: <Widget>[
        Container(child: _buildSearchBox()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (filterButton != null) filterButton,
              DropdownStringListControllerListenerByIcon(
                  icon: Icons.sort_by_alpha,
                  hint: AppLocalizations.of(context)!.sortBy,
                  list: drawerViewAbstractObsever.getObject
                      .getMainFieldsIconsAndValues(context),
                  onSelected: (obj) {
                    debugPrint("is selected ${obj.runtimeType}");
                    if (obj == null) {
                      removeFilterableSelected(
                          context, drawerViewAbstractObsever.getObject);
                    } else {
                      listProvider.clear(findCustomKey());
                      addFilterableSortField(
                          context, obj.value.toString(), obj.label);
                    }
                    notifyListApi(context);
                    debugPrint("is selected $obj");
                  }),
              DropdownEnumControllerListenerByIcon<SortByType>(
                viewAbstractEnum: SortByType.ASC,
                onSelected: (object) {
                  // listProvider.clear(findCustomKey());
                  addFilterableSort(context, object as SortByType);
                  notifyListApi(context);
                },
              ),
              const Spacer(),
              getAddBotton(),
              getRefreshWidget(),
              if (printButton != null) printButton
            ],
          ),
        ),
        if (hasFilterable()) HorizontalFilterableSelectedList(),
        Expanded(
            child: ChangeNotifierProvider.value(
          value: listProvider,
          child: Consumer<ListMultiKeyProvider>(
              builder: (context, provider, listTile) {
            if (provider.isLoading(findCustomKey())) {
              if (provider.getCount(findCustomKey()) == 0) {
                return getShimmerLoading(context);
              }
            } else {
              if (provider.getCount(findCustomKey()) == 0) {
                return getEmptyWidget(context);
              } else {}
            }

            debugPrint("List api provider loaded ${listProvider.isLoading}");
            return _listItems(
                listProvider.getList(findCustomKey()), listProvider);
          }),
        )),
      ],
    );
  }

  Widget getEmptyWidget(BuildContext context) {
    return Center(
      child: EmptyWidget(
          lottiUrl:
              "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
          title: AppLocalizations.of(context)!.noItems,
          subtitle: AppLocalizations.of(context)!.error_empty),
    );
  }

  Widget getShimmerLoading(BuildContext context) {
    return Skeleton(
      isLoading: true,
      skeleton: SkeletonListView(
        itemCount: 5,
      ),
      child: Container(child: Center(child: Text("Content"))),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    debugPrint(" IS _onScroll $_isBottom");
    if (_isBottom) {
      debugPrint(" IS BOTTOM $_isBottom");
      if (controller.text.isEmpty) {
        listProvider.fetchList(
            getCustomKey(), drawerViewAbstractObsever.getObject);
      } else {
        listProvider.fetchListSearch(
            getCustomKey(searchTextKey: controller.text),
            drawerViewAbstractObsever.getObject,
            controller.text);
      }
    }
  }

  onSearchTextChanged(String text) async {
    await Future.delayed(
      const Duration(milliseconds: 750),
      () {
        listProvider.fetchListSearch(
            getCustomKey(searchTextKey: controller.text),
            drawerViewAbstractObsever.getObject,
            controller.text);
        // setState(() {});
      },
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void onChangedViewAbstract() {
    if (mounted) {
      listProvider.fetchList(getCustomKey(), drawerViewAbstractObsever.object);
      debugPrint("ViewAbstractProvider CHANGED");
    }
  }
}
