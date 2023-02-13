import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/screens/web/about-us.dart';
import 'package:flutter_view_controller/screens/web/components/footer.dart';
import 'package:flutter_view_controller/screens/web/components/header.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/home.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/screens/web/terms.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:smooth_scroll_web/smooth_scroll_web.dart';

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
  Widget? getContentWidget(BuildContext context);
  const BaseWebPage({Key? key}) : super(key: key);

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
}

abstract class BaseWebPageSlivers extends StatelessWidget {
  List<Widget> getContentWidget(BuildContext context);
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

  ValueNotifier<double> onScroll = ValueNotifier<double>(0);
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
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            debugPrint("onNotification  ${notification.metrics.extentBefore}");
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
          child: CustomScrollView(slivers: [
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
        ));
  }
}
