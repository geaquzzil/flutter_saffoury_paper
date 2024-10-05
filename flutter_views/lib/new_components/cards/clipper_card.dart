// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

// class SelectedClippedCard extends StatelessWidget{

// }

class ListTileSameSizeOnTitle extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  const ListTileSameSizeOnTitle({super.key, this.leading, this.title});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => ListTile(
              leading: SizedBox(
                width: constraints.maxWidth * .4,
                child: leading,
              ),
              dense: true,
              title: SizedBox(
                width: constraints.maxWidth * .6,
                child: title,
              ),
            ));
  }
}

class ListTileAdaptive extends ListTile {
  final bool isLargeScreen;
  const ListTileAdaptive({
    required this.isLargeScreen,
    super.key,
    super.leading,
    super.title,
    super.subtitle,
    super.trailing,
    super.isThreeLine = false,
    super.dense = true,
    super.visualDensity,
    super.shape,
    super.style,
    super.selectedColor,
    super.iconColor,
    super.textColor,
    super.titleTextStyle,
    super.subtitleTextStyle,
    super.leadingAndTrailingTextStyle,
    super.enabled = true,
    super.onTap,
    super.onLongPress,
    super.onFocusChange,
    super.mouseCursor,
    super.selected = false,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.focusNode,
    super.autofocus = false,
    super.tileColor,
    super.selectedTileColor,
    super.enableFeedback,
    super.horizontalTitleGap,
    super.minVerticalPadding,
    super.minLeadingWidth,
    super.minTileHeight,
    super.titleAlignment,
  }) : super(contentPadding: isLargeScreen ? EdgeInsets.zero : null);
  @override
  Widget build(BuildContext context) {
    if (isLargeScreen) {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: super.build(context),
      );
    }
    return super.build(context);
  }
}

class OnHoverCardWithListTile extends StatelessWidget {
  final bool isSelected;
  final Function()? onTap;
  final bool selectedIsClipped;
  final ListTile child;
  final _controller = WidgetStatesController();
  OnHoverCardWithListTile(
      {super.key,
      required this.child,
      required this.isSelected,
      this.onTap,
      this.selectedIsClipped = true});

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return selectedIsClipped
          ? ClippedCard(
              elevation: 0,
              color: Theme.of(context).colorScheme.primary,
              child: child)
          : Card(
              margin: EdgeInsets.zero,
              child: child,
            );
    }
    // return ValueListenableBuilder(
    //     valueListenable: _controller,
    //     builder: (context, states, _) {
    //       return Card(
    //         elevation: states.contains(WidgetState.hovered) ? 4 : 0,
    //         child: TextButton(
    //           statesController: _controller,
    //           onPressed: onTap,
    //           child: child,
    //         ),
    //       );
    //     });

// TextButton(
//           statesController: _statesController,
//           style: ButtonStyle(side: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.pressed)) {
//               return const BorderSide(color: Colors.black);
//             }
//             if (states.contains(WidgetState.hovered)) {
//               return const BorderSide(color: Colors.deepPurple);
//             }
//             return null;
//           }), backgroundColor: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.hovered)) {
//               return Colors.black12;
//             }
//             return Colors.transparent;
//           })),
//           onPressed: () {},
//           child: const Text("ABC"),
//         )
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: OnHoverWidget(
        builder: (isHover) {
          if (isHover) {
            return Card(
              margin: EdgeInsets.zero,
              child: child,
            );
          }
          return child;
        },
        scale: true,
        scaleDown: true,
      ),
    );
  }
}

class ClippedCard extends StatelessWidget {
  Widget child;
  Color color;
  Color? customCardColor;
  double elevation;
  bool wrapWithCardOrOutlineCard;
  BorderSideColor borderSide;
  ClippedCard(
      {super.key,
      required this.child,
      required this.color,
      this.customCardColor,
      this.wrapWithCardOrOutlineCard = true,
      this.borderSide = BorderSideColor.START,
      this.elevation = 2});

  @override
  Widget build(BuildContext context) {
    return wrapWithCardOrOutlineCard
        ? Card(
            margin: customCardColor != null
                ? const EdgeInsets.only(left: kDefaultPadding / 2)
                : null,
            shape: customCardColor != null
                ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  )
                : null,
            color: customCardColor,
            elevation: elevation,
            child: getCardChild(),
          )
        : OutlinedCard(fillColor: false, child: getCardChild());
  }

  ClipPath getCardChild() {
    return ClipPath(
      clipper: ShapeBorderClipper(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: AnimatedContainer(
        // duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border(
          top: borderSide == BorderSideColor.TOP
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
          bottom: borderSide == BorderSideColor.BOTTOM
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
          left: borderSide == BorderSideColor.START
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
          right: borderSide == BorderSideColor.END
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
        )),
        duration: const Duration(milliseconds: 275),
        child: child,
      ),
    );
  }
}

enum BorderSideColor { TOP, BOTTOM, START, END }
