import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_menu_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/list_web_api.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:flutter_view_controller/utils/util.dart';
import 'package:provider/provider.dart';

import '../../customs_widget/sliver_delegates.dart';

class SettingAndProfileWeb extends BaseWebPageSlivers {
  ValueNotifier<ItemModel?> selectedValue = ValueNotifier<ItemModel?>(null);

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
                                child: ValueListenableBuilder<ItemModel?>(
                                    valueListenable: selectedValue,
                                    builder: (context, value, child) {
                                      return getWidgetFromProfile(
                                          context, value, pinToolbar);
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
          title: Text("Orders"),
        ),
        const ListTile(
          subtitle:
              Text("By logining you out all of your data will be cleared."),
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
        const ListTile(
          title: Text("Logout"),
        ),
        const ListTile(
          subtitle:
              Text("By logining you out all of your data will be cleared."),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(onPressed: () {}, child: const Text("Logout")),
        ),
      ],
    );
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
          const ListTile(
            title: Text("Edit Profile"),
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

class MasterToListFromProfile extends StatelessWidget {
  final bool pinToolbar;
  ValueNotifier<ViewAbstract?> selectedCardValue =
      ValueNotifier<ViewAbstract?>(null);
  bool buildFooter;
  bool buildHeader;
  bool buildSmallView;
  bool useSmallFloatingBar;
  Widget? customSliverHeader;

  MasterToListFromProfile(
      {super.key,
      required this.pinToolbar,
      this.buildFooter = false,
      this.buildSmallView = true,
      this.useSmallFloatingBar = true,
      this.buildHeader = false});

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
    return ValueListenableBuilder<ViewAbstract?>(
      valueListenable: selectedCardValue,
      builder: (context, value, child) {
        if (value != null) {
          return WebProductView(
            buildSmallView: buildSmallView,
            buildHeader: buildHeader,
            useSmallFloatingBar: useSmallFloatingBar,
            iD: value.iD,
            tableName: value.getTableNameApi()!,
            extras: value,
            buildFooter: buildFooter,
            customSliverHeader: SliverPersistentHeader(
              pinned: pinToolbar,
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
          buildHeader: buildHeader,
          buildFooter: buildFooter,
          useSmallFloatingBar: useSmallFloatingBar,
          pinToolbar: pinToolbar,
          onCardTap: selectedCardValue,
          customHeader: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Orders"),
                subtitle: Text(
                    "By logining you out all of your data will be cleared."),
              ),
            ],
          ),
          viewAbstract: getListOfOrders(context),
        );
      },
    );
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
        const ListTile(
          //todo translate
          title: Text("Help"),
        ),
        ListTile(
          //todo translate
          title: const Text("SaffouryPaper LTD. Co."),
          subtitle: Text(Utils.version),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          //todo translate
          child: TextButton(onPressed: () {}, child: const Text("Help Center")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          //todo translate
          child: TextButton(onPressed: () {}, child: const Text("Contact Us")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          //todo translate
          child: TextButton(onPressed: () {}, child: const Text("Licenses")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
              //todo translate
              onPressed: () {},
              child: const Text("Terms and Privacy Policy")),
        ),
        const Divider(),
        const ListTile(
            subtitle:
                //todo translate
                Text("Copyright (c) 2023 SaffouryPaper. All rights Reserved")),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: kDefaultPadding),
          child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      WidgetStateProperty.all<Color>(Colors.orange)),
              onPressed: () {},
              child:
                  const Text("Development And Designed by Qussai Al-Saffoury")),
        ),
      ],
    );
  }
}
