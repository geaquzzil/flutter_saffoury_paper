import 'package:flutter/material.dart';

class OverlayWidget extends StatefulWidget {
  Widget overlay;
  Widget child;
  OverlayWidget({Key? key, required this.child, required this.overlay})
      : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  final foucsNode = FocusNode();
  final layerLink = LayerLink();
  OverlayEntry? entry;
  @override
  void dispose() {
    entry?.dispose();
    foucsNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _showOverlay());
    foucsNode.addListener(() {
      if (foucsNode.hasFocus) {
        _showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: layerLink,
        child: InkWell(focusNode: foucsNode, child: widget.child));
  }

  void _showOverlay() {
    final overlay = Overlay.of(context)!;

    entry = OverlayEntry(builder: (context) => buildOverlay());
    overlay.insert(entry!);
  }

  hideOverlay() {
    entry?.remove();
    entry = null;
  }

  buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return CompositedTransformFollower(
      showWhenUnlinked: false,
      offset: Offset(0, size.height + 8),
      link: layerLink,
      child: Positioned(
        width: MediaQuery.of(context).size.width * .4,
        child: Material(
          elevation: 8,
          child: widget.overlay,
        ),
      ),
    );
  }
}
