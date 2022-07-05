import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/search/search_api.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/screens/components/search_bar.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:endless/endless.dart';

class HeaderMain extends StatefulWidget {
  const HeaderMain({
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderMain> createState() => _HeaderMainState();
}

class _HeaderMainState extends State<HeaderMain> {
  @override
  Widget build(BuildContext context) {
    ViewAbstract viewAbstract =
        context.read<DrawerViewAbstractProvider>().getObject;

    // return ProfileMenu(icon: "", text: "dsa", press: () {});
    return  SearchWidgetApi();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
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
                      containerDecoration: BoxDecoration(
                        boxShadow: const [
                          // BoxShadow(
                          //   color: Colors.black.withOpacity(0.16),
                          //   offset: const Offset(0, 3),
                          //   blurRadius: 12,
                          // )
                        ],
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      itemPadding: 30,

                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      maxHeight: 300,
                      hintText:
                          'Search ${viewAbstract.getLabelTextOnly(context)}',
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
                        return await viewAbstract.search(5, 0, searchQuery);
                      },
                      //   return viewAbstract.search(5, 0, searchQuery) ?? Future.delayed(
                      //       const Duration(milliseconds: 1300), () {
                      //     if (searchQuery == "empty") {
                      //       return [];+
                      //     }
                      //     if (searchQuery == "") {
                      //       return [];
                      //     }

                      //     if (pageIndex == 0) {
                      //       pager = ExampleItemPager();
                      //     }

                      //     return  [];
                      //   });
                      // },
                      itemBuilder: (
                        context, {
                        required item,
                        required index,
                      }) {
                        return ListCardItem(object: item as ViewAbstract);
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}
