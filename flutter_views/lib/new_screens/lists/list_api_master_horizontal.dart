import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:tuple/tuple.dart';

class ListApiMasterHorizontal<T> extends StatefulWidget {
  T object;
  bool useOutLineCards;
  ListApiMasterHorizontal(
      {super.key, required this.object, this.useOutLineCards = false});

  @override
  State<ListApiMasterHorizontal<T>> createState() =>
      _ListApiMasterHorizontalState<T>();
}

class _ListApiMasterHorizontalState<T>
    extends State<ListApiMasterHorizontal<T>> {
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;

  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    _scrollController.addListener(() => _onScroll());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }

  String findCustomKey() {
    if (widget.object is List<ViewAbstract>) {
      return (widget.object as List<ViewAbstract>)[0]
          .getListableKeyWithoutCustomMap();
    } else if (widget.object is List<AutoRest>) {
      return (widget.object as List<AutoRest>)[0]
          .obj
          .getListableKeyWithoutCustomMap();
    } else {
      var checkType = widget.object;
      if (checkType is AutoRest) {
        return checkType.key;
      } else if (checkType is ViewAbstract) {
        return checkType.getListableKey();
      }
    }
    return "";
  }

  void fetshList() {
    if (widget.object is List<ViewAbstract>) {
      debugPrint("listApiMasterHorizontal is List<ViewAbstract>");
      if (listProvider.getCount(findCustomKey()) == 0) {
        listProvider.fetchListOfObject(widget.object as List<ViewAbstract>);
      }
    } else if (widget.object is List<AutoRest>) {
      debugPrint("listApiMasterHorizontal is List<AutoRest>");
      if (listProvider.getCount(findCustomKey()) == 0) {
        listProvider.fetchListOfObjectAutoRest(widget.object as List<AutoRest>);
      }
    } else {
      var checkType = widget.object;
      if (checkType is AutoRest) {
        if (listProvider.getCount(findCustomKey()) == 0) {
          listProvider.fetchList(checkType.key, checkType.obj,
              autoRest: checkType);
        }
      } else if (checkType is ViewAbstract) {
        if (listProvider.getCount(findCustomKey()) == 0) {
          listProvider.fetchList(checkType.getListableKey(), checkType);
        }
      }
    }
  }

  void fetshListOnScroll() {
    if (widget.object is List<ViewAbstract>) {
      listProvider.fetchListOfObject(widget.object as List<ViewAbstract>);
    } else if (widget.object is List<AutoRest>) {
      listProvider.fetchListOfObjectAutoRest(widget.object as List<AutoRest>);
    } else {
      var checkType = widget.object;
      if (checkType is AutoRest) {
        listProvider.fetchList(checkType.key, checkType.obj,
            autoRest: checkType);
      } else if (checkType is ViewAbstract) {
        listProvider.fetchList(checkType.getListableKey(), checkType);
      }
    }
  }

  Widget _listItems(
      List<ViewAbstract> data, ListMultiKeyProvider listProvider) {
    bool isLoading = listProvider.isLoading(findCustomKey());
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemCount: isLoading ? (data.length + 1) : (data.length),
      itemBuilder: (context, index) {
        if (isLoading && index == data.length) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.loading),
                const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )),
              ],
            ),
          ));
        }
        return ListCardItemHorizontal(
          object: data[index],
          useOutlineCard: widget.useOutLineCards,
        );
        // return data[index].getCardView(context);
      },
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        debugPrint(
            "ListHorizontalApiAutoRestWidget building widget: ${findCustomKey()}");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;
        if (isError) {
          if (count == 0) {
            return getEmptyWidget(context, isError: true);
          } else {
            return _listItems(
                listProvider.getList(findCustomKey()), listProvider);
          }
        } else if (isLoading) {
          if (count == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _listItems(
                listProvider.getList(findCustomKey()), listProvider);
          }
        } else {
          if (count == 0) {
            return getEmptyWidget(context);
          }
          return _listItems(
              listProvider.getList(findCustomKey()), listProvider);
        }
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
          p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
    );
  }

  Widget getEmptyWidget(BuildContext context, {bool isError = false}) {
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

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      debugPrint(" IS BOTTOM $_isBottom");
      fetshListOnScroll();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
