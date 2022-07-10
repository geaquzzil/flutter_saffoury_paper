import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/components/sub_edit_viewabstract_nullable_button.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class EditSubViewAbstractTrailingWidget extends StatefulWidget {
  ViewAbstract view_abstract;
  String field;
  EditSubViewAbstractTrailingWidget(
      {Key? key, required this.view_abstract, required this.field})
      : super(key: key);

  @override
  State<EditSubViewAbstractTrailingWidget> createState() =>
      _EditSubViewAbstractTrailingWidgetState();
}

class _EditSubViewAbstractTrailingWidgetState
    extends State<EditSubViewAbstractTrailingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _flag = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (context
                .watch<EditSubsViewAbstractControllerProvider>()
                .getIsNew(widget.field))
              Icon(Icons.edit, color: Colors.orange),
            // widget.view_abstract.getPopupMenuActionListWidget(context),
            if (widget.view_abstract
                    .canBeNullableFromParentCheck(context, widget.field) ??
                false)
              EditSubViewAbstractNullableButton(
                viewabstract: widget.view_abstract,
                field: widget.field,
              ),
            if (!context
                .watch<EditSubsViewAbstractControllerProvider>()
                .getIsNullable(widget.field))
              Icon(Icons.arrow_downward)
      
            // GestureDetector(
            //   onTap: () {
            //     if (_flag) {
            //       _animationController.forward();
            //     } else {
            //       _animationController.reverse();
            //     }
      
            //     _flag = !_flag;
            //   },
            //   child: AnimatedIcon(
            //     icon: AnimatedIcons.menu_arrow,
            //     progress: _animationController,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
