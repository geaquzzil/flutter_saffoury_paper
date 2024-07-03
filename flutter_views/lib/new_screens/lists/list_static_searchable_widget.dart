import 'package:flutter/material.dart';


class ListStaticSearchableWidget<T> extends StatefulWidget {
  List<T> list;
  Widget Function(T item) listItembuilder;
  List<T> Function(String query) onSearchTextChanged;
  ListStaticSearchableWidget(
      {super.key,
      required this.list,
      required this.listItembuilder,
      required this.onSearchTextChanged});

  @override
  State<ListStaticSearchableWidget> createState() =>
      _ListStaticSearchableWidgetState<T>();
}

class _ListStaticSearchableWidgetState<T>
    extends State<ListStaticSearchableWidget<T>> {
  List<T> _searchResult = [];
  late List<T> _userDetails;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userDetails = widget.list;
  }

  Widget _buildList() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: _userDetails.length,
      itemBuilder: (context, index) {
        return widget.listItembuilder(_userDetails[index]);
        // return data[index].getCardView(context);
      },
    );
  }

  Widget _buildSearchResult() {
    if (_searchResult.isEmpty) {
      return const Text("EMPTY");
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return widget.listItembuilder(_searchResult[index]);
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
    return Column(
      children: <Widget>[
        Container(child: _buildSearchBox()),
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
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _searchResult = widget.onSearchTextChanged(text);
    setState(() {});
  }
}
