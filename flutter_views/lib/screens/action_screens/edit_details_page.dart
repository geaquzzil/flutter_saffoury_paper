import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/screens/action_screens/base_actions_page.dart';

class EditDetailsPage<T extends ViewAbstract> extends BaseActionPage {
  EditDetailsPage({Key? key, required ViewAbstract object})
      : super(key: key, object: object);

  @override
  List<Widget>? getAppBarActionsView(BuildContext context) {
    return object.getAppBarActionsEdit(context);
  }

  @override
  Widget? getBodyActionView(BuildContext context) {
    return BaseEditNewPage(
      viewAbstract: object,
    );
  }

  @override
  Widget? getBottomNavigationBar(BuildContext context) {
    // TODO: implement getBottomNavigationBar
    return null;
  }
}
