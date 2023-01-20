import 'package:flutter/material.dart';

class ApiButton<T> extends StatefulWidget {
  final String title;
  final Future<T?> futureBuilder;
  final IconData? icon;
  final ValueNotifier<T?>? onResult;
  final Function(T? onResult)? onResultFunction;
  const ApiButton(
      {super.key,
      required this.title,
      this.icon,
      required this.futureBuilder,
      this.onResult,
      this.onResultFunction});

  @override
  State<ApiButton<T>> createState() => _ApiButtonState<T>();
}

class _ApiButtonState<T> extends State<ApiButton<T>> {
  ValueNotifier<ConnectionState> connectionState =
      ValueNotifier<ConnectionState>(ConnectionState.none);

  late ValueNotifier<T?> onResult;
  @override
  void initState() {
    onResult = widget.onResult ?? ValueNotifier<T?>(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    Widget text = Text(widget.title);
    if (widget.icon != null) {
      child = ValueListenableBuilder<ConnectionState>(
        valueListenable: connectionState,
        builder: (context, value, child) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: value == ConnectionState.waiting
                ? ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(widget.icon),
                    label: const SizedBox(
                        width: 60, child: LinearProgressIndicator()),
                  )
                : ElevatedButton.icon(
                    onPressed: onButtonPressed,
                    icon: Icon(widget.icon),
                    label: text,
                  ),
          );
        },
      );
    } else {
      child = ValueListenableBuilder<ConnectionState>(
        valueListenable: connectionState,
        builder: (context, value, child) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: value == ConnectionState.waiting
                ? const ElevatedButton(
                    onPressed: null,
                    child: SizedBox(
                        width: double.infinity,
                        child: LinearProgressIndicator()),
                  )
                : ElevatedButton(
                    onPressed: onButtonPressed,
                    child: text,
                  ),
          );
        },
      );
    }
    return child;
  }

  Future<void> onButtonPressed() async {
    connectionState.value = ConnectionState.waiting;
    debugPrint("ApiButton onButtonPressed watining");
    // await Future.delayed(const Duration(seconds: 3));
    T? res = await widget.futureBuilder;
    debugPrint("ApiButton onButtonPressed done");
    connectionState.value = ConnectionState.done;
    onResult.value = res;
    if (widget.onResultFunction != null) {
      widget.onResultFunction!(res);
    }
  }
}
