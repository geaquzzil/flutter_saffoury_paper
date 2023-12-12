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
  bool setPaddingWhenTowPane(CurrentScreenSize size) => false;

  @override
  getDesktopFirstPane(double width) {
    if (isPanesIsSliver(true)) {
      return [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  color: index % 2 == 0 ? Colors.green : Colors.greenAccent,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    "Item $index",
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              );
            },
            // 40 list items
            childCount: 40,
          ),
        )
      ];
    }
    return const Center(child: Text(" this is a  desktop body first pane"));
  }

  @override
  getDesktopSecondPane(double width) {
    return const Center(child: Text(" this is a desktop body second pane"));
  }

  @override
  getFirstPane(double width) => getDesktopFirstPane(width);
  @override
  getSecoundPane(double width) => Container(
        color: Colors.grey,
        child: Text("Second Pane $width"),
      );

  @override
  Widget? getBaseFloatingActionButton(CurrentScreenSize s) =>
      FloatingActionButton.extended(
          onPressed: () => {}, label: Icon(Icons.add));

  @override
  Widget? getBaseAppbar(CurrentScreenSize currentScreenSize) => null;

  //  ListTile(
  //       title: Text("BaseToolbar",
  //           style: Theme.of(context).textTheme.headlineLarge),
  //       subtitle: Text("Subtitle Toolbar"),
  //     );

  @override
  Widget? getFirstPaneAppbar(CurrentScreenSize currentScreenSize) => ListTile(
        title: Text("first pane tool bar",
            style: Theme.of(context).textTheme.headlineLarge),
        subtitle: Text("Subtitle Toolbar"),
      );

  @override
  Widget? getFirstPaneFloatingActionButton(
          CurrentScreenSize currentScreenSize) =>
      null;

  @override
  Widget? getSecondPaneAppbar(CurrentScreenSize currentScreenSize) => null;

  @override
  Widget? getSecondPaneFloatingActionButton(
          CurrentScreenSize currentScreenSize) =>
      null;

  @override
  bool isPanesIsSliver(bool firstPane) {
    // if (firstPane) {
    //   return true;
    // }
    return false;
  }

  @override
  Widget? getBaseBottomSheet() => null;

  @override
  Widget? getFirstPaneBottomSheet() => null;

  @override
  Widget? getSecondPaneBottomSheet() => null;

  @override
  bool setBodyPadding(bool firstPane) => false;
}
