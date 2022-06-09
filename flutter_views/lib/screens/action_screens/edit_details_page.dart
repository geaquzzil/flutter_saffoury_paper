import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/action_screens/base_actions_page.dart';

class EditDetailsPage<T extends ViewAbstract> extends BaseActionPage {
  EditDetailsPage({Key? key, required ViewAbstract object})
      : super(key: key, object: object);

  @override
  List<Widget>? getAppBarActionsView(BuildContext context) {
    // TODO: implement getAppBarActionsView
    return object.getAppBarActionsEdit(context);
  }

  @override
  Widget? getBodyActionView(BuildContext context) {
    // TODO: implement getBodyActionView
    return Center(child: object.getHeaderText(context));
  }

  @override
  Widget? getBottomNavigationBar(BuildContext context) {
    // TODO: implement getBottomNavigationBar
    throw UnimplementedError();
  }
}
