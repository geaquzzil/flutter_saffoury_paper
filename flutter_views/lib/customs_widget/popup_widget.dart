import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';

enum PressType {
  longPress,
  singleClick,
}

enum PreferredPosition {
  top,
  bottom,
}

class CustomPopupMenuController extends ChangeNotifier {
  bool menuIsShowing = false;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}

Rect _menuRect = Rect.zero;

class PopupWidget extends StatefulWidget {
  const PopupWidget({
    super.key,
    required this.child,
    required this.menuBuilder,
    this.pressType = PressType.singleClick,
    this.controller,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
    this.position,
    this.menuOnChange,
    this.enablePassEvent = true,
  });

  final Widget child;
  final PressType pressType;
  final double horizontalMargin;
  final double verticalMargin;
  final CustomPopupMenuController? controller;
  final Widget Function() menuBuilder;
  final PreferredPosition? position;
  final void Function(bool)? menuOnChange;

  /// Pass tap event to the widgets below the mask.
  /// It only works when [barrierColor] is transparent.
  final bool enablePassEvent;

  @override
  State<PopupWidget> createState() => _PopupWidget();
}

class _PopupWidget extends State<PopupWidget> {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  CustomPopupMenuController? _controller;
  bool _canResponse = true;

  _showMenu() {
    GlobalKey key = GlobalKey();
    _overlayEntry = OverlayEntry(builder: (context) {
      Widget menu = Container(
        color: Colors.black12,
        child: Positioned(
          top: 60.0,
          left: 60,
          child: OutlinedCard(
            key: key,
            child: Container(
              color: Colors.black12,
              constraints: BoxConstraints(
                minHeight: 10,
                minWidth: 10,
                maxWidth: MediaQuery.of(context).size.width / 2,
                maxHeight: MediaQuery.of(context).size.height * .75,
              ),
              child: Material(
                color: Colors.transparent,
                child: widget.menuBuilder.call(),
              ),
            ),
          ),
        ),
      );

      return Listener(
          behavior: widget.enablePassEvent
              ? HitTestBehavior.translucent
              : HitTestBehavior.opaque,
          onPointerDown: (PointerDownEvent event) {
            Offset offset = event.localPosition;
            debugPrint("OnPointerDown $offset");
            // If tap position in menu

            if (getRect(key).contains(
                Offset(offset.dx - widget.horizontalMargin, offset.dy))) {
              return;
            }
            _controller?.hideMenu();
            // When [enablePassEvent] works and we tap the [child] to [hideMenu],
            // but the passed event would trigger [showMenu] again.
            // So, we use time threshold to solve this bug.
            _canResponse = false;
            Future.delayed(Duration(milliseconds: 300))
                .then((_) => _canResponse = true);
          },
          child: Container(
            color: Colors.black38,
            child: Align(
                alignment: Alignment.topLeft,
                child: Padding(padding: EdgeInsets.all(60), child: menu)),
          ));
    });

    //   Widget menu = Center(
    //     child: Container(
    //       constraints: BoxConstraints(
    //         // maxHeight: MediaQuery.of(context).size.height / 2,
    //         // minHeight: 10,
    //         maxWidth: _parentBox!.size.width - 2 * widget.horizontalMargin,
    //         minWidth: 0,
    //       ),
    //       child: CustomMultiChildLayout(
    //         delegate: _MenuLayoutDelegate(
    //           screenSize: MediaQuery.of(context).size,
    //           anchorSize: _childBox!.size,
    //           anchorOffset: _childBox!.localToGlobal(
    //             Offset(-widget.horizontalMargin, 0),
    //           ),
    //           verticalMargin: widget.verticalMargin,
    //           position: widget.position,
    //         ),
    //         children: <Widget>[
    //           LayoutId(
    //             id: _MenuLayoutId.content,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: <Widget>[
    //                 Material(
    //                   color: Colors.transparent,
    //                   child: widget.menuBuilder(),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    //   return Listener(
    //       behavior: widget.enablePassEvent
    //           ? HitTestBehavior.translucent
    //           : HitTestBehavior.opaque,
    //       onPointerDown: (PointerDownEvent event) {
    //         Offset offset = event.localPosition;
    //         // If tap position in menu
    //         if (_menuRect.contains(
    //             Offset(offset.dx - widget.horizontalMargin, offset.dy))) {
    //           return;
    //         }
    //         _controller?.hideMenu();
    //         // When [enablePassEvent] works and we tap the [child] to [hideMenu],
    //         // but the passed event would trigger [showMenu] again.
    //         // So, we use time threshold to solve this bug.
    //         _canResponse = false;
    //         Future.delayed(Duration(milliseconds: 300))
    //             .then((_) => _canResponse = true);
    //       },
    //       child: menu);
    // },
    // );
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  _updateView() {
    bool menuIsShowing = _controller?.menuIsShowing ?? false;
    widget.menuOnChange?.call(menuIsShowing);
    if (menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller ??= CustomPopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
        _parentBox =
            Overlay.of(context)?.context.findRenderObject() as RenderBox?;
      }
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: widget.child,
        onTap: () {
          if (widget.pressType == PressType.singleClick && _canResponse) {
            _controller?.showMenu();
          }
        },
        onLongPress: () {
          if (widget.pressType == PressType.longPress && _canResponse) {
            _controller?.showMenu();
          }
        },
      ),
    );
    if (Platform.isIOS) {
      return child;
    } else {
      return WillPopScope(
        onWillPop: () {
          _hideMenu();
          return Future.value(true);
        },
        child: child,
      );
    }
  }
}

