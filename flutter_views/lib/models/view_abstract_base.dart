import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_widget.dart';
import 'package:intl/intl.dart';

abstract class ViewAbstractBase<T> extends ViewAbstractPermissions<T> {
  String? getTableNameApi();
  List<String> getMainFields();
  String getMainHeaderTextOnly(BuildContext context);
  String getMainHeaderLabelTextOnly(BuildContext context);

  IconData getMainIconData();
  String? getMainDrawerGroupName(BuildContext context);
  IconData? getMainDrawerGroupIconData() => null;

  Map<String, String> getFieldLabelMap(BuildContext context);
  Map<String, IconData> getFieldIconDataMap();
  double getCartItemPrice() => 0;
  double getCartItemUnitPrice() => 0;
  double getCartItemQuantity() => 0;

  String? getDateTextOnly() {
    dynamic value = getFieldValue("date");
    // if (value == null) return null;
    return value?.toString() ?? "";
  }

  List<TabControllerHelper> getCustomTabList(BuildContext context) =>
      List<TabControllerHelper>.empty();

  T fromJsonViewAbstract(Map<String, dynamic> json);
  Map<String, dynamic> toJsonViewAbstract();

  IconData getFieldIconData(String field) {
    return getFieldIconDataMap()[field] ??
        getMirrorNewInstance(field)?.getMainIconData() ??
        Icons.error;
  }

  String getFieldLabel(BuildContext context, String field) {
    return getFieldLabelMap(context)[field] ??
        getMirrorViewAbstractLabelText(context, field);
  }

  String getMainHeaderLabelWithText(BuildContext context) {
    return "${getMainHeaderLabelTextOnly(context)}:${getMainHeaderTextOnly(context)}";
  }

  ViewAbstract? getFieldValueCastViewAbstract(String field) {
    try {
      return getFieldValue(field) as ViewAbstract;
    } catch (e) {
      return null;
    }
  }

  Icon getFieldIcon(String field) {
    return Icon(getFieldIconDataMap()[field]);
  }

  Icon getIcon() {
    return Icon(getMainIconData());
  }

  Text? getMainSubtitleHeaderText(BuildContext context) {
    return Text(
      getMainHeaderLabelTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getMainNullableText(BuildContext context) {
    return Text(
      getMainNullableTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text getMainHeaderText(BuildContext context) {
    return Text(
      getMainHeaderTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text getMainLabelText(BuildContext context) {
    return Text(
      getMainHeaderLabelTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getMainLabelSubtitleText(BuildContext context) {
    return Text(
      getMainHeaderLabelTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Color getColor(BuildContext context) => Colors.red;

  Widget? getCardTrailing(BuildContext context) {
    return const Icon(Icons.more_vert_outlined);
  }

  bool hasImageLoadButton() {
    return false;
  }

  String? getImageUrl(BuildContext context) {
    return null;
  }

  String getIDFormat(BuildContext context) {
    return "#${iD.toString()}";
  }

  String getIDString() {
    return "$iD";
  }

  String getMainNullableTextOnly(BuildContext context) {
    return "is New ${getMainHeaderLabelTextOnly(context)}";
  }

  List<Widget>? getAppBarActionsEdit(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.save_outlined), onPressed: () {})];

  List<Widget>? getAppBarActionsView(BuildContext context) => null;

  List<Widget> getTabsViewGenerator(BuildContext context,
      {List<TabControllerHelper>? tabs}) {
    List<TabControllerHelper> tabsList = tabs ?? getTabs(context);
    return tabsList.map((e) {
      if (tabsList.indexOf(e) == 0) {
        return Text("This is the main page");
      }
      if (e.autoRest != null) {
        return ListApiAutoRestWidget(
          autoRest: e.autoRest!,
        );
      }
      return Text("This is the sec page");
    }).toList();
  }

  List<TabControllerHelper> getTabs(BuildContext context) {
    return [
      TabControllerHelper(
        getMainHeaderTextOnly(context),
        getMainIconData(),
      ),
      ...getCustomTabList(context)
    ];
  }

  String parentsTagThis() {
    return parentsTag(this as ViewAbstract, []);
  }

  String parentsTag(ViewAbstract p, List<String> parentsString) {
    ViewAbstract? parent = p.getParnet;
    if (parent == null) {
      if (parentsString.isEmpty) {
        return "";
      } else {
        parentsString.add("${getTableNameApi()}");
      }
      return parentsString.join("=");
    } else {
      parentsString.add("${parent.getTableNameApi()}");
      return parentsTag(parent, parentsString);
    }
  }

  String getTagWithFirstParent() {
    String? parentTableName = getParnet?.getTableNameApi();
    if (parentTableName == null) {
      return getTableNameApi() ?? "no_table_api";
    }
    return "${parentTableName}_${getTableNameApi()}";
  }

  String getTag(String field) {
    String parentTag = parentsTag(this as ViewAbstract, []);
    if (parentTag.isEmpty) {
      return field;
    }
    return "$parentTag=$field";
  }

  String getGenericClassName() {
    return "$T";
  }

  String? getFieldDateTimeParseFromDateTime(DateTime? dateTime) {
    if (dateTime == null) return null;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.format(dateTime);
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

  List<DropdownStringListItem> getMainFieldsIconsAndValues(
      BuildContext context) {
    return getMainFields()
        .map((e) => DropdownStringListItem(
            getFieldIconData(e), getFieldLabel(context, e),
            value: isViewAbstract(e)
                ? getMirrorNewInstanceViewAbstract(e).getForeignKeyName()
                : e))
        .toList();
  }

  PrintCommandAbstract? getPrintCommand(BuildContext context) => null;
}

class TabControllerHelper extends Tab {
  ///Auto get the field list from the parent
  ///
  String? fieldThatHasList;

  ///Auto get the field list from the api object;
  AutoRest? autoRest;

  TabControllerHelper(String title, IconData icon,
      {this.fieldThatHasList, this.autoRest})
      : super(icon: Icon(icon), text: title);
}
