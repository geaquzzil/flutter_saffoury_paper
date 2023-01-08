import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:nil/nil.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../screens/base_shared_actions_header.dart';
import 'components/action_on_header_popup_widget.dart';

abstract class BaseActionScreenPage extends StatefulWidget {
  ViewAbstract viewAbstract;
  PaletteGenerator? color;
  BaseActionScreenPage({super.key, required this.viewAbstract, this.color});

  ServerActions getServerAction() {
    if (this is BaseEditNewPage) {
      return ServerActions.edit;
    } else if (this is BaseViewNewPage) {
      return ServerActions.view;
    } else {
      return ServerActions.list;
    }
  }
}

abstract class BaseActionScreenPageState<T extends BaseActionScreenPage>
    extends State<T> with TickerProviderStateMixin {
  Widget getBody(BuildContext context);
  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context);

  /// if null then we get the main viewabstract getBlurringImage
  Widget? getSliverImageBackground(BuildContext context);

  late TabController _tabController;
  final List<TabControllerHelper> _tabs = <TabControllerHelper>[];

  BaseActionProviders baseActionProviders = BaseActionProviders();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget tabController");
    _tabs.clear();
    _tabs.addAll(
        widget.viewAbstract.getTabs(context, action: widget.getServerAction()));
  }

  @override
  void initState() {
    super.initState();
  }

  bool hasNotApiToCall() {
    return widget.getServerAction() == ServerActions.list;
  }

  bool getBodyWithoutApi() {
    if (hasNotApiToCall()) return true;
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
            snap: true,
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
            elevation: 4,
            // title: widget.object.getMainHeaderText(context),
            // centerTitle: true,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: getSilverAppBarBackground(context),
            bottom: TabBar(
              labelColor: Theme.of(context).textTheme.titleLarge!.color,
              tabs: _tabs,
              isScrollable: true,
              controller: _tabController,
            )));
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
        stretchModes: const [StretchMode.fadeTitle],
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 62),
        title: Text(
          widget.viewAbstract.getBaseTitle(context,
              descriptionIsId: true, serverAction: widget.getServerAction()),
        ),
        background: widget.viewAbstract.getHeroTag(
            context: context,
            child: getSliverImageBackground(context) ??
                widget.viewAbstract
                    .getBlurringImage(context, addBottomWidget: false)));
  }

  Widget getBodyDetermineLayout() {
    _tabs.clear();
    _tabs.addAll(
        widget.viewAbstract.getTabs(context, action: widget.getServerAction()));
    _tabController = TabController(length: _tabs.length, vsync: this);
    // return TowPaneExt(startPane: startPane, endPane: endPane)
    return getNastedScrollView();
    if (SizeConfig.isDesktopOrWeb(context)) {
      return ListView(
        children: [
          BaseSharedHeaderViewDetailsActions(
            viewAbstract: widget.viewAbstract,
          ),
          getBody(context)
        ],
      );
    } else {
      _tabs.clear();
      _tabs.addAll(widget.viewAbstract
          .getTabs(context, action: widget.getServerAction()));
      _tabController = TabController(length: _tabs.length, vsync: this);
      // return TowPaneExt(startPane: startPane, endPane: endPane)
      return getNastedScrollView();
    }
  }

  NestedScrollView getNastedScrollView() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              getSilverAppBar(context, innerBoxIsScrolled),
            ],
        body: SafeArea(
          child: TabBarView(
              controller: _tabController,
              children: _tabs
                  .map((e) => Builder(builder: (BuildContext context) {
                        return CustomScrollView(
                            slivers: getTabWidget(context, e));
                      }))
                  .toList()),
        ));
  }

  List<Widget> getTabWidget(BuildContext context, TabControllerHelper e) {
    if (_tabs.indexOf(e) == 0) {
      return [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        ...getTopWidget(),
        getPadding(context, getBody(context)),
        ...getBottomWidget()
      ];
    }
    bool hasSlivers = e.slivers != null;
    return [
      SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
      if (!hasSlivers)
        getPadding(
            context,
            SliverFillRemaining(
                fillOverscroll: true, hasScrollBody: false, child: e.widget)),
      ...?e.slivers?.map((e) => getPadding(context, e)).toList()
    ];
  }

  SliverPadding getPadding(BuildContext context, Widget sliver) {
    return SliverPadding(
        padding: const EdgeInsets.only(
            top: kDefaultPadding / 2,
            right: kDefaultPadding / 2,
            bottom: 80,
            left: kDefaultPadding / 2),
        sliver: sliver);
  }

  List<Widget> getBottomWidget() {
    List<Widget>? bottomWidget = widget.viewAbstract
        .getCustomBottomWidget(context, widget.getServerAction());
    if (bottomWidget == null) return [];
    return bottomWidget.map((e) => SliverToBoxAdapter(child: e)).toList();
  }

  List<Widget> getTopWidget() {
    List<Widget>? topWidget = widget.viewAbstract
        .getCustomTopWidget(context, widget.getServerAction());
    if (topWidget == null) return [];
    return topWidget.map((e) => SliverToBoxAdapter(child: e)).toList();
  }

  Widget getFutureBody() {
    if (getBodyWithoutApi()) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        baseActionProviders.setIsLoaded = (true);
      });
      return getBodyDetermineLayout();
    }
    return FutureBuilder(
      future:
          widget.viewAbstract.viewCallGetFirstFromList(widget.viewAbstract.iD),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            widget.viewAbstract = snapshot.data as ViewAbstract;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              baseActionProviders.setIsLoaded = (true);
              context
                  .read<ListMultiKeyProvider>()
                  .edit(snapshot.data as ViewAbstract);
            });

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
        // backgroundColor: widget.color?.darkVibrantColor?.color,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: ChangeNotifierProvider.value(
            value: baseActionProviders,
            child: Consumer<BaseActionProviders>(
                builder: (context, provider, baseActionProviders) {
              return !provider.getIsLoaded
                  ? nil
                  : BaseFloatingActionButtons(
                      viewAbstract: widget.viewAbstract,
                      serverActions: widget.getServerAction(),
                      addOnList: getFloatingActionWidgetAddOns(context),
                    );
            })),

        // provider.getIsLoaded
        //     ? null
        //     : BaseFloatingActionButtons(
        //         viewAbstract: widget.viewAbstract,
        //         serverActions: widget.getServerAction(),
        //         addOnList: widget.getFloatingActionWidgetAddOns(context),
        //       ),
        body: getFutureBody());
  }
}

class BaseActionProviders with ChangeNotifier {
  bool _isLoaded = false;

  get getIsLoaded {
    return _isLoaded;
  }

  set setIsLoaded(bool isLoaded) {
    _isLoaded = isLoaded;
    notifyListeners();
  }
}
