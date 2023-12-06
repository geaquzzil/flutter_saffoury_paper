import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';

class TestBasePage extends StatefulWidget {
  const TestBasePage({super.key});

  @override
  State<TestBasePage> createState() => _TestBasePageState();
}

class _TestBasePageState extends BasePageState<TestBasePage> {
  @override
  Widget? getDesktopFirstPane(double width) => Container(
        color: Colors.brown,
        child: Text("Desktop first Pane $width"),
      );

  @override
  Widget? getDesktopSecondPane(double width) => null;

  // Container(
  //       color: Colors.greenAccent,
  //       child: Text("Desktop secound Pane $width"),
  //     );

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
