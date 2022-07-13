import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/text_bold.dart';

class SearchCardItem extends StatelessWidget {
  ViewAbstract viewAbstract;
  String searchQuery;
  SearchCardItem(
      {Key? key, required this.viewAbstract, required this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("SearchCardItem query=> $searchQuery");
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
