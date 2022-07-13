import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/text_bold.dart';

class AutoCompleteCardItem extends StatelessWidget {
  ViewAbstract viewAbstract;
  String searchQuery;
  AutoCompleteCardItem(
      {Key? key, required this.viewAbstract, required this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("AutoCompleteCardItem query=> $searchQuery");
    debugPrint("AutoCompleteCardItem viewAbstract=> $viewAbstract");
    return ListTile(
        onTap: () => {},
        onLongPress: () => {},
        title: TextBold(
            text: viewAbstract.getMainHeaderTextOnly(context),
            regex: searchQuery.trim()),
        subtitle: TextBold(
            text: viewAbstract.getMainHeaderLabelTextOnly(context),
            regex: searchQuery.trim()),
        leading: viewAbstract.getCardLeading(context));
  }
}
