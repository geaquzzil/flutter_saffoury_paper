import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/data_table_builder.dart';
import 'package:flutter_view_controller/new_components/lists/search_card_item.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/view/view_list_details.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseSharedDetailsView extends StatefulWidget {
  const BaseSharedDetailsView({Key? key}) : super(key: key);

  @override
  State<BaseSharedDetailsView> createState() => _BaseSharedDetailsViewState();
}

class _BaseSharedDetailsViewState extends State<BaseSharedDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> tabs = [];
  @override
  void initState() {
    super.initState();
    ActionViewAbstractProvider abstractProvider =
        Provider.of<ActionViewAbstractProvider>(context, listen: false);
    tabs.addAll(abstractProvider.getObject?.getTabs(context) ?? []);
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    ActionViewAbstractProvider actionViewAbstractProvider =
        context.watch<ActionViewAbstractProvider>();

    ViewAbstract? viewAbstract = actionViewAbstractProvider.getObject;
    if (viewAbstract == null) {
      return Scaffold(body: getEmptyView(context));
    } else {
      tabs.clear();
      tabs.addAll(viewAbstract.getTabs(context));

      switch (actionViewAbstractProvider.getServerActions) {
        case ServerActions.edit:
          return Scaffold(body: BaseEditPage(parent: viewAbstract));
        default:
          return Scaffold(body: getBodyView(context, viewAbstract));
      }
    }
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets3.lottiefiles.com/private_files/lf30_gctc76jz.json"),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget getBodyView(BuildContext context, ViewAbstract viewAbstract) {
    return Container(
      color: Colors.white,
      child: Stack(alignment: Alignment.bottomCenter, fit: StackFit.loose,
          // fit: BoxFit.contain,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseSharedHeaderViewDetailsActions(
                    viewAbstract: viewAbstract,
                  ),
                  ViewDetailsListWidget(
                    viewAbstract: viewAbstract,
                  ),
                  if (viewAbstract.getListableFieldName() != null)
                    DataTableBuilder(viewAbstract: viewAbstract),

                  if (viewAbstract.getTabs(context).isNotEmpty)
                    TabBarWidget(
                      viewAbstract: viewAbstract,
                    )

                  // Expanded(child: getBodyWidget(context, viewAbstract)),
                  // SizedBox(
                  //     width: double.maxFinite,
                  //     height: 100,
                  //     child: TabBar(
                  //       tabs: tabs,
                  //       controller: _tabController,
                  //     )),
                  // Expanded(
                  //   child: TabBarView(controller: _tabController, children: [
                  //     ...tabs.map((e) => Text("2"))
                  //     // Container(
                  //     //   color: Colors.orange,
                  //     // ),
                  //   ]),

                  // Divider(thickness: 1),
                  // BaseSharedHeaderDescription(viewAbstract: viewAbstract),
                  // Expanded(
                  //   child: TabBarView(controller: _tabController, children: [
                  //     Container(
                  //       color: Colors.red,
                  //     ),
                  //     // Container(
                  //     //   color: Colors.orange,
                  //     // ),
                  //   ]),
                  // ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     padding: const EdgeInsets.all(kDefaultPadding),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         CircleAvatar(
                  //             maxRadius: 24,
                  //             backgroundColor: Colors.transparent,
                  //             child: viewAbstract.getCardLeadingImage(context)),
                  //         const SizedBox(width: kDefaultPadding),
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Column(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text.rich(
                  //                           TextSpan(
                  //                             text: viewAbstract
                  //                                 .getMainHeaderTextOnly(context),
                  //                             style:
                  //                                 Theme.of(context).textTheme.button,
                  //                             children: [
                  //                               TextSpan(
                  //                                   text:
                  //                                       "  <elvia.atkins@gmail.com> to Jerry Torp",
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .caption),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           viewAbstract
                  //                               .getMainHeaderLabelTextOnly(context),
                  //                           style:
                  //                               Theme.of(context).textTheme.headline6,
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   const SizedBox(width: kDefaultPadding / 2),
                  //                   Text(
                  //                     "Today at 15:32",
                  //                     style: Theme.of(context).textTheme.caption,
                  //                   ),
                  //                 ],
                  //               ),
                  //               const SizedBox(height: kDefaultPadding),
                  //               LayoutBuilder(
                  //                 builder: (context, constraints) => SizedBox(
                  //                   width: constraints.maxWidth > 850
                  //                       ? 800
                  //                       : constraints.maxWidth,
                  //                   child: Expanded(
                  //                       child: getBodyWidget(context, viewAbstract)),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            if (viewAbstract is CartableDetailItemInterface)
              BottomWidgetOnViewIfCartable(
                viewAbstract: viewAbstract as CartableDetailItemInterface,
              )
            else
              BottomWidgetOnViewIfViewAbstract(
                viewAbstract: viewAbstract,
              )
          ]),
    );
  }
}

