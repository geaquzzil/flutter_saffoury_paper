import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../new_components/loading_shimmer.dart';

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

  Widget getTrailingWidget() {
    return IconButton(
      icon: Icon(Icons.cancel),
      onPressed: () {
        controller.clear();
        onSearchTextChanged('');
      },
    );
    return controller.text.isEmpty
        ? IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          )
        : CircularProgressIndicator(
            strokeWidth: 2,
          );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.search),
          title: TextField(
            controller: controller,
            decoration:
                InputDecoration(hintText: 'Search', border: InputBorder.none),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(child: _buildSearchBox()),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (ctx, i) {
            return Column(
              children: const [
                ShimmerLoadingList(),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }),
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