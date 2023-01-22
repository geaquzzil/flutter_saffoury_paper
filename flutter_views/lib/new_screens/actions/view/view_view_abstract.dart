import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/view_table_widget.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_card_item.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_list_details.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';

import '../../../models/servers/server_helpers.dart';
import '../../../new_components/tables_widgets/editable_table_widget.dart';
import '../../../new_components/lists/search_card_item.dart';
import '../../../new_components/tab_bar/tab_bar.dart';
import '../../../new_components/tables_widgets/cart_data_table_master.dart';
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
    final fields = viewAbstract
        .getMainFields(context: context)
        .where((element) => viewAbstract.getFieldValue(element) != null)
        .toList();
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return buildItem(context, fields[index]);
      },
      // 40 list items
      childCount: fields.length,
    ));
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ListTile(
            // subtitle: Text(AppLocalizations.of(context)!.total),
            title: Text(
              viewAbstract.getCartableProductQuantity().toCurrencyFormat(
                  symbol: viewAbstract.getCartableQuantityUnit(context)),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          )),
          Selector<CartProvider, bool>(
            builder: (context, value, child) => value
                ? OutlinedButton(
                    onPressed: () {
                      context.read<CartProvider>().onCartItemRemovedProduct(
                            context,
                            viewAbstract,
                          );
                    },
                    child: Text(value
                        ? AppLocalizations.of(context)!
                            .addedToCart
                            .toUpperCase()
                        : AppLocalizations.of(context)!
                            .add_to_cart
                            .toUpperCase()),
                    // icon: Icon(Icons.plus_one_outlined),
                    // label: Text("ADD TO CART")
                  )
                : ElevatedButton(
                    onPressed: () {
                      showDialogExt(
                          anchorPoint: Offset(1000, 1000),
                          context: context,
                          builder: (context) {
                            final TextEditingController _textEditingController =
                                TextEditingController();
                            bool isChecked = false;
                            final GlobalKey<FormState> _formKey =
                                GlobalKey<FormState>();
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                content: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          autofocus: true,
                                          controller: _textEditingController,
                                          validator: context
                                              .read<CartProvider>()
                                              .getCartableInvoice
                                              .getCartableNewInstance(context,
                                                  viewAbstract)
                                              .getCartableEditableValidateItemCell(
                                                  context, "quantity"),
                                          decoration: InputDecoration(
                                              hintText: "Enter Some Text"),
                                        ),
                                      ],
                                    )),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.subment),
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        context
                                            .read<CartProvider>()
                                            .onCartItemAdded(
                                                context,
                                                -1,
                                                viewAbstract,
                                                double.tryParse(
                                                        _textEditingController
                                                            .text) ??
                                                    0);
                                        // Do something like updating SharedPreferences or User Settings etc.
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              );
                            });
                          });
                    },
                    child: Text(value
                        ? AppLocalizations.of(context)!
                            .addedToCart
                            .toUpperCase()
                        : AppLocalizations.of(context)!
                            .add_to_cart
                            .toUpperCase()),
                    // icon: Icon(Icons.plus_one_outlined),
                    // label: Text("ADD TO CART")
                  ),
            selector: (p0, p1) => p1.hasItemOnCart(viewAbstract),
          ),
          // FutureBuilder<bool>(
          //   future: context.watch<CartProvider>().hasItem(viewAbstract),

          //   builder: (context, snapshot) => OutlinedButton(
          //     style: snapshot.data ?? false
          //         ? ButtonStyle(
          //             backgroundColor: MaterialStateProperty.all(
          //                 Theme.of(context).colorScheme.tertiary),
          //           )
          //         : null,
          //     onPressed: () {
          //       context.read<CartProvider>().onCartItemAdded(context, -1,
          //           viewAbstract, double.tryParse(controller.text) ?? 0);
          //     },
          //     child: const Text("ADD TO CART"),
          //     // icon: Icon(Icons.plus_one_outlined),
          //     // label: Text("ADD TO CART")
          //   ),
          //   // child: ElevatedButton(
          //   //   style: context.watch<CartProvider>().hasItem(viewAbstract)?

          //   //   ButtonStyle():null,
          //   //   onPressed: () {},
          //   //   child: Text("ADD TO CART"),
          //   //   // icon: Icon(Icons.plus_one_outlined),
          //   //   // label: Text("ADD TO CART")
          //   // ),
          // )
        ]);
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
