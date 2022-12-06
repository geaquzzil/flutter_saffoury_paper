import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/view_table_widget.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/view/view_card_item.dart';
import 'package:flutter_view_controller/screens/view/view_list_details.dart';
import 'package:provider/provider.dart';

import '../../models/servers/server_helpers.dart';
import '../../new_components/tables_widgets/editable_table_widget.dart';
import '../../new_components/lists/search_card_item.dart';
import '../../new_components/tab_bar/tab_bar.dart';
import '../../new_components/tables_widgets/cart_data_table_master.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MasterView extends StatelessWidget {
  ViewAbstract viewAbstract;
  MasterView({Key? key, required this.viewAbstract}) : super(key: key);
  Widget buildItem(BuildContext context, String field) {
    debugPrint("MasterView buildItem $field");
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    if (fieldValue == null) {
      return ViewCardItem(title: field, description: "null", icon: Icons.abc);
    } else if (fieldValue is ViewAbstract) {
      return ViewCardItem(
          title: "", description: "", icon: Icons.abc, object: fieldValue);
    } else if (fieldValue is ViewAbstractEnum) {
      return ViewCardItem(
          title: fieldValue.getMainLabelText(context),
          description: fieldValue.getFieldLabelString(context, fieldValue),
          icon: fieldValue.getFieldLabelIconData(context, fieldValue),
          object: null);
    } else {
      return ViewCardItem(
          title: viewAbstract.getFieldLabel(context, field),
          description: fieldValue.toString(),
          icon: viewAbstract.getFieldIconData(field));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? topWidget =
        viewAbstract.getCustomTopWidget(context, ServerActions.view);
    final fields = viewAbstract.getMainFields();
    return Column(
      children: [
        if (topWidget != null) topWidget,
        ...fields
            .where((element) => viewAbstract.getFieldValue(element) != null)
            .map((e) => buildItem(context, e)),
        if (viewAbstract is ListableInterface)
          ViewableTableWidget(viewAbstract: viewAbstract as ListableInterface),
      ],
    );

    return Column(
      children: [
        Row(
          children: [
            // Expanded(flex: 1, child: Text("TEST")),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (topWidget != null) topWidget,
                  // BaseSharedHeaderViewDetailsActions(
                  //   viewAbstract: viewAbstract,
                  // ),
                  ViewDetailsListWidget(
                    viewAbstract: viewAbstract,
                  ),
                  if (viewAbstract is CartableInvoiceMasterObjectInterface)
                    CartDataTableMaster(
                        action: ServerActions.view,
                        obj: viewAbstract
                            as CartableInvoiceMasterObjectInterface),
                  const SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
            if (viewAbstract.getTabs(context).isNotEmpty)
              Expanded(
                child: OutlinedCard(
                  child: TabBarWidget(
                    viewAbstract: viewAbstract,
                  ),
                ),
              )
          ],
        ),
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
    return FilledCard(
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
                    context.read<CartProvider>().onCartItemAdded(context, -1,
                        viewAbstract, double.tryParse(controller.text) ?? 0);
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
      ),
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
