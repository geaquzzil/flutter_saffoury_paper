import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Hero(
            tag: "/search",
            child: Material(
              child: FilledCard(
                  // height: 100,
                  // color: Theme.of(context).colorScheme.primary,
                  child: SafeArea(
                      child: Row(children: [
                BackButton(),
                Expanded(
                    child: FormBuilderTextField(
                  name: "search",
                  decoration: InputDecoration(hintText: "Search"),
                ))
              ]))),
            )));
  }
}
