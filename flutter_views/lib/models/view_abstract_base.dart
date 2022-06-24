import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/edit_error_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reflectable/mirrors.dart';

import 'view_abstract_api.dart';

abstract class ViewAbstractBase<T> {
  String iD = "-1";
  List<String> getFields();
  String getFieldLabel(String label, BuildContext context);
  IconData getFieldIconData(String label);
  IconData getIconData();

  double getCartItemPrice() => 0;
  double getCartItemQuantity() => 0;

  Icon getFieldIcon(String label) {
    return Icon(getFieldIconData(label));
  }

  Icon getIcon() {
    return Icon(getIconData());
  }

  Text? getSubtitleHeaderText(BuildContext context) {
    return Text(
      getSubtitleHeaderTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getHeaderText(BuildContext context) {
    return Text(
      getHeaderTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getLabelText(BuildContext context) {
    return Text(
      getLabelTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getLabelSubtitleText(BuildContext context) {
    return Text(
      getLabelSubtitleTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Color getColor(BuildContext context) => Colors.red;

  Widget? getCardTrailing(BuildContext context) {
    return const Icon(Icons.more_vert_outlined);
  }

  Widget getCardLeadingEditCard(BuildContext context) {
    return Icon(getIconData(),
        color: context
                .watch<ErrorFieldsProvider>()
                .formValidationManager
                .hasError(this as ViewAbstract)
            ? Colors.red
            : Colors.black54);
  }

  Widget getCardLeading(BuildContext context) {
    return Hero(
        tag: this,
        child: CircleAvatar(radius: 28, child: getCardLeadingImage(context)));
  }

  DismissDirection getDismissibleDirection() {
    return DismissDirection.horizontal;
  }

  void onCardDismissedView(BuildContext context, DismissDirection direction) {
    print("onDismissed {$this} => direction: $direction");
  }

  Widget getDismissibleSecondaryBackground(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      alignment: Alignment.centerRight,
      color: Colors.green,
      child: const Icon(
        Icons.add_shopping_cart,
        color: Colors.white,
      ),
    );
  }

  Widget getDismissibleBackground(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      alignment: Alignment.centerLeft,
      color: Colors.red,
      child: const Icon(
        Icons.delete_outlined,
        color: Colors.white,
      ),
    );
  }

  Widget getCardLeadingImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: getImageUrl(context)!,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(getIconData()),
    );
  }

  String? getImageUrl(BuildContext context) {
    return "https://";
  }

  String getSubtitleHeaderTextOnly(BuildContext context) {
    return "null";
  }

  String getHeaderTextOnly(BuildContext context) {
    return "null";
  }

  String getLabelSubtitleTextOnly(BuildContext context) {
    return "null";
  }

  String getLabelTextOnly(BuildContext context) {
    return "null";
  }

  List<Widget>? getAppBarActionsEdit(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.save_outlined), onPressed: () {})];

  List<Widget>? getAppBarActionsView(BuildContext context) => null;

  List<Tab> getTabs(BuildContext context) {
    return [
      Tab(
        text: "OverView",
        icon: getIcon(),
      ),
    ];
  }

  InstanceMirror getInstanceMirror() {
    return reflector.reflect(this);
  }

  dynamic getFieldValue(String label) {
    try {
      return getInstanceMirror().invokeGetter(label);
    } catch (e) {
      return "$label ${e.toString()}";
    }
  }

  String getTag(String label) {
    return "${T}_$label";
  }

  DateTime? getDateTimeFromField(String? value) {
    if (value == null) {
      return null;
    }
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.parse(value);
  }

 
}
