import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/app_bar.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class BaseActionPage<T extends ViewAbstract> extends StatelessWidget {
  T object;
  BaseActionPage({Key? key, required this.object}) : super(key: key);

  Widget? getBottomNavigationBar(BuildContext context);
  Widget? getBodyActionView(BuildContext context);
  List<Widget>? getAppBarActionsView(BuildContext context);

  Widget getBody(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
              title: Text(object.getHeaderTextOnly(context)),
              background: Hero(
                  tag: object, child: object.getCardLeadingImage(context))),
          actions: getAppBarActionsView(context)),
      const SliverToBoxAdapter(
        child: SizedBox(
          height: 20,
          child: Center(
            child: Text('Scroll to see the SliverAppBar in effect.'),
          ),
        ),
      ),
      // SliverList(
      //   delegate: SliverChildBuilderDelegate(
      //     (BuildContext context, int index) {
      //       return Container(
      //         color: index.isOdd ? Colors.white : Colors.black12,
      //         height: 100.0,
      //         child: Center(
      //           child: Text('$index', textScaleFactor: 5),
      //         ),
      //       );
      //     },
      //     childCount: 20,
      //   ),
      // ),
      getBodyActionView(context)!
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: getBottomNavigationBar(context),
        body: getBody(context));
  }

  Row getTitle(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          child: RoundedIconButton(
            onTap: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back,
          ),
        ),
      ],
    );
  }

  List<String> getFields() {
    return object.getFields();
  }
}
