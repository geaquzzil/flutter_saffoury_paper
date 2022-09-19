import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';

class BasePrintableWidget extends StatelessWidget {
  var printURL = "https://www.saffoury.com/print/index.php";
  ViewAbstract printObject;
  BasePrintableWidget({Key? key, required this.printObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseEditPage(
        parent: printObject.getPrintCommand(context) as ViewAbstract,
        onSubmit: (obj) {
          // printObject.printCall();
          //     EasyWebView()
        });
  }
}
