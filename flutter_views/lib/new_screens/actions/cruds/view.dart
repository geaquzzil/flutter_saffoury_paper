import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';
import 'package:flutter_view_controller/new_components/lists/view_card_item.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ViewNew extends BasePageApi {
  bool overrideTrailingToNull;

  ///[key] is required for navigation header
  ViewNew({
    super.key,
    super.buildSecondPane,
    super.iD,
    super.tableName,
    super.extras,
    this.overrideTrailingToNull = false,
    super.forceHeaderToCollapse = true,
    super.isFirstToSecOrThirdPane = true,
    super.onBuild,
    super.parent,
  });

  @override
  State<ViewNew> createState() {
    return _ViewNewState();
  }
}

class _ViewNewState extends BasePageStateWithApi<ViewNew>
    with BasePageSecoundPaneNotifierState<ViewNew> {
  final kk = GlobalKey<BasePageSecoundPaneNotifierState>();
  Widget buildItem(BuildContext context, String field) {
    debugPrint("MasterView buildItem $field");
    dynamic fieldValue = getExtrasCast().getFieldValue(field);
    if (fieldValue == null) {
      return ViewCardItem(
        // secNotifier: getSecondPaneNotifier,
        title: field,
        description: "null",
        icon: Icons.abc,
        overrideTrailingToNull: widget.overrideTrailingToNull,
      );
    } else if (fieldValue is ViewAbstract) {
      return ViewCardItem(
        secNotifier: getSecondPaneNotifier,
        state: getSecoundPaneHelper(),
        isSelectForListTile: (object) {
          return isSelectForCard(object);
        },
        title: "",
        description: "",
        icon: Icons.abc,
        object: fieldValue,
        overrideTrailingToNull: widget.overrideTrailingToNull,
      );
    } else if (fieldValue is ViewAbstractEnum) {
      return ViewCardItem(
        // secNotifier: getSecondPaneNotifier,
        title: fieldValue.getMainLabelText(context),
        description: fieldValue.getFieldLabelString(context, fieldValue),
        icon: fieldValue.getFieldLabelIconData(context, fieldValue),
        overrideTrailingToNull: widget.overrideTrailingToNull,
        object: null,
      );
    } else {
      return ViewCardItem(
        // secNotifier: getSecondPaneNotifier,
        overrideTrailingToNull: widget.overrideTrailingToNull,
        title: getExtrasCast().getFieldLabel(context, field),
        description: fieldValue.toString(),
        icon: getExtrasCast().getFieldIconData(field),
      );
    }
  }

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) {
    return null;
  }

  @override
  String? getScrollKey({required bool firstPane}) {
    if (firstPane) {
      return "view";
    }
    return "${(lastSecondPaneItem?.value.toString()) ?? ""}view";
  }

  @override
  double getCustomPaneProportion() {
    return .3;
  }

  @override
  List<Widget>? getCustomViewWhenSecondPaneIsEmpty(
    ScrollController? controler,
    TabControllerHelper? tab,
  ) {
    if (tab?.isMain == false) {
      return null;
    }
    List<Widget>? customTopWidgets = getExtrasCast().getCustomTopWidget(
      context,
      action: ServerActions.view,
      onClick: getSecondPaneNotifier,
      basePage: getSecoundPaneHelper(),
    );
    List<Widget>? customBottomWidgets = getExtrasCast().getCustomBottomWidget(
      context,
      action: ServerActions.view,
      basePage: getSecoundPaneHelper(),
    );
    return [
      if (customTopWidgets != null)
        MultiSliver(
          children: [
            ...customTopWidgets.map((e) => SliverToBoxAdapter(child: e)),
          ],
        ),
      SliverToBoxAdapter(child: SizedBox(height: kDefaultPadding)),
      if (customBottomWidgets != null) ...customBottomWidgets,
    ];
  }

  @override
  List<TabControllerHelper>? getPaneTabControllerHelperPaneNotifier({
    required bool firstPane,
  }) {
    // return null;
    if (firstPane == false) {
      dynamic val = getExtras();
      debugPrint("getPaneTabControllerHelper firstPane=false");
      if (val is ViewAbstract) {
        debugPrint("getPaneTabControllerHelper");
        return val.getCustomTabList(
          context,
          action: ServerActions.view,
          basePage: getSecoundPaneHelper(),
        );
      }
      return null;
    }
    return super.getPaneTabControllerHelperPaneNotifier(firstPane: firstPane);
  }

  @override
  List<Widget>? getAppbarActions({bool? firstPane}) {
    if (firstPane == true) {
      return [
        ActionsOnHeaderWidget(
          base: getSecoundPaneHelper(),
          viewAbstract: getExtras(),
          serverActions: getServerActions(),
        ),
        //TODO
        // ActionsOnHeaderPopupWidget(

        //   viewAbstract: getExtras(),
        //   serverActions: getServerActions(),
        // ),
      ];
    }
    return null;
  }

  @override
  Widget? getAppbarTitle({
    bool? firstPane,
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  }) {
    if (firstPane == true) {
      return Text(
        getExtrasCast().getBaseTitle(
          context,
          descriptionIsId: true,
          serverAction: ServerActions.view,
        ),
      );
    }
    if (firstPane == false) {
      return Text(getSecPaneTitle());
    }
    return Text("dsadas");
  }

  @override
  Widget? getFloatingActionButtonPaneNotifier({
    bool? firstPane,
    TabControllerHelper? tab,
  }) {
    // if (isSecPane(firstPane: firstPane)) {
    //   if (geSelectedValue() is BarcodeSetting ||
    //       (geSelectedValue() is PrinterDefaultSetting)) {
    //     return FloatingActionButton.small(
    //       //todo translate
    //       child: const Tooltip(
    //           message: "AppLocalizations.of(context)!.refresh",
    //           child: Icon(Icons.refresh)),
    //       onPressed: () {
    //         setState(() {});
    //       },
    //     );
    //   }
    // }
    return null;
  }

  @override
  Widget? getPaneDraggableExpandedHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  bool isCartableInterface() {
    return getExtrasCast() is CartableProductItemInterface;
  }

  @override
  Widget? getBottomNavigationBar({bool? firstPane, TabControllerHelper? tab}) {
    if (firstPane == true) {
      return isCartableInterface()
          ? BottomAppBar(
              height: 80,
              // color: Theme.of(context).colorScheme.surface,
              // elevation: 2,
              // shape: const AutomaticNotchedShape(RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(25),
              //       bottomLeft: Radius.circular(25),
              //       bottomRight: Radius.circular(25),
              //       topRight: Radius.circular(25)),
              // )),
              child: BottomWidgetOnViewIfCartable(
                viewAbstract: getExtrasCast() as CartableProductItemInterface,
              ),
            )
          : null;
    }
    return null;
  }

  @override
  List<Widget>? getPaneNotifier({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
    SecondPaneHelper? valueNotifier,
  }) {
    if (tab != null) {
      return [if (tab.widget != null) tab.widget!];
    }
    if (firstPane) {
      final fields = getExtrasCast()
          .getMainFields(context: context)
          .where((element) => getExtrasCast().getFieldValue(element) != null)
          .toList();
      return [
        SliverToBoxAdapter(
          child: getExtrasCast().getImageWithRoundedCorner(
            context,
            // size: getHeight * .25,
            withAspectRatio: 1 / 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return buildItem(context, fields[index]);
            },
            // 40 list items
            childCount: fields.length,
          ),
        ),
        if (isExtrasIsListable())
          SliverApiMixinStaticList(
            header: HeaderDescription(
              title: AppLocalizations.of(context)!.list,
              isSliver: true,
            ),
            list: getExtrasCastListable().getListableList(),
            isSelectForCard: (object) {
              return isSelectForCard(object);
            },
            state: getSecoundPaneHelper(),
            enableSelection: false,
          ),

        // SliverToBoxAdapter(child: SizedBox(height: 80)),
      ];
    } else {
      // return [const SliverToBoxAdapter(child: Text("S"))];
      if (valueNotifier?.value is List<Widget>) {
        return valueNotifier!.value;
      }
      return [
        if (valueNotifier?.value != null)
          SliverFillRemaining(
            child: ViewNew(
              extras: valueNotifier!.value as ViewAbstract,
              buildSecondPane: true,
              onBuild: onBuild,
              key: kk,
              parent: this,
            ),
          ),
      ];
    }
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) => firstPane;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) => true;

  // @override
  // bool setPaneBodyPaddingVertical(bool firstPane) {
  //   // TODO: implement setPaneBodyPaddingVertical
  //   return firstPane;
  // }

  @override
  bool setClipRect(bool? firstPane) => true;

  @override
  String onActionInitial() {
    return AppLocalizations.of(context)!.printerSetting;
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }
}