class BottomWidgetOnViewIfCartable extends StatelessWidget {
  CartableDetailItemInterface viewAbstract;
  BottomWidgetOnViewIfCartable({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
          elevation: 5,
          child: Container(
            width: double.maxFinite,
            height: 100,
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SearchCardItem(
                        viewAbstract: viewAbstract as ViewAbstract,
                        searchQuery: ""),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.add_to_cart),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              // decoration:,
                              initialValue: viewAbstract
                                  .getCartItemQuantity()
                                  .toStringAsFixed(2),
                            ),
                          )
                          // Text(viewAbstract
                          //     .getCartItemQuantity()
                          //     .toStringAsFixed(2))
                        ]),
                  ),
                  SizedBox(
                    width: 150,
                    height: double.maxFinite,
                    child: FutureBuilder<bool>(
                      future:
                          context.watch<CartProvider>().hasItem(viewAbstract),

                      builder: (context, snapshot) => ElevatedButton(
                        style: snapshot.data ?? false
                            ? ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.orange),
                              )
                            : null,
                        onPressed: () {},
                        child: const Text("ADD TO CART"),
                        // icon: Icon(Icons.plus_one_outlined),
                        // label: Text("ADD TO CART")
                      ),
                      // child: ElevatedButton(
                      //   style: context.watch<CartProvider>().hasItem(viewAbstract)?

                      //   ButtonStyle():null,
                      //   onPressed: () {},
                      //   child: Text("ADD TO CART"),
                      //   // icon: Icon(Icons.plus_one_outlined),
                      //   // label: Text("ADD TO CART")
                      // ),
                    ),
                  )
                ]),
          )),
    );
  }
}

class BottomWidgetOnViewIfViewAbstract extends StatelessWidget {
  ViewAbstract viewAbstract;
  BottomWidgetOnViewIfViewAbstract({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
          elevation: 5,
          child: Container(
            width: double.maxFinite,
            height: 100,
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SearchCardItem(
                        viewAbstract: viewAbstract,
                        searchQuery: ""),
                  ),
                  // Expanded(
                  //   child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Text(AppLocalizations.of(context)!.add_to_cart),
                  //         SizedBox(
                  //           width: 100,
                  //           child: TextFormField(
                  //             // decoration:,
                  //             initialValue: viewAbstract
                  //                 .getCartItemQuantity()
                  //                 .toStringAsFixed(2),
                  //           ),
                  //         )
                  //         // Text(viewAbstract
                  //         //     .getCartItemQuantity()
                  //         //     .toStringAsFixed(2))
                  //       ]),
                  // ),
                  SizedBox(
                      width: 150,
                      height: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("EDIT"),
                        // icon: Icon(Icons.plus_one_outlined),
                        // label: Text("ADD TO CART")
                      ))
                  //     // child: ElevatedButton(
                  //     //   style: context.watch<CartProvider>().hasItem(viewAbstract)?

                  //     //   ButtonStyle():null,
                  //     //   onPressed: () {},
                  //     //   child: Text("ADD TO CART"),
                  //     //   // icon: Icon(Icons.plus_one_outlined),
                  //     //   // label: Text("ADD TO CART")
                  //     // ),
                  //   ),
                  // )
                ]),
          )),
    );
  }
}
