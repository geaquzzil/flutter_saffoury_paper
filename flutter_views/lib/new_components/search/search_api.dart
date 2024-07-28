import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/search_card_item.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:endless/endless.dart';
import 'package:provider/provider.dart';

import '../../providers/drawer/drawer_controler.dart';

class SearchWidgetApi extends StatelessWidget {
  String? _searchQuery;

  SearchWidgetApi({super.key});

  @override
  Widget build(BuildContext context) {
    ViewAbstract viewAbstract =
        context.read<DrawerMenuControllerProvider>().getObjectCastViewAbstract;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .99,
                child: PaginatedSearchBar<dynamic>(
                  containerDecoration: const BoxDecoration(
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.black.withOpacity(0.16),
                      //   offset: const Offset(0, 3),
                      //   blurRadius: 12,
                      // )
                    ],
                    // color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  maxHeight: 300,
                  hintText:
                      'Search in ${viewAbstract.getMainHeaderLabelTextOnly(context)}',
                  emptyBuilder: (context) {
                    return const Text("I'm an empty state!");
                  },
                  paginationDelegate: EndlessPaginationDelegate(
                    pageSize: 20,
                    maxPages: 3,
                  ),
                  onSearch: ({
                    required pageIndex,
                    required pageSize,
                    required searchQuery,
                  }) async {
                    _searchQuery = searchQuery;
                    if (_searchQuery == null) {
                      return [];
                    }
                    if (_searchQuery == "") {
                      return [];
                    }

                    // return await viewAbstract.search(5, pageIndex, searchQuery);
                    return Future.delayed(const Duration(milliseconds: 1000),
                        () => viewAbstract.search(5, pageIndex, searchQuery));
                  },
                  itemBuilder: (
                    context, {
                    required item,
                    required index,
                  }) {
                    return SearchCardItem(
                        viewAbstract: item as ViewAbstract,
                        searchQuery: _searchQuery ?? "");
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
