// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

// class SelectedClippedCard extends StatelessWidget{

// }

class ListTileSameSizeOnTitle extends StatelessWidget {
  final Widget? leading;
  final IconData? icon;
  final Widget? title;
  const ListTileSameSizeOnTitle({
    super.key,
    this.leading,
    this.title,
    this.icon,
  });

  Widget? getLeading() {
    if (leading == null) return null;
    // leading !=
    //     FittedBox(
    //       clipBehavior: Clip.antiAlias,
    //       fit: BoxFit.contain,
    //       child: leading,
    //     );
    if (icon == null) {
      return leading;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon!),
        const SizedBox(width: kDefaultPadding),
        Expanded(child: leading!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (width, constrants) {
        return ListTile(
          leading: Container(
            constraints: const BoxConstraints(minWidth: 50, maxWidth: 150),
            child: getLeading(),
          ),
          title: Container(
            constraints: BoxConstraints(minWidth: constrants.maxWidth - 20),
            child: title,
          ),
        );
      },
    );
  }
}

class OnHoverCardWithListTile extends StatelessWidget {
  final bool isSelected;
  final Function()? onTap;
  final bool selectedIsClipped;
  final ListTile child;
  final _controller = WidgetStatesController();
  OnHoverCardWithListTile({
    super.key,
    required this.child,
    required this.isSelected,
    this.onTap,
    this.selectedIsClipped = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return selectedIsClipped
          ? ClippedCard(
              elevation: 0,
              color: Theme.of(context).colorScheme.primary,
              child: child,
            )
          : Card(margin: EdgeInsets.zero, child: child);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: OnHoverWidget(
        builder: (isHover) {
          if (isHover) {
            return Card(margin: EdgeInsets.zero, child: child);
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
  ClippedCard({
    super.key,
    required this.child,
    required this.color,
    this.customCardColor,
    this.wrapWithCardOrOutlineCard = true,
    this.borderSide = BorderSideColor.START,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    return wrapWithCardOrOutlineCard
        ? Card(
            margin: customCardColor != null
                ? const EdgeInsets.only(left: kDefaultPadding / 2)
                : null,
            shape: customCardColor != null
                ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )
                : null,
            color: customCardColor,
            elevation: elevation,
            child: getCardChild(),
          )
        : Cards(type: CardType.outline, child: (v) => getCardChild());
  }

  ClipPath getCardChild() {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
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
          ),
        ),
        duration: const Duration(milliseconds: 275),
        child: child,
      ),
    );
  }
}

enum BorderSideColor { TOP, BOTTOM, START, END }
