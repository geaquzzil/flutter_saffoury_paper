import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';

abstract class BasePdfPage extends StatefulWidget {
  String title;
  BasePdfPage({super.key, required this.title});
}

abstract class _BasePdfPageState extends State<BasePdfPage> {
  Widget getFloatingActions(BuildContext context);

  Widget getFutureBody(BuildContext context);

  // bool hasSetting

  @override
  Widget build(BuildContext context) {
    return TowPaneExt(
      startPane: getFirstPane(context),
      endPane: getEndPane(context),
    );
  }

  Widget? getEndPane(BuildContext context) {
    
  }

  Widget getFirstPane(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: getFloatingActions(context),
        body: getFirstPaneBody(context));
  }

  CustomScrollView getFirstPaneBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 4,
          pinned: true,
          primary: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget.title),
          ),
        ),
        SliverFillRemaining(
          child: Center(child: getFutureBody(context)),
        )
      ],
    );
  }
}
