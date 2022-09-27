import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ListApiWidget extends StatefulWidget {
  const ListApiWidget({Key? key}) : super(key: key);

  @override
  State<ListApiWidget> createState() => _ListApiWidgetState();
}

class _ListApiWidgetState extends State<ListApiWidget> {
  final _scrollController = ScrollController();
  final ListProvider listProvider = ListProvider();
  late DrawerViewAbstractProvider drawerViewAbstractObsever;

  var loadingLottie =
      "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    drawerViewAbstractObsever =
        Provider.of<DrawerViewAbstractProvider>(context, listen: false);
    drawerViewAbstractObsever.addListener(onChangedViewAbstract);
    listProvider
        .fetchList(context.read<DrawerViewAbstractProvider>().getObject);
  }

  Widget _listItems(List<ViewAbstract> data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListCardItem(object: data[index]);
          // return data[index].getCardView(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: listProvider,
      child: Consumer<ListProvider>(builder: (context, provider, listTile) {
        if (provider.getCount == 0) {
          return EmptyWidget(
              lottiUrl: loadingLottie,
              title: AppLocalizations.of(context)!.loading,
              subtitle: AppLocalizations.of(context)!.pleaseWait);
        }
        return _listItems(listProvider.getObjects);
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
      listProvider
          .fetchList(context.read<DrawerViewAbstractProvider>().getObject);
      // context
      //     .read<ListProvider>()
      //     .fetchList(context.read<DrawerViewAbstractProvider>().getObject);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void onChangedViewAbstract() {
    listProvider.clear(viewAbstract: drawerViewAbstractObsever.object);
    debugPrint("ViewAbstractProvider CHANGED");
  }
}
