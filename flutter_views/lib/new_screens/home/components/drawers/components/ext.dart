import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

Widget buildColapsedIcon(
    BuildContext context, IconData data, VoidCallback? onPress) {
  return IconButton(
    // padding: EdgeInsets.all(4),
    onPressed: onPress,
    iconSize: 25,
    icon: Icon(data),
  );
  return OnHoverWidget(
      scale: false,
      builder: (onHover) {
        return IconButton(

            // padding: EdgeInsets.all(4),
            onPressed: onPress,
            iconSize: 25,
            icon: Icon(data),
            color: onHover
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary);
      });
}
