import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reflectable/mirrors.dart';

import 'view_abstract_api.dart';

abstract class ViewAbstractBase<T> extends ViewAbstractPermissions<T> {
  List<String> getMainFields();
  String getMainHeaderTextOnly(BuildContext context);
  String getMainLabelSubtitleTextOnly(BuildContext context);

  IconData getMainIconData();
  String? getMainDrawerGroupName() => null;
  IconData? getMainDrawerGroupIconData() => null;

  Map<String, String> getFieldLabelMap(BuildContext context);
  Map<String, IconData> getFieldIconDataMap();

  T fromJsonViewAbstract(Map<String, dynamic> json);
  Map<String, dynamic> toJsonViewAbstract();

  String getFieldLabel(BuildContext context, String field) {
    return getFieldLabelMap(context)[field] ?? " not found label for=> $field";
  }

  Icon getFieldIcon(String field) {
    return Icon(getFieldIconDataMap()[field]);
  }

  IconData getFieldIconData(String field) {
    return getFieldIconDataMap()[field] ?? Icons.error;
  }

  Icon getIcon() {
    return Icon(getMainIconData());
  }

  Text? getMainSubtitleHeaderText(BuildContext context) {
    return Text(
      getMainSubtitleTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getMainNullableText(BuildContext context) {
    return Text(
      getMainNullableTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getMainHeaderText(BuildContext context) {
    return Text(
      getMainHeaderTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getMainLabelText(BuildContext context) {
    return Text(
      getMainLabelTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getMainLabelSubtitleText(BuildContext context) {
    return Text(
      getMainLabelSubtitleTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Color getColor(BuildContext context) => Colors.red;

  Widget? getCardTrailing(BuildContext context) {
    return const Icon(Icons.more_vert_outlined);
  }

  Widget getCardLeadingEditCard(BuildContext context) {
    return Icon(getMainIconData(),
        color: context
                .watch<ErrorFieldsProvider>()
                .getFormValidationManager
                .hasError(this as ViewAbstract)
            ? Colors.red
            : Colors.black54);
  }

  Widget getCardLeadingCircleAvatar(BuildContext context) {
    return SizedBox(
        width: 60,
        height: 60,
        child: CircleAvatar(radius: 28, child: getCardLeadingImage(context)));
  }

  Widget getCardLeading(BuildContext context) {
    return Hero(tag: this, child: (getCardLeadingCircleAvatar(context)));
  }

  DismissDirection getDismissibleDirection() {
    return DismissDirection.horizontal;
  }

  void onCardDismissedView(BuildContext context, DismissDirection direction) {
    debugPrint("onDismissed {$this} => direction: $direction");
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
    String? imageUrl = getImageUrl(context);
    if (imageUrl == null) {
      return Icon(getMainIconData());
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(getMainIconData()),
    );
  }

  String? getImageUrl(BuildContext context) {
    return null;
  }

  String getMainSubtitleTextOnly(BuildContext context) {
    return "#${iD.toString()}";
  }

  String getMainNullableTextOnly(BuildContext context) {
    return "is New ${getMainLabelTextOnly(context)}";
  }

  double getCartItemPrice() => 0;
  double getCartItemUnitPrice() => 0;
  double getCartItemQuantity() => 0;

  String getCartItemTextSubtitle(BuildContext context) {
    return getMainSubtitleTextOnly(context);
  }

  String getCartItemText(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  String getMainLabelTextOnly(BuildContext context) {
    return "null";
  }

  List<Widget>? getAppBarActionsEdit(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.save_outlined), onPressed: () {})];

  List<Widget>? getAppBarActionsView(BuildContext context) => null;

  List<Tab> getTabs(BuildContext context) {
    return [
      const Tab(
        text: "OverView",
        // icon: getIcon(),
      ),
      const Tab(
        text: "Inventory",
        // icon: Icon(Icons.history),
      ),
    ];
  }

  InstanceMirror getInstanceMirror() {
    return reflector.reflect(this);
  }

  Type getFieldType(String label) {
    return getInstanceMirror().invokeGetter(label).runtimeType;
  }

  dynamic getFieldValue(String label) {
    try {
      dynamic value = getInstanceMirror().invokeGetter(label);

      // if (value == null) {
      //   Type type = getFieldType(label);
      //   if (type == num) {
      //     return 0;
      //   } else {
      //     return "";
      //   }
      // }
      return value;
    } catch (e) {
      return "$label ${e.toString()}";
    }
  }

  String getTag(String label) {
    return "${T}_$label";
  }

  String getGenericClassName() {
    return "$T";
  }

  DateTime? getFieldDateTimeParse(String? value) {
    if (value == null) {
      return null;
    }
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.parse(value);
  }

  String toJsonString() {
    return jsonEncode(toJsonViewAbstract());
  }
}
