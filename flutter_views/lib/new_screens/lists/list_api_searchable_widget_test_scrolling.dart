import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_stateless.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
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
import 'list_api_master.dart';

class ListApiSearchableWidgetTestScrolling<T extends ViewAbstract>
    extends StatefulWidget {
  ListApiSearchableWidgetTestScrolling({Key? key}) : super(key: key);

  @override
  State<ListApiSearchableWidgetTestScrolling<T>> createState() =>
      _ListApiSearchableWidgetTestScrollingState<T>();
}

class _ListApiSearchableWidgetTestScrollingState<T extends ViewAbstract>
    extends State<ListApiSearchableWidgetTestScrolling<T>> {
  final _scrollController = ScrollController();

  late ListMultiKeyProvider listProvider;

  late DrawerViewAbstractListProvider drawerViewAbstractObsever;

  TextEditingController controller = TextEditingController();

  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  String getCustomKey({String? searchTextKey}) {
    String key = drawerViewAbstractObsever.getObject.getListableKey();

    debugPrint("getCustomKey $key");
    return searchTextKey == null ? key : key + searchTextKey;
  }

  String findCustomKey() {
    return getCustomKey(
        searchTextKey: controller.text.isEmpty ? null : controller.text);
  }

  Widget _listItems(
      List<ViewAbstract> data, ListMultiKeyProvider listProvider) {
    var listView = ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: listProvider.isLoading(findCustomKey()) ||
              listProvider.isHasError(findCustomKey())
          ? (data.length + 1)
          : (data.length),
      itemBuilder: (context, index) {
        if (listProvider.isLoading(findCustomKey()) && index == data.length) {
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          return getLoadingItem();
        } else if (listProvider.isHasError(findCustomKey())) {
          return Text("ERROR");
        }
        return ListCardItemStateless(object: data[index]);
        // return data[index].getCardView(context);
      },
      // ),
    );
    return listView;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    drawerViewAbstractObsever =
        Provider.of<DrawerViewAbstractListProvider>(context, listen: false);
    drawerViewAbstractObsever.addListener(onChangedViewAbstract);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ListMultiKeyProvider>()
          .fetchList(getCustomKey(), drawerViewAbstractObsever.getObject);
    });
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ListApiSearchableWidgetTestScrolling");
    return Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.loose,
        children: [
          ChangeNotifierProvider.value(
            value: listProvider,
            child: Consumer<ListMultiKeyProvider>(
                builder: (context, provider, listTile) {
              debugPrint(
                  "ListApiSearchableWidgetTestScrolling ChangeNotifierProvider");
              if (provider.isLoading(findCustomKey())) {
                if (provider.getCount(findCustomKey()) == 0) {
                  return getShimmerLoading();
                }
              } else {
                if (provider.getCount(findCustomKey()) == 0 &&
                    provider.isHasError(findCustomKey())) {
                  return getErrorWidget();
                } else if (provider.getCount(findCustomKey()) == 0) {
                  return getEmptyWidget();
                }
              }
              return _listItems(
                  listProvider.getList(findCustomKey()), listProvider);
            }),
          ),
          Column(
            children: [
              SearchWidgetComponent(
                  controller: controller,
                  onSearchTextChanged: onSearchTextChanged),
              FiltersAndSelectionListHeader(
                customKey: findCustomKey(),
                listProvider: listProvider,
              ),
            ],
          )
        ]);
  }

  Widget getErrorWidget() {
    return ListView(children: [
      FiltersAndSelectionListHeader(
        customKey: findCustomKey(),
        listProvider: listProvider,
      ),
      Center(
        child: EmptyWidget(
            onSubtitleClicked: () {
              listProvider.fetchList(
                  getCustomKey(), drawerViewAbstractObsever.getObject);
            },
            lottiUrl:
                "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
            title: AppLocalizations.of(context)!.cantConnect,
            subtitle: AppLocalizations.of(context)!.cantConnectConnectToRetry),
      ),
    ]);
  }

  Widget getEmptyWidget() {
    return ListView(children: [
      FiltersAndSelectionListHeader(
        customKey: findCustomKey(),
        listProvider: listProvider,
      ),
      Center(
        child: EmptyWidget(
            lottiUrl:
                "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
            title: AppLocalizations.of(context)!.noItems,
            subtitle: AppLocalizations.of(context)!.error_empty),
      ),
    ]);
  }

  Widget getShimmerLoading() {
    return Skeleton(
      isLoading: true,
      skeleton: SkeletonListView(
        itemCount: drawerViewAbstractObsever.getObject.getPageItemCount,
      ),
      child: Container(child: Center(child: Text("Content"))),
    );
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

  onSearchTextChanged(String? text) async {
    if (text == null) return;
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
    listProvider.fetchList(findCustomKey(), drawerViewAbstractObsever.object);
    debugPrint("ViewAbstractProvider CHANGED");
  }

  Widget getLoadingItem() {
    return SkeletonItem(
        child: Center(
      child: Text(AppLocalizations.of(context)!.loading),
    ));
  }
}
