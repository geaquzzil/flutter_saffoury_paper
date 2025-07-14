import 'package:flutter/material.dart';

class OverlayWidget extends StatefulWidget {
  Widget overlay;
  Widget child;
  OverlayWidget({super.key, required this.child, required this.overlay});

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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _showOverlay());
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
        child: InkWell(
            onTap: () {
              debugPrint("show overlay ${foucsNode.hasFocus}");
              if (entry == null) {
                _showOverlay();
              } else {
                hideOverlay();
              }
            },
            focusNode: foucsNode,
            child: widget.child));
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);

    entry = OverlayEntry(
      builder: (context) => buildOverlay(),
    );
    overlay.insert(entry!);
  }

  hideOverlay() {
    entry?.remove();
    entry = null;
  }

  buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.2,
      top: MediaQuery.of(context).size.height * 0.3,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Stack(
          children: [
            Image.asset(
              'images/commentCloud.png',
              colorBlendMode: BlendMode.multiply,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.13,
              left: MediaQuery.of(context).size.width * 0.13,
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      'This is a button!',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.green),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.18,
                  ),
                  GestureDetector(
                    onTap: () {
                      // When the icon is pressed the OverlayEntry
                      // is removed from Overlay
                      entry?.remove();
                    },
                    child: Icon(Icons.close,
                        color: Colors.green,
                        size: MediaQuery.of(context).size.height * 0.025),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Positioned(
      top: size.height + 8,
      width: MediaQuery.of(context).size.width / 2,
      child: widget.overlay,
    );
    return CompositedTransformFollower(
      showWhenUnlinked: false,
      offset: Offset(0, size.height + 8),
      link: layerLink,
      child: Positioned(
          right: 10,
          // height: MediaQuery.of(context).size.height / 2,
          // width: MediaQuery.of(context).size.width,
          child: widget.overlay),
    );
  }
}
