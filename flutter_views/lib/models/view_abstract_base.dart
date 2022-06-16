import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reflectable/mirrors.dart';

import 'view_abstract_api.dart';

abstract class ViewAbstractBase<T> {
  String iD = "-1";
  List<String> getFields();
  String getFieldLabel(String label, BuildContext context);
  IconData getFieldIconData(String label);
  IconData getIconData();

  double getCartItemPrice() => 0;
  double getCartItemQuantity() => 0;

  Icon getFieldIcon(String label) {
    return Icon(getFieldIconData(label));
  }

  Icon getIcon() {
    return Icon(getIconData());
  }

  Text? getSubtitleHeaderText(BuildContext context) {
    return Text(
      getSubtitleHeaderTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getHeaderText(BuildContext context) {
    return Text(
      getHeaderTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getLabelText(BuildContext context) {
    return Text(
      getLabelTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Text? getLabelSubtitleText(BuildContext context) {
    return Text(
      getLabelSubtitleTextOnly(context),
      // style: const TextStyle(color: kTextLightColor)
    );
  }

  Color getColor(BuildContext context) => Colors.red;

  Widget? getCardTrailing(BuildContext context) {
    return const Icon(Icons.more_vert_outlined);
  }

  Widget getCardLeading(BuildContext context) {
    return Hero(
        tag: this,
        child: CircleAvatar(radius: 28, child: getCardLeadingImage(context)));
  }

  Widget getCardLeadingImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: getImageUrl(context)!,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(getIconData()),
    );
  }

  String? getImageUrl(BuildContext context) {
    return "https://";
  }

  String getSubtitleHeaderTextOnly(BuildContext context) {
    return "null";
  }

  String getHeaderTextOnly(BuildContext context) {
    return "null";
  }

  String getLabelSubtitleTextOnly(BuildContext context) {
    return "null";
  }

  String getLabelTextOnly(BuildContext context) {
    return "null";
  }

  List<Widget>? getAppBarActionsEdit(BuildContext context) => null;

  List<Widget>? getAppBarActionsView(BuildContext context) => null;

  InstanceMirror getInstanceMirror() {
    return reflector.reflect(this);
  }

  dynamic getFieldValue(String label) {
    try {
      return getInstanceMirror().invokeGetter(label);
    } catch (e) {
      return "$label ${e.toString()}";
    }
  }


}
