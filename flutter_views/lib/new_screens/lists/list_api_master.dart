import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListApiMaster extends StatefulWidget {
  const ListApiMaster({super.key});

  @override
  State<ListApiMaster> createState() => _ListApiMasterState();
}

class _ListApiMasterState extends State<ListApiMaster>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  TextEditingController controller = TextEditingController();
  bool _pinned = false;
  bool _snap = true;
  bool _floating = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget getTrailingWidget() {
    return IconButton(
      icon: const Icon(Icons.cancel),
      onPressed: () {
        controller.clear();
        // onSearchTextChanged('');
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
            // onChanged: onSearchTextChanged,
          ),
          trailing: getTrailingWidget(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // Container()
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                title: _buildSearchBox(),
                pinned: _pinned,
                primary: true,
                floating: _floating,
                forceElevated: innerBoxIsScrolled,
                // bottom: TabBar(
                //   tabs: <Tab>[
                //     Tab(text: 'STATISTICS'),
                //     Tab(text: 'HISTORY'),
                //   ],
                //   controller: _tabController,
                // ),
              ),
            ];
          },
          body: Text('STATISTICS')

          //  TabBarView(
          //   controller: _tabController,
          //   children: <Widget>[
          //     Text('STATISTICS'),
          //     Text('STATISTICS'),
          //   ],
          // ),
          ),
    );
  }
}
