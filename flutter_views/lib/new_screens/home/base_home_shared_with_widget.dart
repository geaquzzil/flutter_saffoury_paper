import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';


abstract class BaseHomeSharedWithWidgets extends StatelessWidget {
  Widget? firstPane;
  bool wrapWithScaffold;
  BaseHomeSharedWithWidgets({super.key, this.wrapWithScaffold = false});

  Widget? getSilverAppBarTitle(BuildContext context);
  Widget? getSliverHeader(BuildContext context);

  EdgeInsets? hasBodyPadding(BuildContext context);
  EdgeInsets? hasMainBodyPadding(BuildContext context);
  List<Widget>? getSliverAppBarActions(BuildContext context);
  List<Widget> getSliverList(BuildContext context);

  Widget? getEndPane(BuildContext context);
  void init(BuildContext context);

  @override
  Widget build(BuildContext context) {
    init(context);
    firstPane = getFirstPane(context);
    EdgeInsets? mainBodyPadding = hasMainBodyPadding(context);
    if (mainBodyPadding != null) {
      return Padding(
        padding: mainBodyPadding,
        child: TowPaneExt(
          startPane: firstPane!,
          endPane: getEndPane(context),
        ),
      );
    }
    return TowPaneExt(
      startPane: wrapWithScaffold ? Scaffold(body: firstPane!) : firstPane!,
      endPane: getEndPane(context),
    );
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
      stretchModes: const [StretchMode.fadeTitle],
      centerTitle: true,
      // titlePadding: const EdgeInsets.only(bottom: 62),
      title: getSilverAppBarTitle(context),
    );
  }

  Widget wrapWithPadding(BuildContext context, Widget child) {
    if (hasBodyPadding(context) == null) return child;
    return SliverPadding(
      padding: hasBodyPadding(context)!,
      sliver: child,
    );
  }

  Widget getFirstPane(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (getSilverAppBarTitle(context) != null)
          SliverAppBar.large(
            elevation: 4,
            surfaceTintColor: Theme.of(context).colorScheme.surface,
            automaticallyImplyLeading: false,
            actions: getSliverAppBarActions(context),
            leading: const SizedBox(),
            flexibleSpace: getSilverAppBarBackground(context),
          ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        if (getSliverHeader(context) != null)
          wrapWithPadding(
              context, SliverToBoxAdapter(child: getSliverHeader(context))),
        ...getSliverList(context)
            .map((e) => wrapWithPadding(context, e))

      ],
    );
  }
}
