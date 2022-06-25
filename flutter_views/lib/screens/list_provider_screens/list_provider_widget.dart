import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/list_provider.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:provider/provider.dart';

class ListProviderWidget extends StatefulWidget {
  const ListProviderWidget({Key? key}) : super(key: key);

  @override
  State<ListProviderWidget> createState() => _ListProviderWidgetState();
}

class _ListProviderWidgetState extends State<ListProviderWidget> {
  final _scrollController = ScrollController();
  final ListProvider listProvider = ListProvider();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    Provider.of<DrawerViewAbstractProvider>(context, listen: false)
        .addListener(() {
      print("ViewAbstractProvider CHANGED");
      // context
      //     .read<PostBloc>()
      //     .clearList(context.read<DrawerViewAbstractProvider>().getObject);
    });
    listProvider
        .fetchList(context.read<DrawerViewAbstractProvider>().getObject);
    // listClass = DynamicList(taskItems.list);
    //    = Provider.of<ViewAbstractProvider>(context, listen = false);
    //object = context.watch<ViewAbstractProvider>().getObject;
  }

  Widget _listItems(List<ViewAbstract> data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return data[index].getCardView(context);
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
          return const Center(child: Icon(Icons.search));
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
    print(" IS _onScroll $_isBottom");
    if (_isBottom) {
      print(" IS BOTTOM $_isBottom");
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
}
