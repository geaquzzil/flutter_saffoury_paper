import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';

class TestBasePage extends StatefulWidget {
  const TestBasePage({super.key});

  @override
  State<TestBasePage> createState() => _TestBasePageState();
}

class _TestBasePageState extends BasePageState<TestBasePage> {
  @override
  bool setPaddingWhenTowPane() {
    return true;
  }

  @override
  Widget? getDesktopFirstPane(double width) {
    return Scaffold(
        backgroundColor: ElevationOverlay.overlayColor(context, 2),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            // toolbarHeight: 200,
            backgroundColor: ElevationOverlay.overlayColor(context, 2),
            forceMaterialTransparency: true,
            primary: true,
            title: ListTile(
              title: Text("Dinner Club"),
              subtitle: Text("3 Messages"),
            )),
        body: Center(child: Text(" this is a body")));
  }

  @override
  Widget? getDesktopSecondPane(double width) => Scaffold(
      backgroundColor: ElevationOverlay.overlayColor(context, 2),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          // toolbarHeight: 200,
          backgroundColor: ElevationOverlay.overlayColor(context, 2),
          forceMaterialTransparency: true,
          primary: true,
          title: ListTile(
            title: Text("Details Club"),
            subtitle: Text("3 Messages"),
          )),
      body: Center(child: Text(" this is a body")));

  @override
  Widget getFirstPane(double width) => Container(
        color: Colors.blueGrey,
        child: Text("First Pane $width"),
      );

  @override
  Widget? getFloatingActionButton() => null;

  @override
  Widget? getSecoundPane(double width) => Container(
        color: Colors.grey,
        child: Text("Second Pane $width"),
      );
}
