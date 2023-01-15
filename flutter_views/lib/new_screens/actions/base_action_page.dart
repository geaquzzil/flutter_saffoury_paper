import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/new_screens/base_api_call_screen.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_main.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:nil/nil.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../screens/base_shared_actions_header.dart';
import 'components/action_on_header_popup_widget.dart';
import 'view/view_view_abstract.dart';

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
    extends BaseApiCallPageState<T, ViewAbstract?>
    with TickerProviderStateMixin {
  ValueNotifier<PaletteGenerator?> valueNotifierColor =
      ValueNotifier<PaletteGenerator?>(null);
  String? imgUrl;
  Widget getBody(BuildContext context);
  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context);

  /// if null then we get the main viewabstract getBlurringImage
  Widget? getSliverImageBackground(BuildContext context);

  late TabController _tabController;
  final List<TabControllerHelper> _tabs = <TabControllerHelper>[];

  BaseActionProviders baseActionProviders = BaseActionProviders();
  ValueNotifier<ExpandType> expandType =
      ValueNotifier<ExpandType>(ExpandType.HALF_EXPANDED);
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget tabController");
    extras = widget.viewAbstract;
    iD = widget.viewAbstract.iD;
    tableName = widget.viewAbstract.getTableNameApi();
    _tabs.clear();
    _tabs.addAll(
        getExtras()!.getTabs(context, action: widget.getServerAction()));
  }

  @override
  void initState() {
    extras = widget.viewAbstract;
    iD = widget.viewAbstract.iD;
    tableName = widget.viewAbstract.getTableNameApi();
    super.initState();

    // _updatePaletter();
  }

  Future<void> _updatePaletter() async {
    imgUrl = getExtras()!.getImageUrl(context);
    valueNotifierColor.value = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(imgUrl!),
    );
  }

  bool hasNotApiToCall() {
    return widget.getServerAction() == ServerActions.list;
  }

  @override
  ServerActions getServerActions() {
    return widget.getServerAction();
  }

  @override
  Future<ViewAbstract?> getCallApiFunctionIfNull(BuildContext context) {
    if (getExtras() == null) {
      ViewAbstract newViewAbstract =
          context.read<AuthProvider>().getNewInstance(tableName!)!;
      return newViewAbstract.viewCallGetFirstFromList(iD!)
          as Future<ViewAbstract>;
    } else {
      return (getExtras())!.viewCallGetFirstFromList((getExtras()!).iD)
          as Future<ViewAbstract>;
    }
  }

  @override
  bool getBodyWithoutApi() {
    if (hasNotApiToCall()) return true;
    return super.getBodyWithoutApi();
  }

  SliverOverlapAbsorber getSilverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
            floating: true,
            stretch: true,
            stretchTriggerOffset: 150,
            automaticallyImplyLeading: true,
            pinned: true,
            snap: true,
            expandedHeight: MediaQuery.of(context).size.height * .25,
            actions: [
              ActionsOnHeaderWidget(
                viewAbstract: getExtras()!,
                serverActions: widget.getServerAction(),
              ),
              ActionsOnHeaderPopupWidget(
                viewAbstract: getExtras()!,
                serverActions: widget.getServerAction(),
              ),
            ],
            elevation: 4,
            // title: widget.object.getMainHeaderText(context),
            // centerTitle: true,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: getSilverAppBarBackground(context),
            bottom: null));
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
          StretchMode.fadeTitle
        ],
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 62),
        title: Text(
          widget.viewAbstract.getBaseTitle(context,
              descriptionIsId: true, serverAction: widget.getServerAction()),
        ),
        background: widget.viewAbstract.getHeroTag(
            context: context,
            child: getSliverImageBackground(context) ?? getAppBarBackground()));
  }

  Widget getAppBarBackground() {
    String? imgUrl = widget.viewAbstract.getImageUrl(context);
    return ValueListenableBuilder<PaletteGenerator?>(
      valueListenable: valueNotifierColor,
      builder: (__, color, ___) => Stack(
        alignment: AlignmentDirectional.bottomStart,
        fit: StackFit.loose,
        children: [
          Container(
              // width: 150,
              // height: 100,
              decoration: BoxDecoration(
            image: imgUrl == null
                ? null
                : DecorationImage(
                    image: CachedNetworkImageProvider(imgUrl!),
                    fit: BoxFit.contain),
            color: imgUrl == null ? null : color?.darkVibrantColor?.color,
            // borderRadius: const BorderRadius.all(Radius.circular(20))
          )),
          Container(
            // padding: const EdgeInsets.all(5.0),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              gradient: imgUrl == null
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withAlpha(0),
                        Colors.black12,
                        Colors.black87
                      ],
                    ),
              color: imgUrl == null
                  ? null
                  : color?.darkVibrantColor?.titleTextColor,
              // borderRadius: const BorderRadius.only(
              //     bottomLeft: Radius.circular(18),
              //     bottomRight: Radius.circular(18))
            ),
            // height: 50,
            padding: const EdgeInsets.all(kDefaultPadding * .3),
            // width: double.infinity,
          )
        ],
      ),
    );
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
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
            [getSilverAppBar(context, innerBoxIsScrolled), getTabbar(context)],
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

  SliverPadding getTabbar(BuildContext context) {
    return SliverPadding(
      padding:
          const EdgeInsets.only(top: kDefaultPadding, left: kDefaultPadding),
      sliver: SliverSafeArea(
        sliver: SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: SliverAppBarDelegatePreferedSize(
                child: ColoredTabBar(
              useCard: true,
              cornersIfCard: 80.0,
              // color: Theme.of(context).colorScheme.surfaceVariant,
              child: TabBar(
                // padding: EdgeInsets.all(kDefaultPadding),
                labelStyle: Theme.of(context).textTheme.titleSmall,
                indicatorColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.2),
                labelColor: Theme.of(context).colorScheme.primary,
                tabs: _tabs,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(.2),
                ),
                isScrollable: true,
                controller: _tabController,
              ),
            ))),
      ),
    );
  }

  List<Widget> getTabWidget(BuildContext context, TabControllerHelper e) {
    if (_tabs.indexOf(e) == 0) {
      return [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        ...getTopWidget(),
        // getTabbar(context),
        getBody(context),
        ...getBottomWidget(),
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        )
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
              fillOverscroll: true, hasScrollBody: false, child: e.widget),
        ),
      ...?e.slivers?.map((e) => getPadding(context, e)).toList()
    ];
  }

  SliverPadding getPadding(BuildContext context, Widget sliver,
      {double? bottom}) {
    return SliverPadding(
        padding: EdgeInsets.only(
            top: kDefaultPadding / 2,
            right: kDefaultPadding / 2,
            bottom: bottom ?? 0,
            left: kDefaultPadding / 2),
        sliver: sliver);
  }

  List<Widget> getBottomWidget() {
    List<Widget>? bottomWidget =
        getExtras()?.getCustomBottomWidget(context, widget.getServerAction());
    if (bottomWidget == null) return [];
    return bottomWidget.map((e) {
      if (bottomWidget.indexOf(e) == bottomWidget.length) {
        return getPadding(
            context,
            SliverToBoxAdapter(
              child: e,
            ),
            bottom: 80);
      }
      return SliverToBoxAdapter(child: e);
    }).toList();
  }

  List<Widget> getTopWidget() {
    List<Widget>? topWidget =
        getExtras()?.getCustomTopWidget(context, widget.getServerAction());
    if (topWidget == null) return [];
    return topWidget
        .map((e) => getPadding(context, SliverToBoxAdapter(child: e)))
        .toList();
  }

  // Widget getFutureBody() {
  //   if (getBodyWithoutApi()) {
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       baseActionProviders.setIsLoaded = (true);
  //     });
  //     return getBodyDetermineLayout();
  //   }
  //   return FutureBuilder(
  //     future:
  //         widget.viewAbstract.viewCallGetFirstFromList(widget.viewAbstract.iD),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.data != null) {
  //           widget.viewAbstract = snapshot.data as ViewAbstract;

  //           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //             baseActionProviders.setIsLoaded = (true);
  //             context
  //                 .read<ListMultiKeyProvider>()
  //                 .edit(snapshot.data as ViewAbstract);
  //           });

  //           return getBodyDetermineLayout();
  //         } else {
  //           return getEmptyWidget(context);
  //         }
  //       }
  //       return getLoadingWidget();
  //     },
  //   );
  // }

  Center getLoadingWidget() => const Center(child: CircularProgressIndicator());

  EmptyWidget getEmptyWidget(BuildContext context) {
    return EmptyWidget(
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        title: AppLocalizations.of(context)!.cantConnect,
        subtitle: AppLocalizations.of(context)!.cantConnectRetry);
  }

  @override
  Widget buildAfterCall(BuildContext context, ViewAbstract? newObject) {
    _tabs.clear();
    _tabs.addAll(newObject!.getTabs(context, action: getServerActions()));
    _tabController = TabController(length: _tabs.length, vsync: this);
    return getDraggableHomeBody();
  }

  DraggableHome getDraggableHomeBody() {
    List<TabControllerHelper> tabs =
        getExtras()!.getTabs(context, action: getServerActions());
    tabs[0].slivers = [
      ...getTopWidget(),
      // getTabbar(context),
      getBody(context),
      ...getBottomWidget(),
      const SliverToBoxAdapter(
        child: SizedBox(height: 80),
      )
    ];
    return DraggableHome(
        valueNotifierExpandType: expandType,
        // bottomNavigationBarHeight: 80,
        bottomNavigationBar: getExtras() is CartableProductItemInterface
            ? BottomAppBar(
                color: Theme.of(context).colorScheme.surface,
                elevation: 2,
                shape: AutomaticNotchedShape(RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                )),
                child: BottomWidgetOnViewIfCartable(
                    viewAbstract: getExtras() as CartableProductItemInterface))
            : null,
        // headerBottomBar: Text("sdd"),
        headerExpandedHeight: .3,
        stretchMaxHeight: .31,
        scrollController: ScrollController(),
        fullyStretchable: false,
        headerWidget: widget.viewAbstract.getHeroTag(
            context: context,
            child: getSliverImageBackground(context) ?? getAppBarBackground()),
        slivers: [],
        tabs: tabs,
        alwaysShowLeadingAndAction: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: BaseFloatingActionButtons(
          viewAbstract: widget.viewAbstract,
          serverActions: widget.getServerAction(),
          addOnList: getFloatingActionWidgetAddOns(context),
        ));
  }

  Scaffold getBuildBody() {
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
        body: getBodyDetermineLayout());
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
