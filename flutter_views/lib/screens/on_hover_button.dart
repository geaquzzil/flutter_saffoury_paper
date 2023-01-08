import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:sprung/sprung.dart';

class OnHoverWidget extends StatefulWidget {
  bool scale;
  Widget Function(bool isHovered) builder;

  OnHoverWidget({Key? key, required this.builder, this.scale = true})
      : super(key: key);

  @override
  State<OnHoverWidget> createState() => _OnHoverWidgetState();
}

class _OnHoverWidgetState extends State<OnHoverWidget> {
  bool isHover = false;
  void onEntered(bool isHover) {
    setState(() {
      this.isHover = isHover;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()
      ..translate(-4.0, -8.0, 0.0)
      ..scale(1.2);
    final transform = isHover ? hoveredTransform : Matrix4.identity();
    GlobalKey key = GlobalKey();
    return MouseRegion(
      key: key,
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onHover: (event) {
        // showPopupMenu(context, key, alignment: Alignment.centerRight, list: [
        //   PopupMenuItem(
        //       enabled: false,
        //       child: Container(
        //         color: Colors.orange,
        //         // width: 30,
        //         child: Center(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     GestureDetector(
        //                         onTap: () {
        //                           //    widget.onPressed("π");
        //                           Navigator.pop(context);
        //                         },
        //                         child: Text("π",
        //                             style:
        //                                 Theme.of(context).textTheme.headline3)),
        //                     GestureDetector(
        //                         onTap: () {
        //                           //   widget.onPressed("ln(");
        //                           Navigator.pop(context);
        //                         },
        //                         child: Text("ln",
        //                             style:
        //                                 Theme.of(context).textTheme.headline3)),
        //                     GestureDetector(
        //                         onTap: () {
        //                           //    widget.onPressed("θ");
        //                           Navigator.pop(context);
        //                         },
        //                         child: Text("θ",
        //                             style:
        //                                 Theme.of(context).textTheme.headline3))
        //                   ]),
        //               Padding(
        //                 padding: EdgeInsets.only(top: 10),
        //                 child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       GestureDetector(
        //                           onTap: () {
        //                             // widget.onPressed("e");
        //                             Navigator.pop(context);
        //                           },
        //                           child: Text("e",
        //                               style: Theme.of(context)
        //                                   .textTheme
        //                                   .headline3)),
        //                       GestureDetector(
        //                           onTap: () {
        //                             // widget.onPressed(" ∞");
        //                             Navigator.pop(context);
        //                           },
        //                           child: Text(" ∞",
        //                               style: Theme.of(context)
        //                                   .textTheme
        //                                   .headline3)),
        //                       Text("")
        //                     ]),
        //               ),
        //             ],
        //           ),
        //         ),
        //       )),
        //   PopupMenuItem<MenuItemBuild>(
        //       child: ListTile(
        //     title: Text("test"),
        //     leading: Icon(Icons.add),
        //   )),
        //   PopupMenuDivider(),
        //   PopupMenuItem<MenuItemBuild>(
        //       child: ListTile(
        //     title: Text("t"),
        //     leading: Icon(Icons.edit),
        //   ))
        // ]);
        // setState(() {
        //   selectedIndex = index;
        // });
      },
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        curve: Sprung.overDamped,
        duration: const Duration(milliseconds: 200),
        transform: widget.scale ? transform : null,
        child: widget.builder(isHover),
      ),
    );
  }
}
