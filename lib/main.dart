import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/main.reflectable.dart';
import 'package:flutter_saffoury_paper/models/dashboards/dashboard.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/server/server_data_api.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_list.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/base_material_app.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_stand_alone.dart';
import 'package:flutter_view_controller/providers/end_drawer_changed_provider.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/providers/therd_screen_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:flutter_view_controller/providers/server_data.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_selected_item_controler.dart';

import 'package:flutter_view_controller/providers/actions/list_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:provider/provider.dart';

import 'models/funds/credits.dart';
import 'models/products/products_types.dart';

void main() async {
  initializeReflectable();

  WidgetsFlutterBinding.ensureInitialized();
  //TODO what is this ?
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  List<ViewAbstract> views = List<ViewAbstract>.from([
    Product(),
    Size(),
    Order(),
    Purchases(),
    Customer(),
    Employee(),
    Credits(),
    ProductType(),
    CustomerBalanceList(),
    Dashboard()
  ]);
  try {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => TherdScreenProvider()),
      ChangeNotifierProvider(create: (context) => EndDrawerProvider()),
      ChangeNotifierProvider(
          create: (context) => DrawerMenuControllerProvider()),
      ChangeNotifierProvider(create: (context) => SettingProvider()),
      ChangeNotifierProvider(
          create: (context) => AuthProvider.initialize(views)),
      ChangeNotifierProvider(create: (_) => DrawerMenuSelectedItemController()),
      ChangeNotifierProvider(create: (_) => CartProvider.init(Order())),
      ChangeNotifierProvider(create: (_) => LargeScreenPageProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => ErrorFieldsProvider()),
      ChangeNotifierProvider(create: (_) => FilterableProvider()),
      ChangeNotifierProvider(create: (_) => ServerDataProvider()),
      ChangeNotifierProvider(create: (_) => IsHoveredOnDrawerClosed()),
      ChangeNotifierProvider(
          create: (_) => EditSubsViewAbstractControllerProvider()),
      ChangeNotifierProvider(create: (_) => ActionViewAbstractProvider()),
      ChangeNotifierProvider(
          create: (_) => DrawerViewAbstractListProvider(object: Product())),
      ChangeNotifierProvider(
          create: (_) =>
              DrawerViewAbstractStandAloneProvider(CustomerBalanceList())),
      ChangeNotifierProvider(create: (_) => ListProvider()),
      ChangeNotifierProvider(create: (_) => ListMultiKeyProvider()),
      ChangeNotifierProvider(
        create: (_) => FilterableListApiProvider<FilterableData>.initialize(
            FilterableDataApi()),
      )
    ], child: const BaseMaterialAppPage()));
  } catch (e) {
    debugPrint("exception => $e");
  }
}
