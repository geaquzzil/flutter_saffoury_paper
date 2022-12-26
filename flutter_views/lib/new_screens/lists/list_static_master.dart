import 'package:flutter/material.dart';

import '../filterables/horizontal_selected_filterable.dart';

abstract class ListStaticMaster<T> extends StatefulWidget {
  List<T> list;
  bool isSearchable;
  ListStaticMaster({
    Key? key,
    required this.list,
    this.isSearchable = false,
  }) : super(key: key);

  Widget getListViewWidget(
      {required BuildContext context, required List<T> list});

  // Widget? getListViewWidgetSearchable(
  //     {required BuildContext context, required List<T> listProvider});

  @override
  State<ListStaticMaster<T>> createState() => ListStaticMasterState<T>();
}

class ListStaticMasterState<T> extends State<ListStaticMaster<T>> {
  List<T> _searchResult = [];
  late List<T> _userDetails;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userDetails = widget.list;
  }

  Widget _buildList() {
    return widget.getListViewWidget(context: context, list: _userDetails);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: _userDetails.length,
      itemBuilder: (context, index) {
        return Text("");
        // return widget.listItembuilder(_userDetails[index], false);
        // return data[index].getCardView(context);
      },
    );
  }

  Widget _buildSearchResult() {
    if (_searchResult.isEmpty) {
      return Text("EMPTY");
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return Text("");
        // return widget.listItembuilder(_searchResult[index]);
        // return data[index].getCardView(context);
      },
    );
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
          trailing: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        if (widget.isSearchable) Container(child: _buildSearchBox()),
        Expanded(
            child: _searchResult.isNotEmpty || controller.text.isNotEmpty
                ? _buildSearchResult()
                : _buildList()),
        // HorizontalFilterableSelectedList()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  onSearchTextChanged(String text) async {
    if (!widget.isSearchable) return;
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    // _searchResult = widget.onSearchTextChanged!(text);
    setState(() {});
  }
}
