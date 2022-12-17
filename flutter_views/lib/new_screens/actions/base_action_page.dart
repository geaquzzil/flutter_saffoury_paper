import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/header_action_icon.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../models/menu_item.dart';
import '../../providers/actions/action_viewabstract_provider.dart';
import 'components/action_on_header_popup_widget.dart';

abstract class BaseActionScreenPage extends StatefulWidget {
  ViewAbstract viewAbstract;

  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context);

  BaseActionScreenPage({super.key, required this.viewAbstract});

  Widget getBody(BuildContext context);

  ServerActions getServerAction() {
    if (this is BaseEditNewPage) {
      return ServerActions.edit;
    } else {
      return ServerActions.view;
    }
  }

  @override
  State<BaseActionScreenPage> createState() => _BaseActionScreenPageState();
}

class _BaseActionScreenPageState extends State<BaseActionScreenPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> tabs = <Tab>[];
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabs.addAll([TabControllerHelper("TITLE")]);
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  bool getBodyWithoutApi() {
    bool canGetBody = widget.viewAbstract
            .isRequiredObjectsList()?[widget.getServerAction()] ==
        null;
    if (canGetBody) {
      debugPrint("BaseActionScreenPage getBodyWithoutApi skiped");
      return true;
    }
    bool res = widget.viewAbstract.isNew() ||
        widget.viewAbstract.isRequiredObjectsListChecker();
    debugPrint("BaseActionScreenPage getBodyWithoutApi result => $res");
    return res;
  }

  SliverOverlapAbsorber getSilverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
            floating: true,
            automaticallyImplyLeading: true,
            pinned: true,
            snap: false,
            expandedHeight: MediaQuery.of(context).size.height * .25,
            actions: [
              ActionsOnHeaderWidget(
                viewAbstract: widget.viewAbstract,
                serverActions: widget.getServerAction(),
              ),
              ActionsOnHeaderPopupWidget(
                viewAbstract: widget.viewAbstract,
                serverActions: widget.getServerAction(),
              ),
            ],
            elevation: 10,
            // title: widget.object.getMainHeaderText(context),
            // centerTitle: true,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: getSilverAppBarBackground(context),
            bottom: TabBar(
              labelColor: Theme.of(context).textTheme.titleLarge!.color,
              tabs: tabs,
              // indicator: DotIndicator(
              //   color: Theme.of(context).colorScheme.primary,
              //   distanceFromCenter: 16,
              //   radius: 3,
              //   paintingStyle: PaintingStyle.fill,
              // ),
              //   RectangularIndicator(
              // bottomLeftRadius: 100,
              // bottomRightRadius: 100,
              // topLeftRadius: 100,
              // topRightRadius: 100,
              // paintingStyle: PaintingStyle.stroke,

              isScrollable: true,
              controller: _tabController,
            )));
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 62),
        title: widget.viewAbstract.getMainHeaderText(context),
        background: widget.viewAbstract.getCardLeading(context));
  }

  Widget getBodyDetermineLayout() {
    if (SizeConfig.isDesktopOrWeb(context)) {
      return ListView(
        children: [
          BaseSharedHeaderViewDetailsActions(
            viewAbstract: widget.viewAbstract,
          ),
          widget.getBody(context)
        ],
      );
    } else {
      return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                getSilverAppBar(context, innerBoxIsScrolled),
              ],
          body: SafeArea(
            child: TabBarView(controller: _tabController, children: [
              Builder(builder: (BuildContext context) {
                return CustomScrollView(slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return widget.getBody(context);
                        },
                        childCount: 1,
                      ),
                    ),
                  )
                ]);
              })
            ]),
          ));
    }
  }

  Widget getFutureBody() {
    if (getBodyWithoutApi()) {
      return getBodyDetermineLayout();
    }
    return FutureBuilder(
      future:
          widget.viewAbstract.viewCallGetFirstFromList(widget.viewAbstract.iD),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            widget.viewAbstract = snapshot.data as ViewAbstract;
            context
                .read<ListMultiKeyProvider>()
                .edit(snapshot.data as ViewAbstract);
            return getBodyDetermineLayout();
          } else {
            return getEmptyWidget(context);
          }
        }
        return getLoadingWidget();
      },
    );
  }

  Center getLoadingWidget() => const Center(child: CircularProgressIndicator());

  EmptyWidget getEmptyWidget(BuildContext context) {
    return EmptyWidget(
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        title: AppLocalizations.of(context)!.cantConnect,
        subtitle: AppLocalizations.of(context)!.cantConnectRetry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: BaseFloatingActionButtons(
          viewAbstract: widget.viewAbstract,
          serverActions: widget.getServerAction(),
          addOnList: widget.getFloatingActionWidgetAddOns(context),
        ),
        body: SafeArea(child: getFutureBody()));
  }
}
