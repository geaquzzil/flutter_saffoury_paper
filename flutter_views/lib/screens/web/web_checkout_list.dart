import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/cart_data_table_master.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_description.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_list_header.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/components/web_button.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:provider/provider.dart';

import '../../models/servers/server_helpers.dart';

class WebCheckoutList extends StatelessWidget {
  ValueNotifier<bool> hasAggreeTerms = ValueNotifier<bool>(false);
  WebCheckoutList({super.key});

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
          AgreeToTerms(
            hasAgreeToTerms: hasAggreeTerms,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          ValueListenableBuilder<bool>(
              valueListenable: hasAggreeTerms,
              builder: (context, hasAgree, child) =>
                  Selector<AuthProvider, Status>(
                    builder: (context, value, child) => WebButton(
                      width: double.infinity,
                      title: "PLACE ORDER",
                      onPressed: hasAgree && value == Status.Authenticated
                          ? () {}
                          : null,
                    ),
                    selector: (p0, p1) => p1.getStatus,
                  ))
        ],
      ),
    );
  }
}

class AgreeToTerms extends StatelessWidget {
  ValueNotifier<bool>? hasAgreeToTerms;
  AgreeToTerms({super.key, this.hasAgreeToTerms});

  @override
  Widget build(BuildContext context) {
    hasAgreeToTerms ??= ValueNotifier<bool>(false);
    return ValueListenableBuilder<bool>(
      valueListenable: hasAgreeToTerms!,
      builder: (context, value, child) => CheckboxListTile(
        
        value: value,
        onChanged: (value) {
          hasAgreeToTerms!.value = value ?? false;
        },
        title: const Text(
            "I have read and agree to the SaffouryPaper terms and conditions"),
      ),
    );
  }
}
