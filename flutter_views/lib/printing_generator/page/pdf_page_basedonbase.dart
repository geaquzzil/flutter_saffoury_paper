import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/size_config.dart';

class TestBasePage extends StatefulWidget {
  const TestBasePage({super.key});

  @override
  State<TestBasePage> createState() => _TestBasePageState();
}

class _TestBasePageState extends BasePageState<TestBasePage> {
  @override
  bool setPaddingWhenTowPane(CurrentScreenSize size) {
    debugPrint("setPaddingWhenTowPane $size");
    return false;
    return size == CurrentScreenSize.DESKTOP;
  }

  @override
  Widget? getDesktopFirstPane(double width) =>
      const Center(child: Text(" this is a  desktop body first pane"));
  @override
  Widget? getDesktopSecondPane(double width) =>
      const Center(child: Text(" this is a desktop body second pane"));
  @override
  Widget getFirstPane(double width) => Container(
        color: Colors.blueGrey,
        child: Text("First Pane $width"),
      );

  @override
  Widget? getBaseFloatingActionButton(CurrentScreenSize s) =>
      FloatingActionButton.extended(
          onPressed: () => {}, label: Icon(Icons.add));

  @override
  Widget? getSecoundPane(double width) => Container(
        color: Colors.grey,
        child: Text("Second Pane $width"),
      );

  @override
  Widget? getBaseAppbar(CurrentScreenSize currentScreenSize) => const ListTile(
        title: Text("BaseToolbar"),
        subtitle: Text("Subtitle Toolbar"),
      );

  @override
  Widget? getFirstPaneAppbar(CurrentScreenSize currentScreenSize) =>
      const ListTile(
        title: Text("first Pane toolbar"),
        subtitle: Text("Subtitle Toolbar"),
      );

  @override
  Widget? getFirstPaneFloatingActionButton(
          CurrentScreenSize currentScreenSize) =>
      null;

  @override
  Widget? getSecondPaneAppbar(CurrentScreenSize currentScreenSize) =>
      const ListTile(
        title: Text("secound pane toolbar"),
        subtitle: Text("Subtitle Toolbar"),
      );

  @override
  Widget? getSecondPaneFloatingActionButton(
          CurrentScreenSize currentScreenSize) =>
      null;

  @override
  bool isPanesIsSliver(bool firstPane) => true;
}
