import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_menu_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_custom_scroll_draggable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_custom_scroll_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_list_grouped.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/list_web_api.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/util.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

import '../../customs_widget/sliver_delegates.dart';

class SettingAndProfileWeb extends BaseWebPageSlivers {
  ValueNotifier<ActionOnToolbarItem?> selectedValue =
      ValueNotifier<ActionOnToolbarItem?>(null);

  SettingAndProfileWeb({
    super.key,
    super.buildFooter = false,
    super.buildHeader = false,
  });

  @override
  Widget? getCustomAppBar(BuildContext context, BoxConstraints? constraints) {
    return null;
  }

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      getSliverPadding(
          context,
          constraints,
          SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kBorderRadius / 2),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 500,
                              child: ClipRect(
                                child: Container(
                                  // height: 200,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(.5),
                                  child: ProfileMenuWidget(
                                      selectedValue: selectedValue),
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: SizedBox(
                              height: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(kDefaultPadding),
                                child: ValueListenableBuilder<
                                        ActionOnToolbarItem?>(
                                    valueListenable: selectedValue,
                                    builder: (context, value, child) {
                                      return getWidgetFromProfile(
                                          context: context,
                                          value: value,
                                          valueNotifier: ValueNotifier<
                                              ActionOnToolbarItem?>(null),
                                          pinToolbar: pinToolbar);
                                    }),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
          padd: 1.2),
    ];
  }

  ViewAbstract getListOfOrders(BuildContext context) {
    AuthProvider authProvider = context.read<AuthProvider<AuthUser>>();
    ViewAbstract orderSample = authProvider.getOrderSimple;
    String key = authProvider.getUser.isGeneralEmployee(context)
        ? "EmployeeID"
        : "CustomerID";
    orderSample.setCustomMap({"<$key>": "${authProvider.getUser.iD}"});
    return orderSample;
  }
}

class OrdersWeb extends StatelessWidget {
  const OrdersWeb({super.key});

  ViewAbstract getListOfOrders(BuildContext context) {
    AuthProvider authProvider = context.read<AuthProvider<AuthUser>>();
    ViewAbstract orderSample = authProvider.getOrderSimple;
    String key = authProvider.getUser.isGeneralEmployee(context)
        ? "EmployeeID"
        : "CustomerID";
    orderSample.setCustomMap({"<$key>": "${authProvider.getUser.iD}"});
    return orderSample;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          //TODO translate
          title: Text("Orders"),
        ),
        ListTile(
          subtitle: Text(AppLocalizations.of(context)!.logingoutDesc),
        ),
        ProductWebPage(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(onPressed: () {}, child: const Text("Logout")),
        ),
      ],
    );
  }
}

class SettingAndProfileList extends StatelessWidget {
  const SettingAndProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.computer),
          title: Text("This is a test $index"),
        );
      },
      shrinkWrap: true,
      itemCount: 5,
    );
  }
}

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.logout),
        ),
        ListTile(
          subtitle: Text(AppLocalizations.of(context)!.logingoutDesc),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.logout)),
        ),
      ],
    );
  }
}

class PrintSetting extends BasePage {
  const PrintSetting({super.key, super.buildSecondPane});

  @override
  State<PrintSetting> createState() => _PrintSettingState();
}

class _PrintSettingState extends BasePageState<PrintSetting> {
  late Map<String, List<dynamic>> _list;
  Widget popMenuItem(BuildContext context, ActionOnToolbarItem item) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Icon(
            item.icon,
            size: 15,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                item.actionTitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getItem(BuildContext ctx, ModifiableInterface element) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      child: ListTile(
        // selectedTileColor: Colors.white,
        selected: ctx.watch<SettingProvider>().getSelectedObject?.hashCode ==
            element.hashCode,
        onTap: () {
          ctx.read<SettingProvider>().change(element);
        },
        // contentPadding:
        //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(
          element.getModifibleIconData(),
          size: 15,
        ),
        title: Text(
          element.getModifibleTitleName(ctx),
          style: Theme.of(ctx).textTheme.bodySmall,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return super.build(context);
    List<ModifiableInterface> modifieableList =
        context.read<SettingProvider>().getModifiableListSetting(context);
    _list = modifieableList.groupBy(
      (element) => element.getModifiableMainGroupName(context),
    );
    return ScreenHelperSliver(
        forceSmallView: false,
        requireAutoPadding: setMainPageSuggestionPadding(),
        onChangeLayout: (w, h, c) {},
        mobile: (w, h) {
          return newMethod(context);
        },
        smallTablet: (w, h) {
          return newMethod(context);
        },
        largeTablet: (w, h) {
          return newMethod(context);
        },
        desktop: (w, h) {
          return newMethod(context);
        });
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: SliverCustomScrollView(
                slivers: getListStickyWidget(
                    context,
                    _list.entries
                        .map(
                          (e) => StickyItem(
                              title: e.key,
                              widgets: e.value
                                  .map(
                                    (c) => _getItem(context, c),
                                  )
                                  .toList()),
                        )
                        .toList()),
              )),
          const Expanded(flex: 3, child: Text("Dsada")),
        ],
      ),
    );
  }

  Scaffold newMethod(BuildContext context) {
    return Scaffold(
      body: TowPaneExt(
        customPaneProportion: .5,
        startPane: Scaffold(
          body: SliverCustomScrollViewDraggable(
            slivers: getListStickyWidget(
                context,
                _list.entries
                    .map(
                      (e) => StickyItem(
                          title: e.key,
                          widgets: e.value
                              .map(
                                (c) => _getItem(context, c),
                              )
                              .toList()),
                    )
                    .toList()),
          ),
        ),
        endPane: const Scaffold(
            body: SliverCustomScrollViewDraggable(slivers: [
          SliverToBoxAdapter(
            child: Text("sdkkjjk"),
          )
        ])),
      ),
    );
  }

  @override
  Widget? getAppbarTitle(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    return null;
  }

  @override
  Widget? getFloatingActionButton(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableExpandedHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  List<Widget> getPane({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    // debugPrint("PrintSetting $f");
    if (firstPane) {
      return getListStickyWidget(
          context,
          _list.entries
              .map(
                (e) => StickyItem(
                    title: e.key,
                    widgets: e.value
                        .map(
                          (c) => _getItem(context, c),
                        )
                        .toList()),
              )
              .toList());
    } else {
      return [
        const SliverToBoxAdapter(
          child: Text("dsa"),
        )
      ];
    }
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneClipRect(bool firstPane) => false;
}

class AdminSetting extends StatelessWidget {
  const AdminSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("sda");
  }
}

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
          onPressed: () {}, child: const Icon(Icons.save)),
      body: ListView(
        shrinkWrap: true,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!
                .editFormat(AppLocalizations.of(context)!.profile)),
          ),
          BaseEditWidget(
            viewAbstract: context.read<AuthProvider<AuthUser>>().getUser,
            onValidate: (viewAbstract) {
              // billingCustomerNotifier.value = viewAbstract;
            },
            isTheFirst: true,
          ),
        ],
      ),
    );
  }
}

