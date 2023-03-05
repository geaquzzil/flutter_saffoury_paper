import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/scroll_to_hide_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/web/about-us.dart';
import 'package:flutter_view_controller/screens/web/components/footer.dart';
import 'package:flutter_view_controller/screens/web/components/header.dart';
import 'package:flutter_view_controller/screens/web/contact-us.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/home.dart';
import 'package:flutter_view_controller/screens/web/models/header_item.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/screens/web/terms.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/screens/web/web_shoping_cart.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:smooth_scroll_web/smooth_scroll_web.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../../models/servers/server_helpers.dart';
import '../../models/view_abstract.dart';
import '../../new_screens/cart/base_home_cart_screen.dart';

abstract class BaseWebPageState<T extends StatefulWidget> extends State<T> {
  Widget? getContentWidget(BuildContext context);
  @override
  Widget build(BuildContext context) {
    var headerItems = getHeaderItems(context);
    return Scaffold(
      // key: Globals.scaffoldKey,
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return headerItems[index].isButton
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kDangerColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: TextButton(
                            onPressed: () => headerItems[index].onClick?.call(),
                            child: Text(
                              headerItems[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListTile(
                        title: Text(
                          headerItems[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10.0,
                );
              },
              itemCount: headerItems.length,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader(context),
            getContentWidget(context)!,
            const Footer(),
          ],
        ),
      ),
    );
  }

  String getSelectedHeader(BuildContext context) {
    if (this is AboutUsWebPage) {
      return AppLocalizations.of(context)!.about;
    } else if (this is HomeWebPage) {
      return AppLocalizations.of(context)!.home;
    } else if (this is ProductWebPage) {
      return AppLocalizations.of(context)!.products;
    } else if (this is TermsWebPage) {
      return AppLocalizations.of(context)!.termsAndConitions;
    } else {
      return "";
    }
  }

  Widget getHeader(BuildContext context) {
    if (kIsWeb) {
      return Header(
        selectedHeader: getSelectedHeader(context),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
        child: BackButton(),
      );
    }
  }
}

abstract class BaseWebPage extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  Widget? getContentWidget(BuildContext context);
  BaseWebPage({Key? key}) : super(key: key);

  String getSelectedHeader(BuildContext context) {
    if (this is AboutUsWebPage) {
      return AppLocalizations.of(context)!.about;
    } else if (this is HomeWebPage) {
      return AppLocalizations.of(context)!.home;
    } else if (this is ProductWebPage) {
      return AppLocalizations.of(context)!.products;
    } else if (this is TermsWebPage) {
      return AppLocalizations.of(context)!.termsAndConitions;
    } else {
      return "";
    }
  }

  Widget getHeader(BuildContext context) {
    if (kIsWeb) {
      return Header(
        selectedHeader: getSelectedHeader(context),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
        child: BackButton(),
      );
    }
  }

  void _scrollTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    var headerItems = getHeaderItems(context);

