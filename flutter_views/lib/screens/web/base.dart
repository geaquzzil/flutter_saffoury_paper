import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/screens/web/about-us.dart';
import 'package:flutter_view_controller/screens/web/components/footer.dart';
import 'package:flutter_view_controller/screens/web/components/header.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/home.dart';
import 'package:flutter_view_controller/screens/web/models/header_item.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/screens/web/terms.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:smooth_scroll_web/smooth_scroll_web.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../../models/servers/server_helpers.dart';
import '../../models/view_abstract.dart';

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

  @override
  Widget build(BuildContext context) {
    var headerItems = getHeaderItems(context);

    return Scaffold(
      // appBar: ScrollToHideWidget(),
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
  BaseWebPageSlivers({Key? key}) : super(key: key);

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

  Widget getSliverPadding(
      BuildContext context, BoxConstraints constraints, Widget child) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: max((constraints.maxWidth - 1200) / 2, 0) > 15
                ? max((constraints.maxWidth - 1200) / 2, 0)
                : 15),
        sliver: child);
  }

  void init(BuildContext context) {
    _scrollController.addListener(() => _onScroll(context));
  }

  ValueNotifier<double> onScroll = ValueNotifier<double>(0);
  @override
  Widget build(BuildContext context) {
    init(context);
    var headerItems = getHeaderItems(context);
    return Scaffold(
        // appBar: ScrollToHideWidget(),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 28.0),
                            child: TextButton(
                              onPressed: () =>
                                  headerItems[index].onClick?.call(),
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
        body: LayoutBuilder(
          builder: (c, constraints) => WebSmoothScroll(
            controller: _scrollController,
            scrollOffset: 250, // additional offset to users scroll input
            animationDuration: 600,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                debugPrint(
                    "onNotification  ${notification.metrics.extentBefore}");
                onScroll.value = notification.metrics.extentBefore;
                // // if (widget.showAppbarOnTopOnly && widget.scrollController != null) {
                // //   debugPrint(
                // //       "DraggableHome ${widget.scrollController!.position.pixels}");
                // //   if (widget.scrollController!.position.pixels >= 200) {
                // //     if (isFullyExpanded.value) isFullyExpanded.add(false);
                // //     if ((!isFullyCollapsed.value)) isFullyCollapsed.add(true);
                // //     // expandedHeight = 0;
                // //     return false;
                // //   }
                // // }

                // if (notification.metrics.axis == Axis.vertical) {
                //   // isFullyCollapsed
                //   if ((isFullyExpanded.value) &&
                //       notification.metrics.extentBefore > 100) {
                //     isFullyExpanded.add(false);
                //   }
                //   // if (widget.hideBottomNavigationBarOnScroll) {
                //   //   if (notification.metrics.extentBefore > 100) {
                //   //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //   //       hideWhenScroll.value = true;
                //   //     });
                //   //   } else {
                //   //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //   //       hideWhenScroll.value = false;
                //   //     });
                //   //   }
                //   // }

                //   //isFullyCollapsed
                //   if (notification.metrics.extentBefore >
                //       expandedHeight - AppBar().preferredSize.height - 40) {
                //     if (!(isFullyCollapsed.value)) isFullyCollapsed.add(true);
                //   } else {
                //     if ((isFullyCollapsed.value)) isFullyCollapsed.add(false);
                //   }

                return false;
              },
              child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: SliverAppBarDelegatePreferedSize(
                            child: PreferredSize(
                                preferredSize: const Size.fromHeight(70.0),
                                child: getHeader(context)))),
                    ...getContentWidget(context, constraints),
                    const SliverToBoxAdapter(
                      child: Footer(),
                    )
                  ]),
            ),
          ),
        ));
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

abstract class BaseWebPageSliversApi extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  List<Widget> getContentWidget(BuildContext context);
  int iD;
  String tableName;
  ViewAbstract? extras;
  BaseWebPageSliversApi(
      {Key? key, required this.iD, required this.tableName, this.extras})
      : super(key: key);
  Future<ViewAbstract?> getCallApiFunctionIfNull(BuildContext context);
  ServerActions getServerActions();
  ViewAbstract? getExtras() {
    return extras;
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

  ValueNotifier<double> onScroll = ValueNotifier<double>(0);
  @override
  Widget build(BuildContext context) {
    if (extras != null && getBodyWithoutApi()) {
      return buildAfterCall(context);
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
            if (extras is ViewAbstract) {
              // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //   context
              //       .read<ListMultiKeyProvider>()
              //       .edit(extras as ViewAbstract);
              // });
            }
            return buildAfterCall(context);
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

  Scaffold buildAfterCall(BuildContext context) {
    var headerItems = getHeaderItems(context);
    return Scaffold(
        // appBar: ScrollToHideWidget(),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 28.0),
                            child: TextButton(
                              onPressed: () =>
                                  headerItems[index].onClick?.call(),
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
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              debugPrint(
                  "onNotification  ${notification.metrics.extentBefore}");
              onScroll.value = notification.metrics.extentBefore;
              return false;
            },
            child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _scrollController,
                slivers: [
                  SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: SliverAppBarDelegatePreferedSize(
                          child: PreferredSize(
                              preferredSize: const Size.fromHeight(70.0),
                              child: getHeader(context)))),
                  ...getContentWidget(context),
                  const SliverToBoxAdapter(
                    child: Footer(),
                  )
                ]),
          ),
        ));
  }
}
