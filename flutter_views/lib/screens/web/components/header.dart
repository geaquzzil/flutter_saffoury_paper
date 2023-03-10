import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/popup_widget.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/overlay_page.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../ext.dart';
import '../models/header_item.dart';

class HeaderLogo extends StatelessWidget {
  ValueNotifier<double>? valueNotifier;
  HeaderLogo({Key? key, this.valueNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AnimatedScale(
            //   scale: (valueNotifier?.value ?? 1.0) > 0 ? 1 : 0,
            //   duration: const Duration(milliseconds: 275),
            //   child: CompanyLogo(size: 70),
            // ),
            // CompanyLogo(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Saffoury".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)

                      // GoogleFonts.roboto(
                      //   // color: Theme.of(context).colorScheme.onBackground,
                      //   fontSize: 32.0,
                      //   fontWeight: FontWeight.w400,
                      // ),
                      ),
                  TextSpan(
                      text: "Paper".toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w200,
                          )

                      // style: GoogleFonts.roboto(
                      //   // color: Theme.of(context).colorScheme.onBackground,
                      //   fontSize: 32.0,
                      //   fontWeight: FontWeight.w200,
                      // ),
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  TextEditingController textController = TextEditingController();
  final String selectedHeader;
  final GlobalKey menuKey = GlobalKey();
  HeaderRow({Key? key, required this.selectedHeader}) : super(key: key);
  showMenus(BuildContext context) async {
    final render = menuKey.currentContext!.findRenderObject() as RenderBox;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          render.localToGlobal(Offset.zero).dx,
          render.localToGlobal(Offset.zero).dy + 50,
          double.infinity,
          double.infinity),
      items: [
        const PopupMenuItem(
          child: Text("Create a website"),
        ),
        const PopupMenuItem(
          child: Text("Top Ms commericial management"),
        ),
        const PopupMenuItem(
          child: Text("Mobile inventory application"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var headerItems = getHeaderItems(context);
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [
        Condition.largerThan(name: MOBILE),
      ],
      child: Row(children: [
        ...headerItems
            .map(
              (item) => item.isButton
                  ? MouseRegion(
                      // onExit: (event) => Navigator.of(context).pop(),
                      onHover: (event) {
                        showMenus(context);
                      },
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        key: menuKey,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: TextButton(
                          // onPressed: () {},
                          onPressed: () => item.onClick?.call(),
                          child: Text(item.title.toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall
                              // const TextStyle(
                              //   // color: Colors.white,
                              //   fontSize: 13.0,
                              //   fontWeight: FontWeight.bold,
                              // ),
                              ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        debugPrint("onTap onHoverWidget");
                        item.onClick?.call();
                      },
                      child: OnHoverWidget(
                        scale: false,
                        builder: (isHovered) => Container(
                          margin: const EdgeInsets.only(right: 30.0),
                          child: Text(item.title.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: isHovered ||
                                              selectedHeader.toLowerCase() ==
                                                  item.title.toLowerCase()
                                          ? kAccentColor
                                          : null)),
                        ),
                      ),
                    ),
            )
            .toList(),
        // AnimSearchBar(
        //   textFieldIconColor: Colors.black,
        //   // color: Theme.of(context).scaffoldBackgroundColor,

        //   width: 400,
        //   textController: textController,
        //   onSuffixTap: () {},
        //   onSubmitted: (s) {
        //     context.goNamed(indexWebOurProducts, queryParams: {"search": s});
        //   },
        // ),
        CartIconWidget(
          onPressed:
              context.read<DrawerMenuControllerProvider>().controlEndDrawerMenu,
          returnNillIfZero: true,
        ),
        if (context.read<AuthProvider<AuthUser>>().getStatus ==
            Status.Authenticated)
          Row(
            children: [
              getWebText(
                  fontSize: 12,
                  color: Colors.orange,
                  title: AppLocalizations.of(context)!.hiThere +
                      "\n" +
                      context.read<AuthProvider<AuthUser>>().getUserName),
              const SizedBox(
                width: kDefaultPadding / 2,
              ),
              const ProfilePicturePopupMenu(),
            ],
          ),
        // CustomPopupMenu(
        //   menuBuilder: () => ProfileMenuWidget(controller: _controller),
        //   pressType: PressType.singleClick,

        //   child: RoundedIconButtonNetwork(
        //       onTap: () {}, imageUrl: authProvider.getUserImageUrl),
        // ),
      ]),
    );
  }

  MouseRegion getHeaderItem(BuildContext context, HeaderItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(right: 30.0),
        child: GestureDetector(
          onTap: () => item.onClick?.call(),
          child: Text(item.title.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String selectedHeader;
  ValueNotifier<double>? valueNotifier;
  Header({Key? key, required this.selectedHeader, this.valueNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (valueNotifier != null) {
      return ValueListenableBuilder<double>(
        valueListenable: valueNotifier!,
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 275),
            decoration: BoxDecoration(
                boxShadow: value == 0
                    ? null
                    : [
                        BoxShadow(
                            spreadRadius: 3,
                            color: context.isDarkMode
                                ? Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(.5)
                                : Colors.black54,
                            offset: const Offset(0, 2.0),
                            blurRadius: 5)
                      ],
                border: value == 0
                    ? null
                    : Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(.7))),
                color: value == 0
                    ? null
                    : context.isDarkMode
                        ? Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(.7)
                        : Colors.white),
            child: ClipRect(
              child: context.isDarkMode
                  ? getBackdropFilter(context)
                  : getBody(context),
            ),
          );
        },
      );
    }
    return ScreenHelper(
      desktop: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: buildHeader(),
      ),
      // We will make this in a bit
      mobile: buildMobileHeader(context),
      tablet: buildHeader(),
    );
  }

  BackdropFilter getBackdropFilter(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: getBody(context),
    );
  }

