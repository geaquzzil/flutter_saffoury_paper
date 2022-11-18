import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_editable.dart';
import '../home/components/empty_widget.dart';
import '../pos/pos_cart_item.dart';

class ListableStaticEditable extends StatelessWidget {
  List<ViewAbstract> list;
  void Function(ViewAbstract object) onDelete;
  void Function(ViewAbstract object) onUpdate;
  ListableStaticEditable(
      {Key? key,
      required this.list,
      required this.onDelete,
      required this.onUpdate})
      : super(key: key);

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
        itemBuilder: (context, index) => ListCardItemEditable<ViewAbstract>(
              object: list[index],
              onDelete: onDelete,
              onUpdate: onUpdate,
            ));
  }
}
