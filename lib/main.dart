import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_saffoury_paper/main.reflectable.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/tests.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/cart_provider.dart';
import 'package:flutter_view_controller/providers/list_provider.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:flutter_view_controller/screens/base_home_page.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_page.dart';
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
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  initializeReflectable();

  runApp(AnimatedListSample());

  return;
  List<ViewAbstract> views = List<ViewAbstract>.from([Product(), Size()]);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(
        create: (_) => ViewAbstractProvider(object: Product())),
    ChangeNotifierProvider(create: (_) => ListProvider()),
  ], child: BaseHomePage(drawerItems: views)

      //  App(),
      ));

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
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
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