    return Scaffold(
      // appBar: ScrollToHideWidget(),
      // key: Globals.scaffoldKey,
      floatingActionButton: ScrollToHideWidget(
        controller: _scrollController,
        child: FloatingActionButton(
            onPressed: () {
              _scrollTop();
            },
            child: const Icon(Icons.arrow_upward_sharp)),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return headerItems[index].isButton
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kDangerColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: TextButton(
                            onPressed: () => headerItems[index].onClick?.call(),
                            child: Text(
                              headerItems[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListTile(
                        title: Text(
                          headerItems[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10.0,
                );
              },
              itemCount: headerItems.length,
            ),
          ),
        ),
      ),
      body: WebSmoothScroll(
        controller: _scrollController,
        scrollOffset: 250, // additional offset to users scroll input
        animationDuration: 600,
        //     500, // duration of animation of scroll in milliseconds
        // curve: Curves.easeIn, // curve of the animation
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHeader(context),
              getContentWidget(context)!,
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class BaseWebPageSlivers extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints);

  final bool buildHeader;
  final bool buildFooter;
  final bool pinToolbar;
  final bool useSmallFloatingBar;
  final Widget? customSliverHeader;
  BaseWebPageSlivers(
      {Key? key,
      this.buildHeader = true,
      this.useSmallFloatingBar = false,
      this.buildFooter = true,
      this.customSliverHeader,
      this.pinToolbar = true})
      : super(key: key);

  String getSelectedHeader(BuildContext context) {
    if (this is AboutUsWebPage) {
      return AppLocalizations.of(context)!.about;
    } else if (this is HomeWebPage) {
      return AppLocalizations.of(context)!.home;
    } else if (this is ProductWebPage) {
      return AppLocalizations.of(context)!.products;
    } else if (this is TermsWebPage) {
      return AppLocalizations.of(context)!.termsAndConitions;
    } else if (this is ContactUsWebPage) {
      return AppLocalizations.of(context)!.contactUs;
    } else {
      return "";
    }
  }

  void _scrollTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget getSliverSizedBox({double height = kDefaultPadding, double? width}) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
  }

  Widget getHeader(BuildContext context) {
    if (kIsWeb) {
      return Header(
        valueNotifier: onScroll,
        selectedHeader: getSelectedHeader(context),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
        child: BackButton(),
      );
    }
  }

  SliverPadding getPadding(BuildContext context, Widget sliver,
      {double? bottom}) {
    return SliverPadding(
        padding: EdgeInsets.only(
            top: kDefaultPadding / 2,
            right: kDefaultPadding,
            bottom: bottom ?? 0,
            left: kDefaultPadding),
        sliver: sliver);
  }

  Widget getSliverPadding(
      BuildContext context, BoxConstraints constraints, Widget child,
      {double padd = 2}) {
    double defualPadding =
        ScreenHelper.isMobile(context) ? kDefaultPadding * 2 : kDefaultPadding;
    double horizontalPadding = max(
        (constraints.maxWidth -
                (ScreenHelper.isTablet(context)
                    ? kTabletMaxWidth
                    : kDesktopMaxWidth)) /
            padd,
        0);
    return SliverPadding(
        padding: EdgeInsets.symmetric(
            vertical: defualPadding,
            horizontal: horizontalPadding > defualPadding
                ? horizontalPadding
                : defualPadding),
        sliver: child);
  }

  void init(BuildContext context) {
    _scrollController.addListener(() => _onScroll(context));
  }

  ValueNotifier<double> onScroll = ValueNotifier<double>(0);
  @override
  Widget build(BuildContext context) {
    init(context);

    return getScaffold(context);
  }

  Widget getScaffold(BuildContext context) {
    return Scaffold(
        backgroundColor: !buildHeader ? Colors.transparent : null,
        floatingActionButton: getFloatingActionButton(),
        key: !buildHeader
            ? null
            : context
                .read<DrawerMenuControllerProvider>()
                .getStartDrawableKeyWeb(runtimeType.toString()),
        endDrawer: getEndDrawer(),
        drawer: WebMobileDrawer(selectedHeader: getSelectedHeader(context)),
        body: getBody(context));
  }

  LayoutBuilder getBody(BuildContext context) {
    return LayoutBuilder(
      builder: (c, constraints) => WebSmoothScroll(
        controller: _scrollController,
        scrollOffset: 250, // additional offset to users scroll input
        animationDuration: 600,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            debugPrint("onNotification  ${notification.metrics.extentBefore}");
            onScroll.value = notification.metrics.extentBefore;

            return false;
          },
          child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: [
                if (buildHeader)
                  SliverPersistentHeader(
                      pinned: pinToolbar,
                      floating: true,
                      delegate: SliverAppBarDelegatePreferedSize(
                          child: PreferredSize(
                              preferredSize: const Size.fromHeight(70.0),
                              child: getHeader(context)))),
                if (customSliverHeader != null) customSliverHeader!,
                ...getContentWidget(context, constraints),
                if (buildFooter)
                  const SliverToBoxAdapter(
                    child: Footer(),
                  )
              ]),
        ),
      ),
    );
  }

  SizedBox getEndDrawer() {
    return SizedBox(width: 500, child: Card(child: WebShoppingCartDrawer()));
  }

  Widget getDrawer(List<HeaderItem> headerItems) {
    return Card(
      child: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return headerItems[index].isButton
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kDangerColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: TextButton(
                            onPressed: () => headerItems[index].onClick?.call(),
                            child: Text(
                              headerItems[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListTile(
                        title: Text(
                          headerItems[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10.0,
                );
              },
              itemCount: headerItems.length,
            ),
          ),
        ),
      ),
    );
  }

  ScrollToHideWidget getFloatingActionButton() {
    return ScrollToHideWidget(
      // useAnimatedSwitcher: true,
      useAnimatedScaling: true,
      // height: 50,
      reverse: true,
      controller: _scrollController,
      child: useSmallFloatingBar
          ? FloatingActionButton.small(
              onPressed: () {
                _scrollTop();
              },
              child: const Icon(Icons.arrow_upward_sharp))
          : FloatingActionButton(
              onPressed: () {
                _scrollTop();
              },
              child: const Icon(Icons.arrow_upward_sharp)),
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void isScrolled(BuildContext context) {}
  void _onScroll(BuildContext context) {
    if (_isBottom) {
      debugPrint("Base Web is scrolled");
      isScrolled(context);
    }
  }
}

abstract class BaseWebPageSliversApi extends BaseWebPageSlivers {
  int iD;
  String tableName;
  ViewAbstract? extras;
  BaseWebPageSliversApi(
      {Key? key,
      required this.iD,
      required this.tableName,
      this.extras,
      super.buildFooter,
      super.buildHeader,
      super.pinToolbar,
      super.customSliverHeader,
      super.useSmallFloatingBar})
      : super(key: key);
  Future<ViewAbstract?> getCallApiFunctionIfNull(BuildContext context);
  ServerActions getServerActions();
  ViewAbstract? getExtras() {
    return extras;
  }

  bool getBodyWithoutApi() {
    if (extras is! ViewAbstract) return false;

    bool canGetBody =
        (extras as ViewAbstract).isRequiredObjectsList()?[getServerActions()] ==
            null;
    if (canGetBody) {
      debugPrint("BaseApiCallPageState getBodyWithoutApi skiped");
      return true;
    }
    bool res = (extras as ViewAbstract).isNew() ||
        (extras as ViewAbstract).isRequiredObjectsListChecker();
    debugPrint("BaseApiCallPageState getBodyWithoutApi result => $res");
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (extras != null && getBodyWithoutApi()) {
      return getScaffold(context);
    }

    return FutureBuilder<ViewAbstract?>(
      future: getCallApiFunctionIfNull(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyWidget(
              lottiUrl:
                  "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
              onSubtitleClicked: () {
                // setState(() {});
              },
              title: AppLocalizations.of(context)!.cantConnect,
              subtitle: AppLocalizations.of(context)!.cantConnectRetry);
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            extras = snapshot.data;
            if (extras is ViewAbstract) {}
            return getScaffold(context);
          } else {
            return EmptyWidget(
                lottiUrl:
                    "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
                onSubtitleClicked: () {
                  // setState(() {});
                },
                title: AppLocalizations.of(context)!.cantConnect,
                subtitle: AppLocalizations.of(context)!.cantConnectRetry);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else {
          return const Text("TOTODO");
        }
      },
    );
  }
}
