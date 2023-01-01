import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrintIconWidget extends StatelessWidget {
  Function() onPressed;
  bool returnNillIfNull;
  PrintIconWidget(
      {super.key, required this.onPressed, this.returnNillIfNull = true});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
