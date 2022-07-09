import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class EditSubViewAbstractNullableButton extends StatefulWidget {
  ViewAbstract viewabstract;
  String field;
  EditSubViewAbstractNullableButton(
      {Key? key, required this.viewabstract, required this.field})
      : super(key: key);

  @override
  State<EditSubViewAbstractNullableButton> createState() =>
      _EditSubViewAbstractNullableButtonState();
}

class _EditSubViewAbstractNullableButtonState
    extends State<EditSubViewAbstractNullableButton>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> _color;
  late AnimationController controller;
  late bool isNullable;
  void animateColor(BuildContext context) {
    debugPrint("animating color");
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
    } else {
      controller.forward();
    }
    context
        .read<EditSubsViewAbstractControllerProvider>()
        .toggleIsNullable(widget.field);
  }

  @override
  void initState() {
    super.initState();
    isNullable = Provider.of<EditSubsViewAbstractControllerProvider>(context,
            listen: false)
        .getIsNullable(widget.field);
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _color = ColorTween(
            begin: isNullable ? Colors.orange : Colors.black,
            end: isNullable ? Colors.black : Colors.orange)
        .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (context, child) {
        return IconButton(
            onPressed: () => animateColor(context),
            icon: Icon(
              Icons.delete_rounded,
              color: _color.value,
            ));
      },
    );
  }
}
