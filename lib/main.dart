import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_saffoury_paper/main.reflectable.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/server/server_data_api.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:flutter_view_controller/providers/server_data.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_selected_item_controler.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/providers/actions/list_provider.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:flutter_view_controller/screens/base_material_app.dart';
import 'package:provider/provider.dart';

// void main() {
//   initializeReflectable();
//   List<ViewAbstract> views = List<ViewAbstract>.from([Product(), Size()]);

//   BlocOverrides.runZoned(
//     () => runApp(BaseHomePage(
//       drawerItems: views,
//     )),
//   );
//   runApp(BaseHomePage(
//     drawerItems: views,
//   ));
//   //   MultiProvider(
//   //     providers: [
//   //       ChangeNotifierProvider(create: (_) => CartProvider()),
//   //       ChangeNotifierProvider(create: (_) => ViewAbstractProvider()),
//   //       ChangeNotifierProvider(create: (_) => ListProvider()),
//   //     ],
//   //     child:,
//   //   ),
//   // );
// }

// void main() {
//   BlocOverrides.runZoned(
//     () => runApp(const PostPage()),
//     blocObserver: AppBlocObserver(),
//   );
// }

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint("$transition");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint("$error");
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  initializeReflectable();

  // runApp(AnimatedListSample());

  // return;
  List<ViewAbstract> views =
      List<ViewAbstract>.from([Product(), Size(), ProductType(),Order(),Purchases(),ProductInput(),ProductOutput(),Transfers()]);
  try {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => DrawerMenuControllerProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider.initialize(views)),
      ChangeNotifierProvider(create: (_) => DrawerMenuSelectedItemController()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => LargeScreenPageProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => ErrorFieldsProvider()),
      ChangeNotifierProvider(create: (_) => FilterableProvider()),
      ChangeNotifierProvider(create: (_) => ServerDataProvider()),
      ChangeNotifierProvider(
          create: (_) => EditSubsViewAbstractControllerProvider()),
      ChangeNotifierProvider(create: (_) => ActionViewAbstractProvider()),
      ChangeNotifierProvider(
          create: (_) => DrawerViewAbstractProvider(object: Product())),
      ChangeNotifierProvider(create: (_) => ListProvider()),
      ChangeNotifierProvider(
        create: (_) => FilterableListApiProvider<FilterableDataApi>.initialize(FilterableDataApi()),
      )
    ], child: const BaseMaterialAppPage()

        //  App(),
        ));
  } catch (e) {
    debugPrint("exception => $e");
  }

  // BlocOverrides.runZoned(
  //   () => runApp(App()),
  //   blocObserver: SimpleBlocObserver(),
  // );
}

// class App extends MaterialApp {
//   App() : super(home: PostsPage());
// }

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) debugPrint("$change");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint("$transition");
  }
}

/// {@template counter_page}
/// A [StatelessWidget] that:
/// * provides a [CounterBloc] to the [CounterView].
/// {@endtemplate}
class CounterPage extends StatelessWidget {
  /// {@macro counter_page}
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const CounterView(),
    );
  }
}

/// {@template counter_view}
/// A [StatelessWidget] that:
/// * demonstrates how to consume and interact with a [CounterBloc].
/// {@endtemplate}
class CounterView extends StatelessWidget {
  /// {@macro counter_view}
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, count) {
            return Text('$count', style: Theme.of(context).textTheme.headline1);
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context.read<CounterBloc>().add(CounterIncrementPressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              context.read<CounterBloc>().add(CounterDecrementPressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}

/// Event being processed by [CounterBloc].
abstract class CounterEvent {}

/// Notifies bloc to increment state.
class CounterIncrementPressed extends CounterEvent {}

/// Notifies bloc to decrement state.
class CounterDecrementPressed extends CounterEvent {}

/// {@template counter_bloc}
/// A simple [Bloc] that manages an `int` as its state.
/// {@endtemplate}
class CounterBloc extends Bloc<CounterEvent, int> {
  /// {@macro counter_bloc}
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
    on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}

/// {@template brightness_cubit}
/// A simple [Cubit] that manages the [ThemeData] as its state.
/// {@endtemplate}
class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
