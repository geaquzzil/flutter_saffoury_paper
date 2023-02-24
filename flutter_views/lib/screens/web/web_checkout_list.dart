import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/cart_data_table_master.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_description.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_list_header.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/screens/web/components/web_button.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';

import '../../models/servers/server_helpers.dart';

class WebCheckoutList extends StatelessWidget {
  const WebCheckoutList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // getWebText(title: "Your order", fontSize: 20),
          const CartListHeader(),
          CartDataTableMaster(
            action: ServerActions.view,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          const CartDescriptionTotals(),
          const SizedBox(
            height: kDefaultPadding,
          ),
          ListTile(
            title: SearchWidgetComponentEditable(
              notiferSearchVoid: (value) {},
            ),
            trailing: WebButton(
              title: "Apply",
              onPressed: () {},
              width: 200,
            ),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          CheckboxListTile(
            value: false,
            onChanged: (value) {},
            title: Text(
                "I have read and agree to the SaffouryPaper terms and conditions"),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          WebButton(
            width: double.infinity,
            title: "PLACE ORDER",
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
