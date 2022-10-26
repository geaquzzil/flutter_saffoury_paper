import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/view/view_list_details.dart';
import 'package:provider/provider.dart';

import '../../models/servers/server_helpers.dart';
import '../../new_components/lists/search_card_item.dart';
import '../../new_components/tab_bar/tab_bar.dart';
import '../../new_components/tables_widgets/cart_data_table_master.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MasterView extends StatelessWidget {
  ViewAbstract viewAbstract;
  MasterView({Key? key, required this.viewAbstract}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(flex: 1, child: Text("TEST")),
        Expanded(
          flex: 1,
          child: Stack(alignment: Alignment.bottomCenter, fit: StackFit.loose,
              // fit: BoxFit.contain,
              children: [
                SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseSharedHeaderViewDetailsActions(
                        viewAbstract: viewAbstract,
                      ),
                      ViewDetailsListWidget(
                        viewAbstract: viewAbstract,
                      ),
                      if (viewAbstract is CartableInvoiceMasterObjectInterface)
                        CartDataTableMaster(
                            action: ServerActions.view,
                            obj: viewAbstract
                                as CartableInvoiceMasterObjectInterface),
                    ],
                  ),
                ),
                if (viewAbstract is CartableProductItemInterface)
                  BottomWidgetOnViewIfCartable(
                    viewAbstract: viewAbstract as CartableProductItemInterface,
                  )
                else
                  BottomWidgetOnViewIfViewAbstract(
                    viewAbstract: viewAbstract,
                  )
              ]),
        ),
        if (viewAbstract.getTabs(context).isNotEmpty)
          Expanded(
            child: TabBarWidget(
              viewAbstract: viewAbstract,
            ),
          )
      ],
    );
  }
}

class BottomWidgetOnViewIfCartable extends StatelessWidget {
  CartableProductItemInterface viewAbstract;
  TextEditingController controller = TextEditingController();
  BottomWidgetOnViewIfCartable({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text =
        viewAbstract.getCartableProductQuantity().toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
          elevation: 20,
          child: SizedBox(
            width: double.maxFinite,
            height: 100,
            // color: Colors.white,
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
                              controller: controller,
                            ),
                          )
                          // Text(viewAbstract
                          //     .getCartItemQuantity()
                          //     .toStringAsFixed(2))
                        ]),
                  ),
                  FutureBuilder<bool>(
                    future: context.watch<CartProvider>().hasItem(viewAbstract),

                    builder: (context, snapshot) => ElevatedButton(
                      style: snapshot.data ?? false
                          ? ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange),
                            )
                          : null,
                      onPressed: () {
                        context.read<CartProvider>().onCartItemAdded(
                            context,
                            -1,
                            viewAbstract,
                            double.tryParse(controller.text) ?? 0);
                      },
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
      child: Card(
          elevation: 5,
          child: Container(
            width: double.maxFinite,
            height: 100,
            // color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SearchCardItem(
                        viewAbstract: viewAbstract, searchQuery: ""),
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