  ScreenHelper getBody(BuildContext context) {
    return ScreenHelper(
      desktop: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: buildHeader(valueNotifier: valueNotifier),
      ),
      // We will make this in a bit
      mobile: buildMobileHeader(context),
      tablet: buildHeader(),
    );
  }

  // mobile header
  Widget buildMobileHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderLogo(),
            // Restart server to make icons work
            // Lets make a scaffold key and create a drawer
            GestureDetector(
              onTap: () {
                // Lets open drawer using global key
                context
                    .read<DrawerMenuControllerProvider>()
                    .controlStartDrawerMenu();
              },
              child: const Icon(
                FlutterIcons.menu_fea,
                // color: Colors.white,
                size: 28.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Lets plan for mobile and smaller width screens
  Widget buildHeader({ValueNotifier<double>? valueNotifier}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderLogo(valueNotifier: valueNotifier),
          HeaderRow(selectedHeader: selectedHeader),
        ],
      ),
    );
  }
}

class WebMobileDrawer extends StatelessWidget {
  final String selectedHeader;
  const WebMobileDrawer({super.key, required this.selectedHeader});

  @override
  Widget build(BuildContext context) {
    var headerItems = getHeaderItems(context);
    Widget? header =
        context.read<AuthProvider<AuthUser>>().getStatus == Status.Authenticated
            ? ProfileHeaderListTileWidget(
                onTap: () {
                  context
                      .read<DrawerMenuControllerProvider>()
                      .controlStartDrawerMenu();
                  context.goNamed(indexWebSettingAndAccount);
                },
              )
            : null;
    return NavigationDrawer(
      onDestinationSelected: (value) {
        debugPrint("onDestinationSelected index $value");
        headerItems[value].onClick?.call();
      },
      selectedIndex: headerItems.indexWhere(
        (element) => element.title == selectedHeader,
      ),
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: HeaderLogo()),
        ...headerItems.map((HeaderItem destination) {
          return NavigationDrawerDestination(
              label: Text(destination.title),
              icon: destination.getIcon(),
              selectedIcon: destination.getSelectedIcon());
        }),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        if (header != null) header
      ],
    );

    Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              if (index >= headerItems.length) {
                return header!;
              }
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
                          child: Text(headerItems[index].title,
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                      ),
                    )
                  : ListTile(
                      onTap: () {
                        context
                            .read<DrawerMenuControllerProvider>()
                            .controlStartDrawerMenu();
                        headerItems[index].onClick?.call();
                      },
                      selected: headerItems[index].title == selectedHeader,
                      title: Text(
                        headerItems[index].title,
                      ),
                    );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10.0,
              );
            },
            itemCount: headerItems.length + (header != null ? 1 : 0),
          ),
        ),
      ),
    );
  }
}
