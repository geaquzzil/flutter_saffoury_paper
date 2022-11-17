import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../home/components/empty_widget.dart';
import '../pos/pos_cart_item.dart';

class ListableStaticEditable extends StatelessWidget {
  List<ViewAbstract> list;
  ListableStaticEditable({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return EmptyWidget(
          lottiUrl:
              "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
          title: AppLocalizations.of(context)!.noItems,
          subtitle: AppLocalizations.of(context)!.no_content);
    }
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) =>
            POSListCardItem<ViewAbstract>(object: list[index] as ViewAbstract));
  }
}
