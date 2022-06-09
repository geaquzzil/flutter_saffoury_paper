import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:reflectable/mirrors.dart';

import 'view_abstract_api.dart';

abstract class ViewAbstractBase<T> {
  List<String> getFields();
  String getFieldLabel(String label, BuildContext context);
  IconData getIconData(BuildContext context);
  IconData getIconDataField(String label, BuildContext context);

  Icon getFieldIcon(String label, BuildContext context) {
    return Icon(getIconDataField(label, context));
  }

  Icon getIcon(BuildContext context) {
    return Icon(getIconData(context));
  }

  String iD = "-1";

  Color getColor(BuildContext context) => Colors.red;

  Widget? getCardTrailing(BuildContext context) {
    return const Icon(Icons.more_vert_outlined);
  }

  Widget getCardLeading(BuildContext context) {
    return Hero(
        tag: this,
        child: CircleAvatar(
          radius: 28,
          backgroundImage: getCardLeadingImageProvider(context),
        ));
  }

  Widget getCardLeadingImage(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.green,
            image: DecorationImage(
                image: getCardLeadingImageProvider(
                    context)! // convert Image object to ImageProvider
                )));
  }

  ImageProvider? getCardLeadingImageProvider(BuildContext context) {
    return null;
  }

  Text? getSubtitleHeaderText(BuildContext context) {
    return Text(getSubtitleHeaderTextOnly(context),
        style: const TextStyle(color: kTextLightColor));
  }

  String getSubtitleHeaderTextOnly(BuildContext context) {
    return "null";
  }

  Text? getHeaderText(BuildContext context) {
    return Text(getHeaderTextOnly(context),
        style: const TextStyle(color: kTextLightColor));
  }

  String getHeaderTextOnly(BuildContext context) {
    return "null";
  }

  Text? getLabelText(BuildContext context) {
    return null;
  }

  String? getLabelTextOnly(BuildContext context) {
    return "null";
  }

  List<Widget>? getAppBarActionsEdit(BuildContext context) => null;

  List<Widget>? getAppBarActionsView(BuildContext context) => null;

  List<Widget>? getPopupActionsList(BuildContext context) => null;

  InstanceMirror getInstanceMirror() {
    return reflector.reflect(this);
  }

  dynamic? getFieldValue(String label) {
    return getInstanceMirror().invokeGetter(label);
  }

  void setFieldValue(String label, Object value) {
    // set the value
    getInstanceMirror().invokeSetter(label, value);
  }
}
