import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/app_bar.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class BaseActionPage<T extends ViewAbstract> extends StatelessWidget {
  T object;
  BaseActionPage({Key? key, required this.object}) : super(key: key);

  Widget? getBottomNavigationBar(BuildContext context);
  Widget? getBodyActionView(BuildContext context);
  List<Widget>? getAppBarActionsView(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(
          title: getTitle(context),
          actions: getAppBarActionsView(context),
        ),
        extendBody: true,
        bottomNavigationBar: getBottomNavigationBar(context),
        body: getBodyActionView(context));
  }

  Row getTitle(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          child: RoundedIconButton(
            onTap: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back,
          ),
        ),
      ],
    );
  }

  List<String> getFields() {
    return object.getFields();
  }
}