enum _MenuLayoutId {
  arrow,
  downArrow,
  content,
}

enum _MenuPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  topLeft,
  topCenter,
  topRight,
}

class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
    required this.screenSize,
    this.position,
  });
  final Size screenSize;
  final Size anchorSize;
  final Offset anchorOffset;
  final double verticalMargin;
  final PreferredPosition? position;

  @override
  void performLayout(Size size) {
    Size contentSize = Size.zero;
    Size arrowSize = Size.zero;
    Offset contentOffset = Offset(0, 0);
    Offset arrowOffset = Offset(0, 0);

    double anchorCenterX = anchorOffset.dx + anchorSize.width / 2;
    double anchorTopY = anchorOffset.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;
    _MenuPosition menuPosition = _MenuPosition.topLeft;

    // bool isTop = false;
    // if (position == null) {
    //   // auto calculate position
    //   isTop = anchorBottomY > size.height / 2;
    // } else {
    //   isTop = position == PreferredPosition.top;
    // }
    // if (anchorCenterX - contentSize.width / 2 < 0) {
    //   menuPosition = isTop ? _MenuPosition.topLeft : _MenuPosition.bottomLeft;
    // } else if (anchorCenterX + contentSize.width / 2 > size.width) {
    //   menuPosition = isTop ? _MenuPosition.topRight : _MenuPosition.bottomRight;
    // } else {
    //   menuPosition =
    //       isTop ? _MenuPosition.topCenter : _MenuPosition.bottomCenter;
    // }
    menuPosition = _MenuPosition.topLeft;
    switch (menuPosition) {
      case _MenuPosition.bottomCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomLeft:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          0,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomRight:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.topCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _MenuPosition.topLeft:
        arrowOffset = Offset(0, 0);
        contentOffset = Offset(
          200,
          200,
        );
        break;
      case _MenuPosition.topRight:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
    }
    if (hasChild(_MenuLayoutId.content)) {
      positionChild(_MenuLayoutId.content, contentOffset);
    }

    _menuRect = Rect.fromLTWH(
      contentOffset.dx,
      contentOffset.dy,
      screenSize.width / 2,
      screenSize.height / 2,
    );
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
