import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class NormalCardList<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  const NormalCardList({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => object.onCardClicked(context),
      onLongPress: () => object.onCardLongClicked(context),
      title: (object.getHeaderText(context)),
      subtitle: (object.getSubtitleHeaderText(context)),
      leading: object.getCardLeading(context),
      trailing: InkWell(
          onTap: () => object.onCardTrailingClicked(context),
          child: object.getCardTrailing(context)),
    );
  }
}
