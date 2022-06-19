import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/list_provider.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:provider/provider.dart';

class ListProviderWidget extends StatefulWidget {
  ListProviderWidget({Key? key}) : super(key: key);

  @override
  State<ListProviderWidget> createState() => _ListProviderWidgetState();
}

class _ListProviderWidgetState extends State<ListProviderWidget> {
  final _scrollController = ScrollController();
  var taskItemsProvider;
  int counter = 0;
  // late DynamicList listClass;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    Provider.of<DrawerViewAbstractProvider>(context, listen: false)
        .addListener(() {
      print("ViewAbstractProvider CHANGED");
      context
          .read<PostBloc>()
          .clearList(context.read<DrawerViewAbstractProvider>().getObject);
    });
    taskItemsProvider = Provider.of<ListProvider>(context, listen: false);
    // listClass = DynamicList(taskItems.list);
    //    = Provider.of<ViewAbstractProvider>(context, listen = false);
    //object = context.watch<ViewAbstractProvider>().getObject;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(builder: (context, provider, listTile) {
      return Expanded(
        child: ListView.builder(
          itemCount: provider.getCount,
          itemBuilder: buildList,
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom){
       context.read<ListProvider>().callList(viewAbstract)
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Widget buildList(BuildContext context, int index) {
    counter++;
    return Dismissible(
        key: Key(counter.toString()),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          taskItems.deleteItem(index);
        },
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(listClass.list[index].toString()),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ));
  }
}

class DynamicList {
  List<ViewAbstract> _list = [];
  DynamicList(this._list);

  List get list => _list;
}
