import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:endless/endless.dart';

class ExampleItem {
  final String title;

  ExampleItem({
    required this.title,
  });
}

class ExampleItemPager {
  int pageIndex = 0;
  final int pageSize;

  ExampleItemPager({
    this.pageSize = 20,
  });

  List<ExampleItem> nextBatch() {
    List<ExampleItem> batch = [];

    for (int i = 0; i < pageSize; i++) {
      batch.add(ExampleItem(title: 'Item ${pageIndex * pageSize + i}'));
    }

    pageIndex += 1;

    return batch;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    ExampleItemPager pager = ExampleItemPager();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: getSearchBar(context, pager),
    );
  }

  Column getSearchBar(BuildContext context, ExampleItemPager pager) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .99,
            child: PaginatedSearchBar<ExampleItem>(
              containerDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    offset: const Offset(0, 3),
                    blurRadius: 12,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              itemPadding: 60,

              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              maxHeight: 300,
              hintText: 'Search',
              emptyBuilder: (context) {
                return const Text("I'm an empty state!");
              },
              // placeholderBuilder: (context) {
              //   return const Text("I'm a placeholder state!");
              // },
              paginationDelegate: EndlessPaginationDelegate(
                pageSize: 20,
                maxPages: 3,
              ),
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async {
                return Future.delayed(const Duration(milliseconds: 1300), () {
                  if (searchQuery == "empty") {
                    return [];
                  }

                  if (pageIndex == 0) {
                    pager = ExampleItemPager();
                  }

                  return pager.nextBatch();
                });
              },
              itemBuilder: (
                context, {
                required item,
                required index,
              }) {
                return Text(item.title);
              },
            ),
          ),
        ),
      ],
    );
  }


}
