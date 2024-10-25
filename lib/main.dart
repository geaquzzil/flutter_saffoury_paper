import 'dart:convert';
import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_saffoury_paper/main.reflectable.dart';
import 'package:flutter_saffoury_paper/models/add_ons/add_ons_classes.dart';
import 'package:flutter_saffoury_paper/models/custom_views/excel_to_product_converter.dart';
import 'package:flutter_saffoury_paper/models/custom_views/print_product_label_custom_view.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/dashboards/customer_dashboard.dart';
import 'package:flutter_saffoury_paper/models/dashboards/dashboard.dart';
import 'package:flutter_saffoury_paper/models/dashboards/sales_analysis_dashboard.dart';
import 'package:flutter_saffoury_paper/models/funds/debits.dart';
import 'package:flutter_saffoury_paper/models/funds/incomes.dart';
import 'package:flutter_saffoury_paper/models/funds/spendings.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/notifications.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/server/server_data_api.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_list.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/base_material_app.dart';
import 'package:flutter_view_controller/new_screens/notification_controller.dart';
import 'package:flutter_view_controller/printing_generator/page/base_pdf_page.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/end_drawer_changed_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:flutter_view_controller/providers/server_data.dart';
import 'package:flutter_view_controller/providers/settings/language_provider.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/providers/therd_screen_provider.dart';
import 'package:flutter_view_controller/utils/util.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

import 'models/funds/credits.dart';
import 'models/products/products_types.dart';

String svgCode = '';

class ErrorLogger {
  void logError(FlutterErrorDetails details) async {
    //FlutterError.dumpErrorToConsole(details);
    _sendToServer(details.exceptionAsString(), details.stack.toString());
  }

  void log(Object data, StackTrace stackTrace) async {
    // print(data);
    // print(stackTrace);
    _sendToServer(data.toString(), stackTrace.toString());
  }

  void _sendToServer(String a, String b) async {
    debugPrint("error:\na:$a\nb:$b");
    // Implementation here
  }
}

ValueNotifier<QRCodeID?> onQrCodeChanged = ValueNotifier<QRCodeID?>(null);

void main() async {
  initializeReflectable();
  HttpOverrides.global = MyHttpOverrides();
  NotificationService().initNotification();
  // FlutterError.onError = (FlutterErrorDetails details) async {
  //   ErrorLogger().logError(details);
  // };
  // FlutterError.demangleStackTrace = (StackTrace stack) {
  //   if (stack is stack_trace.Trace) return stack.vmTrace;
  //   if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
  //   return stack;
  // };

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  NotificationService().initNotification();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  if (!kIsWeb) {
    if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // await DesktopWindow.setMinWindowSize(const Size(800, 600));
    }
  }
