import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../new_components/lists/list_card_item_selected.dart';

class ListApiSelectedSearchableWidget<T extends ViewAbstract>
    extends StatefulWidget {
  ViewAbstract viewAbstract;
  void Function(List<T> selectedList)? onSelected;

  ListApiSelectedSearchableWidget(
      {super.key, required this.viewAbstract, this.onSelected});

  @override
  State<ListApiSelectedSearchableWidget> createState() =>
      _ListApiSelectedSearchableWidget();
}

class _ListApiSelectedSearchableWidget<T extends ViewAbstract>
    extends State<ListApiSelectedSearchableWidget<T>> {
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  TextEditingController controller = TextEditingController();
  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  List<T> selectedList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listProvider.fetchList(getCustomKey(), viewAbstract: widget.viewAbstract,context:context);
    });
  }

  String getCustomKey({String? searchTextKey}) {
    String key = "${widget.viewAbstract.getTableNameApi()}listAPI";
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

  Widget getRefreshWidget() => IconButton(
      onPressed: () {
        _refresh();
      },
      icon: const Icon(Icons.refresh));

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
    listProvider.refresh(findCustomKey(), widget.viewAbstract,context:context);
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

  Widget _buildSelectedCountBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.contact_support_rounded),
          title: Text("Selectd item ${selectedList.length}"),
          // trailing: getTrailingWidget(),
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
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        return ListCardItemSelected<T>(
          object: data[index] as T,
          onSelected: (obj, isSelect) {
            if (obj.isSelected) {
              T? isFounded;
              try {
                isFounded =
                    selectedList.firstWhereOrNull((p0) => p0.isEquals(obj));
              } catch (e, s) {}
              if (isFounded == null) {
                selectedList.add(obj);
                if (widget.onSelected != null) {
                  widget.onSelected!(selectedList);
                  setState(() {});
                }
              }
            } else {
              selectedList.removeWhere((element) => element.isEquals(obj));
              if (widget.onSelected != null) {
                widget.onSelected!(selectedList);
                setState(() {});
              }
            }
          },
        );
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
        if (selectedList.isNotEmpty) Container(child: _buildSelectedCountBox()),
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
      skeleton: SkeletonListView(itemCount: 10),
      child: Container(child: const Center(child: Text("Content"))),
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
        listProvider.fetchList(getCustomKey(),
            viewAbstract: widget.viewAbstract,context:context);
      } else {
        listProvider.fetchListSearch(
            getCustomKey(searchTextKey: controller.text),
            widget.viewAbstract,
            controller.text,context:context);
      }
    }
  }

  onSearchTextChanged(String text) async {
    await Future.delayed(
      const Duration(milliseconds: 750),
      () {
        listProvider.fetchListSearch(
            getCustomKey(searchTextKey: controller.text),
            widget.viewAbstract,
            controller.text,context:context);
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
}
