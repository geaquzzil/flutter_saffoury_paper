import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_main.dart';

class BaseSharedDetailsViewCameraListener extends StatelessWidget {
  Widget child;
  BaseSharedDetailsViewCameraListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifierCameraMode,
      builder: (__, value, _) {
        if (!value) return child;
        return Column(
          children: [
            AnimatedContainer(
                height: value ? MediaQuery.of(context).size.height * .3 : 0,
                duration: const Duration(milliseconds: 200),
                child: Center(child: Text("This is a test"))),
            if (value)
              AnimatedContainer(
                  height: value
                      ? MediaQuery.of(context).size.height * .6
                      : MediaQuery.of(context).size.height -
                          MediaQuery.of(context).viewPadding.top,
                  duration: const Duration(milliseconds: 200),
                  child: Center(child: Text("This is a test")))
            else
              child
          ],
        );
      },
    );
  }
}