//   SerialPortReader reader = SerialPortReader(myPort,timeout:3000);
// Stream upcomingData = reader.stream;
// upcomingData.listen((data) {
//   print(String.fromCharCodes(data));
// });

  Utils.initVersionNumber();
  svgCode = await rootBundle.loadString("assets/images/vector/logoOnly.svg");
  //TODO what is this ?
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // statusBarIconBrightness: Brightness.dark,
    // statusBarBrightness:
    //     !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
    // systemNavigationBarColor: Colors.white,
    // systemNavigationBarDividerColor: Colors.transparent,
    // systemNavigationBarIconBrightness: Brightness.dark,
  ));
  //TODO notifications

  // return;
  List<ViewAbstract> views = List<ViewAbstract>.from([
    CustomerDashboard(),
    CustomerBalanceList(),
    Dashboard.init(-1,
        dateObject: DateObject(from: "2022-10-02", to: "2022-10-03")),
    SalesAnalysisDashboard(),
    PrintProductLabelCustomView(),
    ExcelToProductConverter(),
    Product(),
    ProductSize(),
    Order(),
    Purchases(),
    ProductInput(),
    ProductOutput(),
    Transfers(),
    CutRequest(),
    CustomerRequestSize(),
    CargoTransporter(),
    OrderRefund(),
    PurchasesRefund(),
    ReservationInvoice(),
    CustomsDeclaration(),
    Customer(),
    Employee(),
    Credits(),
    Debits(),
    Incomes(),
    Spendings(),
    ProductType(),
  ]);
  try {
    Product p = Product();
    p.status = ProductStatus.PENDING;
    p.barcode = "dfsdssds";
    p.gsms = GSM()..gsm = 100;
    // runApp(BaseEditFinal(
    //   viewAbstract: Product(),
    // ));
    // return;
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SVGData(svgCode)),
      ChangeNotifierProvider(create: (context) => PreviousColor('#7EB642')),
      ChangeNotifierProvider(create: (context) => TherdScreenProvider()),
      ChangeNotifierProvider(create: (context) => EndDrawerProvider()),
      ChangeNotifierProvider(create: (context) => ListScrollProvider()),
      ChangeNotifierProvider(
          create: (context) => PrintSettingLargeScreenProvider()),
      // ChangeNotifierProvider(
      //     create: (context) => DraggableHomeExpandProvider()),
      ChangeNotifierProvider(
          create: (context) =>
              DrawerMenuControllerProvider(initViewAbstract: p)),
      ChangeNotifierProvider(create: (context) => ListActionsProvider()),
      ChangeNotifierProvider(create: (context) => SettingProvider()),
      ChangeNotifierProvider(
          create: (context) => AuthProvider<AuthUser>.initialize(
                  notificationHandlerSimple: NotificationsClinet(),
                  Employee(),
                  views,
                  Purchases(),
                  [
                    CutWorkerRouteAddon(),
                    GoodsInventoryRouteAddon(),
                  ])),
      ChangeNotifierProvider(create: (_) => CartProvider.init(Order())),
      ChangeNotifierProvider(create: (_) => LargeScreenPageProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(
        create: (_) => MessageNotifierProvider(),
      ),
      ChangeNotifierProvider(
          create: (_) => ViewAbstractChangeProvider.init(Product())),
      ChangeNotifierProvider(create: (_) => FilterableProvider()),
      ChangeNotifierProvider(create: (_) => ServerDataProvider()),

      ChangeNotifierProvider(create: (_) => LangaugeProvider()),

      ChangeNotifierProvider(create: (_) => ActionViewAbstractProvider()),
      ChangeNotifierProvider(create: (_) => ListMultiKeyProvider()),
      ChangeNotifierProvider(
        create: (_) => FilterableListApiProvider<FilterableData>.initialize(
            FilterableDataApi()),
      )
    ], child: getWidget()));
  } catch (e) {
    debugPrint("exception => $e");
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  NotificationService service = NotificationService();
  late Sink<dynamic> myMessageSink;
  Map<String, String> joinMessagePayload = {
    "action": "join-room",
    "message": "I am Joining room",
    "roomId": "123456",
    "sender": "789"
  };

  @override
  void initState() {
    myMessageSink = context.read<MessageNotifierProvider>().notifyMessageSink;
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      context.read<MessageNotifierProvider>().notifyStream.listen((value) {
        debugPrint("sddsd $value");
        Map<String, dynamic> message = jsonDecode(value);
        context.read<MessageNotifierProvider>().addInbox(message);
        service.showNotification(
            title: "Chat-App Message", body: message['message']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Web Socket"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
                onPressed: () {
                  myMessageSink.add("dsasd");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ));
                },
                child: const Text("Join Room")),
          ],
        ),
      ),
    );
  }
}

Widget getWidget() {
  return MaterialApp(
    title: 'Flutter Websocket',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  );
  return const HomePage();
  // return Scaffold(
  //   body: (ListHorizontalApiAutoRestWidget(
  //       // valueNotifier: onHorizontalListItemClicked,
  //       titleString: "dsd",
  //       autoRest:
  //           AutoRest<Product>(range: 5, obj: Product(), key: "similarProduct"))),
  // );
  return BaseMaterialAppPage();
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Sink<dynamic> myMessageSink;
  late TextEditingController _messageController;
  @override
  void initState() {
    _messageController = TextEditingController();
    myMessageSink = context.read<MessageNotifierProvider>().notifyMessageSink;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Room"),
      ),
      body: Stack(
        children: [
          StreamBuilder<dynamic>(
              stream: context.read<MessageNotifierProvider>().notifyStream,
              builder: (context, snapshot) {
                var data =
                    snapshot.data == null ? null : jsonDecode(snapshot.data);
                return Text("$data");
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Card(
                      child: TextFormField(
                        controller: _messageController,
                        decoration:
                            const InputDecoration(hintText: "Send message"),
                      ),
                    )),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(60, 45)),
                        onPressed: () {
                          myMessageSink.add(jsonEncode({
                            "opcode": "broadcast",
                            "message": _messageController.text.trim(),
                            "roomId": "123456",
                            "sender": "789"
                          }));
                        },
                        child: const Text("send"))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MessageNotifierProvider with ChangeNotifier {
  final IOWebSocketChannel _channel = IOWebSocketChannel.connect(
      Uri.parse("ws://localhost:8081/websocket/server/server.php?iD=232"),
      headers: {"iD": "232"});
  late final BehaviorSubject<dynamic> _notifyStream = BehaviorSubject()
    ..addStream(_channel.stream);

  MessageNotifierProvider() : super() {
    _notifyStream.listen((value) {
      debugPrint("MessageNotifierProvider $value ");
    });
  }

  BehaviorSubject<dynamic> get notifyStream => _notifyStream;
  Sink<dynamic> get notifyMessageSink => _channel.sink;

  List<dynamic> inbox = [];

  void addInbox(dynamic message) {
    inbox.add(message);
    notifyListeners();
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
/* initialise the plugin. chat_icon needs to be a added as a 
       drawable resource to the Android head project */
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('chat_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('abc123', 'Chat-APP',
            importance: Importance.max, icon: 'chat_icon'),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}
