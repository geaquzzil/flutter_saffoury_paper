import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

import '../../new_components/cards/outline_card.dart';

class PosCardSquareItem<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  const PosCardSquareItem({
    super.key,
    required this.object,
  });

  @override
  Widget build(BuildContext context) {
    // return ListCardItemHorizontal(object: object);
    return SizedBox(
        width: 250,
        height: 200,
        child: OutlinedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              object.getCardLeading(context),
              object.getMainHeaderText(context),
              object.getMainSubtitleHeaderText(context) ?? const Text("")
            ],
            // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
            // onTap: () => object.onCardClicked(context),
            // onLongPress: () => object.onCardLongClicked(context),
            // title: (object.getMainHeaderText(context)),
            // subtitle: (object.getMainSubtitleHeaderText(context)),
            // leading: object.getCardLeadingWithSelecedBorder(context),
            // trailing: object.getPopupMenuActionListWidget(context)),
          ),
        ));
  }
}
