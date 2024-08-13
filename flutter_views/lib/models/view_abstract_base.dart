import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
  String getPritablePageTitle(BuildContext context) {
    return "${AppLocalizations.of(context)!.print} ${getMainHeaderLabelTextOnly(context)}";
  }

  String? getDateTextOnly() {
    dynamic value = getFieldValue("date");
    return value;
  }

  String? getDateTextOnlyFormat(BuildContext context) {
    return getDateTextOnly().toDateTimeOnlyDateString();
  }

  List<String> getMainFieldsForTable({BuildContext? context}) {
    return getMainFields(context: context);
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

  IconData? getFieldIconDataNullAccepted(String field) {
    dynamic value = getMirrorNewInstance(field);
    if (value is ViewAbstract) {
      return value.getMainIconData();
    } else if (value is ViewAbstractEnum) {
      return value.getMainIconData();
    } else {
      return getFieldIconDataMap()[field];
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
        style: Theme.of(context).textTheme.bodySmall!);
  }

  String getLabelWithText(String label, String text) {
    return "$label: $text";
  }

  Text getLabelWithTextWidget(String label, String text,
      {BuildContext? context, Color? color}) {
    return Text(getLabelWithText(label, text),
        style: context != null && color != null
            ? Theme.of(context).textTheme.bodySmall!.copyWith(color: color)
            : Theme.of(context!).textTheme.bodySmall!);
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

  Widget? getWebListTileItemTitle(BuildContext context) {
    return getMainHeaderText(context);
  }

  Widget? getWebListTileItemSubtitle(BuildContext context) {
    return getMainSubtitleHeaderText(context);
  }

  Widget? getWebListTileItemLeading(BuildContext context) {
    return getCardTrailing(context);
  }

  Widget getHorizontalCardTitleSameLine(
    BuildContext context, {
    PaletteGenerator? color,
    Animation<Color?>? animatedColor,
    bool isImageAsBackground = true,
  }) {
    return Text(
      "${getMainHeaderLabelTextOnly(context)} ${getIDFormat(context)}",
      style: isImageAsBackground
          ? Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: animatedColor != null
                  ? animatedColor.value
                  : color != null
                      ? color.darkMutedColor?.color
                      : Theme.of(context).colorScheme.onPrimaryContainer)
          : Theme.of(context).textTheme.bodySmall,
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Widget getHorizontalCardTitle(BuildContext context,
      {bool isImageAsBackground = false, PaletteGenerator? color}) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getMainHeaderLabelTextOnly(context),
          style: isImageAsBackground
              ? Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color != null
                      ? color.lightMutedColor?.color
                      : Theme.of(context).colorScheme.onPrimaryContainer)
              : Theme.of(context).textTheme.bodySmall,
          // style: const TextStyle(color: kTextLightColor)
        ),
        Text(
          getIDFormat(context),
          style: isImageAsBackground
              ? Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color != null
                      ? color.lightMutedColor?.color
                      : Theme.of(context).colorScheme.onPrimaryContainer)
              : Theme.of(context).textTheme.bodySmall,
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
          style: Theme.of(context).textTheme.bodySmall,
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
    return null;
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

  Widget? getTabControllerFirstHeaderWidget(BuildContext context) {
    return null;
  }

  List<TabControllerHelper> getTabs(BuildContext context,
      {ServerActions? action}) {
    return [
      TabControllerHelper(
        getMainHeaderTextOnly(context),
        // draggableSwithHeaderFromAppbarToScroll:
        //     getTabControllerFirstHeaderWidget(context),
        // getMainIconData(),
      ),
      ...getCustomTabList(context)
    ];
  }

  ListableInterface getListableInterface() {
    return this as ListableInterface;
  }

  CartableProductItemInterface getCartableProductItemInterface() {
    return this as CartableProductItemInterface;
  }

  bool isCartable() {
    return this is CartableProductItemInterface;
  }

  bool isListable() {
    return this is ListableInterface;
  }

  bool isImagable() {
    if (this is! ListableInterface) return false;
    return (this as ListableInterface).isListableIsImagable();
  }

  Map<GroupItem, List<String>> getMainFieldsGroups(BuildContext context) => {};
  Map<int, List<String>> getMainFieldsHorizontalGroups(BuildContext context) =>
      {};
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

  String getFieldValueFromDropDownString(String selectedValue) {
    dynamic d = getMirrorFieldsMapNewInstance()[selectedValue];
    if (d is ViewAbstract) {
      return d.getForeignKeyName();
    } else {
      return selectedValue;
    }
  }

  String getBaseActionText(BuildContext context,
      {ServerActions? serverAction}) {
    if (serverAction != null) {
      switch (serverAction) {
        case ServerActions.add:
          return AppLocalizations.of(context)!.add.toLowerCase();
        case ServerActions.edit:
          return AppLocalizations.of(context)!.edit.toLowerCase();
        case ServerActions.view:
          return AppLocalizations.of(context)!.view.toLowerCase();
        case ServerActions.delete_action:
          return AppLocalizations.of(context)!.delete.toLowerCase();
        case ServerActions.list:
          return AppLocalizations.of(context)!.list.toLowerCase();

        case ServerActions.print:
          return AppLocalizations.of(context)!.print.toLowerCase();
        default:
          return "";
      }
    } else {
      if (isNew()) {
        return AppLocalizations.of(context)!.add.toLowerCase();
      } else {
        return AppLocalizations.of(context)!.edit.toLowerCase();
      }
    }
    return "";
  }

  String getBaseTitle(BuildContext context,
      {ServerActions? serverAction, bool descriptionIsId = false}) {
    String descripon = "";
    if (descriptionIsId) {
      descripon = getIDFormat(context);
    } else {
      if (isEditing()) {
        descripon = getMainHeaderTextOnly(context).toLowerCase();
      } else {
        descripon = getMainHeaderLabelTextOnly(context).toLowerCase();
      }
    }
    return "${getBaseActionText(context, serverAction: serverAction).toUpperCase()} $descripon ";
  }

  String getBaseLabelViewAbstract(BuildContext context) {
    return getMainHeaderLabelTextOnly(context).toLowerCase();
  }

  String getBaseMessage(BuildContext context) {
    return "${AppLocalizations.of(context)!.areYouSure}${getBaseActionText(context)} ${getBaseLabelViewAbstract(context)} ";
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
  ///
  ///

  String? fieldThatHasList;

  ///Auto get the field list from the api object;
  AutoRest? autoRest;

  Widget? widget;
  List<Widget>? slivers;

  ///this for ViewAbstractStandAloneCustomViewApi to let knw
  bool isResponsiveIsSliver;
  Widget? draggableHeaderWidget;
  Widget? draggableSwithHeaderFromAppbarToScroll;
  AlignmentDirectional? draggableSwithHeaderFromAppbarToScrollAlignment;
  Widget? draggableExtendedWidget;

  ///could return List<Widget> if sliver or Widget if not sliver
  Function? autoRestWidgetBuilder;
  ViewAbstract? autoRestWidgetBuilderViewAbstract;

  int? iD;
  String? tableName;

  //should be viewAbstract or dashboard or etc...
  dynamic extras;

  final ScrollController scrollFirstPaneController = ScrollController();
  final ScrollController scrollSecoundPaneController = ScrollController();

  TabControllerHelper(String title,
      {super.key,
      super.icon,
      this.fieldThatHasList,
      this.autoRest,
      this.slivers,
      this.iD,
      this.tableName,
      this.autoRestWidgetBuilder,
      this.extras,
      this.draggableHeaderWidget,
      this.draggableExtendedWidget,
      this.draggableSwithHeaderFromAppbarToScrollAlignment =
          AlignmentDirectional.topCenter,
      this.draggableSwithHeaderFromAppbarToScroll,
      this.isResponsiveIsSliver = false,
      this.widget})
      : super(text: title);
}
