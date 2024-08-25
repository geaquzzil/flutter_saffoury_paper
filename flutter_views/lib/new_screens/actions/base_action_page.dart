import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';
import 'package:flutter_view_controller/new_components/listable_draggable_header.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_editable.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/new_screens/base_api_call_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';
import '../../screens/base_shared_actions_header.dart';
import 'components/action_on_header_popup_widget.dart';
import 'view/view_view_abstract.dart';

abstract class BaseActionScreenPage extends StatefulWidget {
  ValueNotifier<ActionOnToolbarItem?>? actionOnToolbarItem;
  ViewAbstract viewAbstract;
  PaletteGenerator? color;
  CurrentScreenSize? currentScreenSize;

  BaseActionScreenPage(
      {super.key,
      required this.viewAbstract,
      this.color,
      this.actionOnToolbarItem,
      this.currentScreenSize});

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

  bool getBodyIsSliver();

  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context);

  /// if null then we get the main viewabstract getBlurringImage
  Widget? getSliverImageBackground(BuildContext context);

  late TabController _tabController;
  final List<TabControllerHelper> _tabs = <TabControllerHelper>[];

  BaseActionProviders baseActionProviders = BaseActionProviders();
  ValueNotifier<ExpandType> expandType =
      ValueNotifier<ExpandType>(ExpandType.HALF_EXPANDED);

  ValueNotifier<ViewAbstract?> onEditListableItem =
      ValueNotifier<ViewAbstract?>(null);
  ValueNotifier<List<ViewAbstract>?> onListableSelectedItem =
      ValueNotifier<List<ViewAbstract>?>(null);

  ValueNotifier<ApiCallState> apiCallState =
      ValueNotifier<ApiCallState>(ApiCallState.NONE);

  ValueNotifier<QrCodeNotifierState> valueNotifierQrState =
      ValueNotifier<QrCodeNotifierState>(
          QrCodeNotifierState(state: QrCodeCurrentState.NONE));

  GlobalKey<DraggableHomeState> draggableHomeState =
      GlobalKey<DraggableHomeState>();

  final Map<int, GlobalKey<ListCardItemEditableState>>
      _listCardItemEditableState = {};

  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget tabController");
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          if (mounted) {
            setState(() {
              extras = widget.viewAbstract;
              iD = widget.viewAbstract.iD;
              tableName = widget.viewAbstract.getTableNameApi();
              _tabs.clear();
              _tabs.addAll(getExtras()
                  .getTabs(context, action: widget.getServerAction()));
              _listCardItemEditableState.clear();
              _tabController.animateTo(0);
            });
          }
        },
      );
    }
  }

  GlobalKey<ListCardItemEditableState> getListCardItemEditableKey(
      ViewAbstract view) {
    if (_listCardItemEditableState.containsKey(view.iD)) {
      return _listCardItemEditableState[view.iD]!;
    } else {
      _listCardItemEditableState[view.iD] =
          GlobalKey<ListCardItemEditableState>();
      return _listCardItemEditableState[view.iD]!;
    }
  }

  @override
  void initState() {
    extras = widget.viewAbstract;
    iD = widget.viewAbstract.iD;
    tableName = widget.viewAbstract.getTableNameApi();
    _listCardItemEditableState.clear();
    super.initState();

    // _updatePaletter();
  }

  Future<void> _updatePaletter() async {
    imgUrl = getExtras().getImageUrl(context);
    valueNotifierColor.value = await PaletteGenerator.fromImageProvider(
      FastCachedImageProvider(imgUrl!),
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
          context.read<AuthProvider<AuthUser>>().getNewInstance(tableName!)!;
      return newViewAbstract.viewCallGetFirstFromList(iD!)
          as Future<ViewAbstract?>;
    } else {
      return (getExtras()).viewCallGetFirstFromList((getExtras()).iD)
          as Future<ViewAbstract?>;
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
            pinned: false,
            snap: false,
            expandedHeight: MediaQuery.of(context).size.height * .25,
            actions: [
              ActionsOnHeaderWidget(
                viewAbstract: getExtras(),
                serverActions: widget.getServerAction(),
              ),
              ActionsOnHeaderPopupWidget(
                viewAbstract: getExtras(),
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
                    image: FastCachedImageProvider(imgUrl),
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
    if (SizeConfig.isDesktopOrWebPlatform(context)) {
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
        if (extras is ListableInterface)
          const ListTile(
            leading: Icon(Icons.list),
            title: Text("Details"),
          ),
        if (extras is ListableInterface)
          ListStaticWidget<ViewAbstract>(
              list: extras!.getListableInterface().getListableList(),
              emptyWidget: const Text("null"),
              listItembuilder: (item) => ListCardItemWeb(
                    object: item,
                  )),
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
              fillOverscroll: false, hasScrollBody: false, child: e.widget),
        ),
      ...?e.slivers?.map((e) => getPadding(context, e))
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
    List<Widget>? bottomWidget = getExtras()
        .getCustomBottomWidget(context, action: widget.getServerAction());
    if (getExtras().isImagable()) {}
    if (bottomWidget == null) return [];
    return bottomWidget.map((e) {
      if (bottomWidget.indexOf(e) == bottomWidget.length) {
        return getPadding(
            context,
            SliverToBoxAdapter(
              child: e,
            ),
            bottom: 0);
      }
      return SliverToBoxAdapter(child: e);
    }).toList();
  }

  List<Widget> getTopWidget() {
    List<Widget>? topWidget = getExtras()
        .getCustomTopWidget(context, action: widget.getServerAction());
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
        title: AppLocalizations.of(context)!.noItems,
        subtitle: AppLocalizations.of(context)!.no_content);
  }

  @override
  Widget buildAfterCall(BuildContext context, ViewAbstract? newObject) {
    _tabs.clear();
    _tabs.addAll(newObject!.getTabs(context, action: getServerActions()));
    _tabController = TabController(length: _tabs.length, vsync: this);
    return getDraggableHomeBody();
  }

  TabControllerHelper getListableTab() {
    return TabControllerHelper(
      draggableSwithHeaderFromAppbarToScrollAlignment:
          AlignmentDirectional.bottomCenter,
      draggableSwithHeaderFromAppbarToScroll: ValueListenableBuilder(
        valueListenable: onEditListableItem,
        builder: (context, value, child) =>
            getListableInterface().getListableCustomHeader(context) ??
            HeaderListableDraggable(
              listableInterface: getListableInterface(),
            ),
      ),
      slivers: [
        ValueListenableBuilder(
            valueListenable: onListableSelectedItem,
            builder: (context, value, child) {
              if (getListableInterface().getListableList().isEmpty) {
                return SliverFillRemaining(
                  child: getEmptyWidget(context),
                );
              }
              if (getListableInterface().isListableIsImagable()) {
                return ResponsiveSliverGridList(
                    horizontalGridSpacing:
                        4, // Horizontal space between grid items
                    verticalGridSpacing: 4, // Vertical space between grid items
                    horizontalGridMargin: 4, // Horizontal space around the grid
                    verticalGridMargin: 4, // Vertical space around the grid
                    minItemsPerRow:
                        2, // The minimum items to show in a single row. Takes precedence over minItemWidth
                    maxItemsPerRow:
                        4, // The maximum items to show in a single row. Can be useful on large screens
                    sliverChildBuilderDelegateOptions:
                        SliverChildBuilderDelegateOptions(),
                    minItemWidth: 50,
                    children: [
                      ...getListableInterface().getListableList().map((i) {
                        return GridTile(
                            child: Card.outlined(
                                child: InkWell(
                          onTap: () async {
                            final imageUrl = i.getImageUrl(context);
                            final url = Uri.parse(imageUrl ?? "");
                            final response =
                                await HttpWithMiddleware.build().get(url);
                            final contentType = response.headers['image/jpg'];
                            final image = XFile.fromData(
                              response.bodyBytes,
                              mimeType: contentType,
                            );
                            try {
                              await Share.shareXFiles([image]);
                              //  await FlutterShare.share(title: "title");
                            } catch (e) {
                              debugPrint("$e");
                            }
                          },
                          child: Expanded(
                              child: FastCachedImage(
                                  url: i.getImageUrl(context) ?? "")),
                        )));
                      })
                    ]);
              }
              return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                debugPrint(
                    "getListableInterface SliverList index => $index is added");
                ViewAbstract item =
                    getListableInterface().getListableList()[index];
                item.parent = getExtras();
                return ListCardItemEditable<ViewAbstract>(
                  index: index,
                  object: item,
                  useDialog: true,
                  onDelete: (object) {
                    debugPrint(
                        "getListableInterface index => $index is removed");
                    (getListableInterface()).onListableDelete(object);
                    onEditListableItem.value = object;
                  },
                  onUpdate: (object) {
                    (getListableInterface()).onListableUpdate(object);
                    onEditListableItem.value = object;
                  },
                );
              }, childCount: getListableInterface().getListableList().length));
            }),
      ],
      AppLocalizations.of(context)!.adsImages,
    );
  }

  Widget getShimmerLoadingQrCode() {
    return SliverFillRemaining(
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [
            Color(0xFFD8E3E7),
            Color(0xFFC8D5DA),
            Color(0xFFD8E3E7),
          ],
          stops: [
            0.1,
            0.5,
            0.9,
          ],
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [
            Color(0xFF222222),
            Color(0xFF242424),
            Color(0xFF2B2B2B),
            Color(0xFF242424),
            Color(0xFF222222),
            // Color(0xFF242424),
            // Color(0xFF2B2B2B),
            // Color(0xFF242424),
            // Color(0xFF222222),
          ],
          stops: [
            0.0,
            0.2,
            0.5,
            0.8,
            1,
          ],
          // begin: Alignment(-2.4, -0.2),
          // end: Alignment(2.4, 0.2),
          // tileMode: TileMode.clamp,
        ),
        child: SkeletonListView(
          itemCount: 1,
        ),
      ),
    );
  }

  DraggableHome getDraggableHomeBody() {
    dynamic list;
    bool isImagable = false;
    if (extras is ListableInterface) {
      list = extras!.getListableInterface().getListableList();
      isImagable = extras!.isImagable();
      debugPrint("list is count=>${list.length}");
    }
    List<TabControllerHelper> tabs =
        getExtras().getTabs(context, action: getServerActions());
    if (getBodyIsSliver()) {
      tabs[0].slivers = [
        ...getTopWidget(),
        getBody(context),
        ...getBottomWidget(),
        if (list != null)
          const SliverToBoxAdapter(
            child: ListTile(
              leading: Icon(Icons.list),
              title: Text("Images"),
            ),
          ),
        if (list != null)
          if (isImagable)
            getSliverImagable(list)
          else
            SliverList.builder(
                itemCount: list.length,
                itemBuilder: (c, i) => ListCardItemWeb(
                      object: list[i] as ViewAbstract,
                    )),
        // ListStaticWidget<ViewAbstract>(
        //     list: extras!.getListableInterface().getListableList(),
        //     emptyWidget: const Text("null"),
        //     listItembuilder: (item) => ListCardItemWeb(
        //           object: item,
        //         )),
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        )
      ];
    } else {
      tabs[0].widget = getBody(context);
    }
    if (getExtras().isListable()) {
      tabs.insert(1, getListableTab());
    }
    return DraggableHome(
        scrollKey: getExtras().getScrollKey(getServerActions()),
        // backgroundColor: canShowTabBarAsNormal() ? Colors.transparent : null,
        showNormalToolbar: getTabBarIfDesktop(),
        showLeadingAsHamborg: false,
        key: draggableHomeState,
        valueNotifierExpandType: expandType,

        // bottomNavigationBarHeight: 80,
        bottomNavigationBar: isCartableInterface()
            ? BottomAppBar(
                height: 80,
                // color: Theme.of(context).colorScheme.surface,
                // elevation: 2,
                // shape: const AutomaticNotchedShape(RoundedRectangleBorder(
                //   borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(25),
                //       bottomLeft: Radius.circular(25),
                //       bottomRight: Radius.circular(25),
                //       topRight: Radius.circular(25)),
                // )),
                child: BottomWidgetOnViewIfCartable(
                    viewAbstract: getExtras() as CartableProductItemInterface))
            : null,
        bottomNavigationBarHeight: 80,
        // headerBottomBar: Text("sdd"),
        expandedBody:
            isListableInterface() ? getListableInterfaceQrCode() : null,
        headerExpandedHeight: .3,
        stretchMaxHeight: .31,
        scrollController: _scrollController,
        fullyStretchable: isListableInterface(),
        headerWidget: widget.viewAbstract.getHeroTag(
            context: context,
            child: getSliverImageBackground(context) ?? getAppBarBackground()),
        slivers: const [],
        tabs: tabs,
        alwaysShowLeadingAndAction: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: BaseFloatingActionButtons(
          // key: widget.key,
          viewAbstract: widget.viewAbstract,
          serverActions: widget.getServerAction(),
          addOnList: getFloatingActionWidgetAddOns(context),
        ));
  }

  Widget getSliverImagable(list) {
    return SliverToBoxAdapter(
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: MediaQuery.of(context).size.height * .5,
          child: PhotoViewGallery.builder(
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
            pageSnapping: true,
            gaplessPlayback: true,
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              GlobalKey buttonKey = GlobalKey();
              return PhotoViewGalleryPageOptions(
                key: buttonKey,
                tightMode: false,
                imageProvider: FastCachedImageProvider(
                  list[index].getImageUrl(context),
                ),
                onTapDown: (context, details, controllerValue) {
                  ViewAbstract v = list[index];
                  v.onCardLongClicked(context,
                      position: OffsetHelper(details.globalPosition,
                          Size(constraints.maxWidth, constraints.maxHeight)));
                },
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: list[index].iD),
              );
            },
            allowImplicitScrolling: false,
            pageController: PageController(),
            itemCount: list.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                          event.expectedTotalBytes.toNonNullable(),
                ),
              ),
            ),
            // backgroundDecoration: widget.backgroundDecoration,
            // pageController: widget.pageController,
            // onPageChanged: onPageChanged,
          ),
        );
      }),
    );
    return ResponsiveSliverGridList(
        horizontalGridSpacing: 50, // Horizontal space between grid items
        verticalGridSpacing: 50, // Vertical space between grid items
        horizontalGridMargin: 50, // Horizontal space around the grid
        verticalGridMargin: 50, // Vertical space around the grid
        minItemsPerRow:
            2, // The minimum items to show in a single row. Takes precedence over minItemWidth
        maxItemsPerRow:
            4, // The maximum items to show in a single row. Can be useful on large screens
        sliverChildBuilderDelegateOptions: SliverChildBuilderDelegateOptions(),
        minItemWidth: 200,
        children: [
          ...list.map((i) {
            return GridTile(
                child: Card.outlined(
                    child: InkWell(
              onTap: () async {
                final imageUrl = i.getImageUrl(context);
                final url = Uri.parse(imageUrl);
                final response = await HttpWithMiddleware.build().get(url);
                final contentType = response.headers['image/jpg'];
                final image = XFile.fromData(
                  response.bodyBytes,
                  mimeType: contentType,
                );
                try {
                  await Share.shareXFiles([image]);
                  //  await FlutterShare.share(title: "title");
                } catch (e) {
                  debugPrint("$e");
                }
              },
              child:
                  Expanded(child: FastCachedImage(url: i.getImageUrl(context))),
            )));
          })
        ]);
  }

  Widget? getListableInterfaceQrCode() {
    if (getListableInterface().getListablePickObjectQrCode() == null) {
      return null;
    }
    return QrCodeReader(
      onlyReadThisType: getListableInterface().getListablePickObjectQrCode(),
      getViewAbstract: true,
      currentHeight: 20,
      valueNotifierQrStateFunction: (codeState) {
        if (codeState == null) return;
        Widget loadingWidget = ListTile(
          leading: const SkeletonAvatar(
            style: SkeletonAvatarStyle(
                shape: BoxShape.circle, width: 50, height: 50),
          ),
          title: SkeletonParagraph(
            style: SkeletonParagraphStyle(
                lines: 2,
                spacing: 6,
                lineStyle: SkeletonLineStyle(
                  randomLength: true,
                  height: 10,
                  borderRadius: BorderRadius.circular(8),
                  minLength: MediaQuery.of(context).size.width / 6,
                  maxLength: MediaQuery.of(context).size.width / 3,
                )),
          ),
        );

        if (codeState.state == QrCodeCurrentState.LOADING) {
          debugPrint("QrCodeReader codeState is current state loading");
          draggableHomeState.currentState?.addAnimatedListItem(loadingWidget);
          return;
        } else if (codeState.state == QrCodeCurrentState.DONE) {
          //todo if response qrcode is null then add list tile with retry button
          draggableHomeState.currentState?.removeAnimatedListItem(0);
          ViewAbstract? selectedViewAbstract = codeState.viewAbstract;
          getListableInterface()
              .onListableListAddedByQrCode(context, selectedViewAbstract);
          onListableSelectedItem.value = [];
          onEditListableItem.value = null;
        } else {
          draggableHomeState.currentState?.removeAnimatedListItem(0);
        }
      },
    );
  }

  @override
  ViewAbstract getExtras() {
    return super.getExtras() as ViewAbstract;
  }

  bool isCartableInterface() {
    debugPrint("isCartableInterface $T  t is ${(T == BaseEditNewPage)}");
    // return false;
    return getExtras() is CartableProductItemInterface &&
        getExtras().isEditing() &&
        ((T == BaseEditNewPage) == false);
  }

  bool isListableInterface() {
    // return false;
    return getExtras() is ListableInterface;
  }

  ListableInterface getListableInterface() {
    return getExtras().getListableInterface();
  }

  Future<void> getSelectedItemsDialog(BuildContext context) async {
    await showFullScreenDialogExt<ViewAbstract?>(
        anchorPoint: const Offset(1000, 1000),
        context: context,
        builder: (p0) {
          return SliverApiMaster(
            showLeadingAsHamborg: false,
            setParentForChild: getExtras(),
            viewAbstract: getListableInterface().getListablePickObject(),
            buildSearchWidget: true,
            buildFabIfMobile: false,
            buildSearchWidgetAsEditText: true,
            buildFilterableView: false,
            // initialSelectedList: getListableInterface()
            //     .getListableInitialSelectedListPassedByPickedObject(
            //         context), //todo this is a order details to get product from it
            onSelectedListChange: (selectedList) {
              getListableInterface()
                  .onListableSelectedListAdded(context, selectedList);
              onListableSelectedItem.value = selectedList;
              onEditListableItem.value = null;
            },
            // onSelectedListChangeValueNotifier: {},
          );
        }).then((value) {
      {
        // if (value != null) {
        //   widget.onUpdate(value as T);
        //   setState(() {
        //     validated = value;
        //   });
        // }
        // debugPrint("getEditDialog result $value");
      }
    });
  }

  bool canShowTabBarAsNormal() {
    return SizeConfig.isSoLargeScreen(context);
  }

  PreferredSizeWidget? getTabBarIfDesktop() {
    if (!canShowTabBarAsNormal()) return null;
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Selector<ActionViewAbstractProvider,
                List<ListToDetailsSecoundPaneHelper?>>(
              builder: (_, v, __) {
                debugPrint("SelectorActionViewAbstractProvider ${v.length}");
                if (v.isEmpty || v.length == 1) {
                  return const SizedBox();
                }
                // if (v.length == 1) {
                //   if (v[0]?.isMain ?? false) {
                //     return SizedBox();
                //   }
                // }
                int i = v.length - 1;
                return BackButton(onPressed: () {
                  context.read<ActionViewAbstractProvider>().pop();
                  // context
                  //     .read<ActionViewAbstractProvider>()
                  //     .change(v[i]!.object!, v[i]!.serverActions!,removeLast: true);
                });
              },
              selector: (p, p0) => p0.getStackedActions,
            ),
            getExtras().getCardLeading(context),
          ],
        ),
      ),
      leadingWidth: 120,
      title: Text(getExtras().getMainHeaderTextOnly(context)),
      actions: [
        ActionsOnHeaderPopupWidget(
          viewAbstract: getExtras(),
          serverActions: getServerActions(),
        )
      ],
    );
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: BaseSharedHeaderViewDetailsActions(viewAbstract: getExtras()),
    );
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