class MasterToListFromProfile extends StatefulWidget {
  final bool pinToolbar;
  bool buildFooter;
  bool buildHeader;
  bool buildSmallView;
  bool useSmallFloatingBar;
  ViewAbstract? initialValue;
  ValueNotifier<ActionOnToolbarItem?>? valueNotiferActionOnToolbarItem;
  MasterToListFromProfile(
      {super.key,
      required this.pinToolbar,
      this.buildFooter = false,
      this.buildSmallView = true,
      this.useSmallFloatingBar = true,
      this.valueNotiferActionOnToolbarItem,
      this.initialValue,
      this.buildHeader = false});

  @override
  State<MasterToListFromProfile> createState() =>
      _MasterToListFromProfileState();
}

class _MasterToListFromProfileState extends State<MasterToListFromProfile>
    with ActionOnToolbarSubPaneMixin {
  ValueNotifier<ViewAbstract?> selectedCardValue =
      ValueNotifier<ViewAbstract?>(null);

  Widget? customSliverHeader;
  ViewAbstract? _initialValue;

  ViewAbstract getListOfOrders(BuildContext context) {
    AuthProvider authProvider = context.read<AuthProvider<AuthUser>>();
    ViewAbstract orderSample = authProvider.getOrderSimple;
    String key = authProvider.getUser.isGeneralEmployee(context)
        ? "EmployeeID"
        : "CustomerID";
    orderSample.setCustomMap({"<$key>": "${authProvider.getUser.iD}"});
    return orderSample;
  }

  @override
  void initState() {
    _initialValue = widget.initialValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ViewAbstract?>(
      valueListenable: selectedCardValue,
      builder: (context, value, child) {
        value = _initialValue ?? value;
        if (value != null) {
          return WebProductView(
            buildSmallView: widget.buildSmallView,
            buildHeader: widget.buildHeader,
            useSmallFloatingBar: widget.useSmallFloatingBar,
            iD: value.iD,
            tableName: value.getTableNameApi()!,
            extras: value,
            buildFooter: widget.buildFooter,
            customSliverHeader: SliverPersistentHeader(
              pinned: widget.pinToolbar,
              // floating: true,
              delegate: SliverAppBarDelegatePreferedSize(
                  child: PreferredSize(
                      preferredSize: const Size.fromHeight(70.0),
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              debugPrint("backbutton pressed");
                              selectedCardValue.value = null;
                            },
                          ),
                          title: value.getMainHeaderText(context),
                        ),
                      ))),
            ),
          );
        }
        return ListWebApiPage(
          buildHeader: widget.buildHeader,
          buildFooter: widget.buildFooter,
          useSmallFloatingBar: widget.useSmallFloatingBar,
          pinToolbar: widget.pinToolbar,
          onCardTap: selectedCardValue,
          customHeader: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text("Orders"),
                subtitle: Text(AppLocalizations.of(context)!.logingoutDesc),
              ),
            ],
          ),
          viewAbstract: getListOfOrders(context),
        );
      },
    );
  }

  @override
  IconData getIconDataID() {
    return Icons.shopping_basket_rounded;
  }

  @override
  ValueNotifier<ActionOnToolbarItem?>? getOnActionAdd() {
    return widget.valueNotiferActionOnToolbarItem;
  }

  @override
  ValueNotifier onChangeThatHasToAddAction() {
    return selectedCardValue;
  }
}

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.help),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.saffouryPaperLTD),
          subtitle: Text(Utils.version),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.helpCenter)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.contactUs)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.license)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.termsAndConitions)),
        ),
        const Divider(),
        ListTile(subtitle: Text(AppLocalizations.of(context)!.copyRight)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: kDefaultPadding),
          child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      WidgetStateProperty.all<Color>(Colors.orange)),
              onPressed: () {},
              child: Text(AppLocalizations.of(context)!.developmentBy)),
        ),
      ],
    );
  }
}
