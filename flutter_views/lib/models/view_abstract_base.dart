import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:supercharged/supercharged.dart';

abstract class ViewAbstractBase<T> extends ViewAbstractPermissions<T> {
  String? getTableNameApi();
  List<String> getMainFields({BuildContext? context});
  String getMainHeaderTextOnly(BuildContext context);
  String getMainHeaderLabelTextOnly(BuildContext context);

  IconData getMainIconData();
  String? getMainDrawerGroupName(BuildContext context);
  IconData? getMainDrawerGroupIconData() => null;

  Map<String, String> getFieldLabelMap(BuildContext context);
  Map<String, IconData> getFieldIconDataMap();

  String? getDateTextOnly() {
    dynamic value = getFieldValue("date");
    // if (value == null) return null;
    return value?.toString() ?? "";
  }

  List<TabControllerHelper> getCustomTabList(BuildContext context,
          {ServerActions? action}) =>
      List<TabControllerHelper>.empty();

  IconData getFieldIconData(String field) {
    dynamic value = getMirrorNewInstance(field);
    if (value is ViewAbstract) {
      return value.getMainIconData();
    } else if (value is ViewAbstractEnum) {
      return value.getMainIconData();
    } else {
      return getFieldIconDataMap()[field] ?? Icons.error;
    }
  }

  String getFieldLabel(BuildContext context, String field) {
    return getFieldLabelMap(context)[field] ??
        getMirrorViewAbstractLabelText(context, field);
  }

  String getMainHeaderLabelFileImporter(BuildContext context) {
    return getMainHeaderLabelTextOnly(context);
  }

  String getMainHeaderLabelWithText(BuildContext context) {
    return "${getMainHeaderLabelTextOnly(context)}:${getMainHeaderTextOnly(context)}";
  }

  Text getMainHeaderLabelWithTextWidgt({required BuildContext context}) {
    return Text(getMainHeaderLabelWithText(context),
        style: Theme.of(context).textTheme.caption!);
  }

  String getLabelWithText(String label, String text) {
    return "$label: $text";
  }

  Text getLabelWithTextWidget(String label, String text,
      {BuildContext? context, Color? color}) {
    return Text(getLabelWithText(label, text),
        style: context != null && color != null
            ? Theme.of(context).textTheme.caption!.copyWith(color: color)
            : Theme.of(context!).textTheme.caption!);
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

  Widget? getMainSubtitleHeaderText(BuildContext context) {
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

  Widget getMainHeaderTextOnEdit(BuildContext context) {
    return Text(isNull
            ? AppLocalizations.of(context)!.undefined.toUpperCase()
            : getMainHeaderTextOnly(context).toUpperCase()
        // style: const TextStyle(color: kTextLightColor)
        );
  }

  Widget getMainHeaderText(BuildContext context) {
    return Text(getMainHeaderTextOnly(context)
        // style: const TextStyle(color: kTextLightColor)
        );
  }

  Widget getHorizontalCardTitle(BuildContext context) {
    return Column(
      children: [
        getMainLabelText(context),
        Text(
          getIDFormat(context),
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }

  Widget getHorizontalCardMainHeader(BuildContext context) {
    return Text(getMainHeaderTextOnly(context));
  }

  Widget getHorizontalCardSubtitle(BuildContext context) {
    return getMainSubtitleHeaderText(context) ??
        Text(
          "",
          style: Theme.of(context).textTheme.caption,
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

  String getAddToFormat(BuildContext context) {
    return AppLocalizations.of(context)!
        .addToFormat(getMainHeaderLabelTextOnly(context).toLowerCase());
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
      if (e.autoRest != null) {
        return ListApiAutoRestWidget(
          autoRest: e.autoRest!,
        );
      }
      if (e.widget != null) {
        return SingleChildScrollView(child: e.widget!);
      }
      return const Text("This is the sec page");
    }).toList();
  }

  List<TabControllerHelper> getTabs(BuildContext context,
      {ServerActions? action}) {
    return [
      TabControllerHelper(
        getMainHeaderTextOnly(context),
        // getMainIconData(),
      ),
      ...getCustomTabList(context)
    ];
  }

  Map<GroupItem, List<String>> getMainFieldsGroups(BuildContext context) => {};

  List<String> getMainFieldsWithOutGroups(BuildContext context) {
    Map<GroupItem, List<String>> map = getMainFieldsGroups(context);
    if (map.isEmpty) return getMainFields(context: context);
    List<String> mainField = getMainFields(context: context);
    map.forEach((key, value) {
      for (var element in value) {
        if (mainField.contains(element)) {
          mainField.remove(element);
        }
      }
    });
    return mainField;
  }

  String getTag(String field) {
    return field;
  }

  int getParentsCount({int count = 0}) {
    if (getParnet == null) return count;
    return getParnet!.getParentsCount(count: count + 1);
  }

  String getGenericClassName() {
    return "$T";
  }

  String? getFieldDateTimeParseFromDateTime(DateTime? dateTime) {
    return dateTime.toDateTimeString();
  }

  DateTime getFieldDateTimeParse(String? value) {
    return value.toDateTime();
  }

  List<DropdownStringListItem> getMainFieldsIconsAndValues(
      BuildContext context) {
    return getMainFields(context: context)
        .map((e) => DropdownStringListItem(
            getFieldIconData(e), getFieldLabel(context, e),
            value: isViewAbstract(e)
                ? getMirrorNewInstanceViewAbstract(e).getForeignKeyName()
                : e))
        .toList();
  }
}

class GroupItem {
  String label;
  IconData icon;

  GroupItem(this.label, this.icon);
}

class TabControllerHelper extends Tab {
  ///Auto get the field list from the parent
  ///
  String? fieldThatHasList;

  ///Auto get the field list from the api object;
  AutoRest? autoRest;

  Widget? widget;

  TabControllerHelper(String title,
      {super.key,
      Widget? icon,
      this.fieldThatHasList,
      this.autoRest,
      this.widget})
      : super(icon: icon, text: title);
}
