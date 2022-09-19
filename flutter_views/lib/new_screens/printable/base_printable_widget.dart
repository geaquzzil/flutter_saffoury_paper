import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/new_screens/printable/base_printable_web_view.dart';

class BasePrintableWidget extends StatelessWidget {
  ViewAbstract printObject;
  BasePrintableWidget({Key? key, required this.printObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseEditPage(
        parent: printObject.getPrintCommand(context) as ViewAbstract,
        onSubmit: (obj) {
          debugPrint("BasePrintableWidget onSubmit=> $obj");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BasePrintableViewWidget(
                  printObject: printObject,
                  printCommand: obj as PrintCommandAbstract,
                ),
              ));
          // printObject.printCall();
          //     EasyWebView()
        });
  }
}
