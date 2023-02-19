import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../ext.dart';
import '../models/header_item.dart';

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CompanyLogo(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Saffoury".toUpperCase(),
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "Paper".toUpperCase(),
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w200,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
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
                          child: Text(
                            item.title.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
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
                          child: Text(
                            item.title.toUpperCase(),
                            style: TextStyle(
                              color: selectedHeader.toLowerCase() ==
                                          item.title.toLowerCase() ||
                                      isHovered
                                  ? kPrimaryColor
                                  : Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
            )
            .toList(),
        AnimSearchBar(
          // color: Theme.of(context).scaffoldBackgroundColor,

          width: 400,
          textController: textController,
          onSuffixTap: () {},
          onSubmitted: (s) {
            context.goNamed(indexWebOurProducts, queryParams: {"search": s});
          },
        ),
        CartIconWidget(
          returnNillIfZero: true,
        )
      ]),
    );
  }

  MouseRegion getHeaderItem(HeaderItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(right: 30.0),
        child: GestureDetector(
          onTap: () => item.onClick?.call(),
          child: Text(
            item.title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                border: value == 0
                    ? null
                    : const Border.symmetric(
                        horizontal: BorderSide(width: 2, color: Colors.orange)),
                color: value == 0
                    ? null
                    : Theme.of(context).scaffoldBackgroundColor.darken()),
            child: ScreenHelper(
              desktop: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: buildHeader(),
              ),
              // We will make this in a bit
              mobile: buildMobileHeader(),
              tablet: buildHeader(),
            ),
          );
        },
      );
    }
    return Container(
      child: ScreenHelper(
        desktop: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: buildHeader(),
        ),
        // We will make this in a bit
        mobile: buildMobileHeader(),
        tablet: buildHeader(),
      ),
    );
  }

  // mobile header
  Widget buildMobileHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const HeaderLogo(),
            // Restart server to make icons work
            // Lets make a scaffold key and create a drawer
            GestureDetector(
              onTap: () {
                // Lets open drawer using global key
                Globals.scaffoldKey.currentState?.openEndDrawer();
              },
              child: const Icon(
                FlutterIcons.menu_fea,
                color: Colors.white,
                size: 28.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Lets plan for mobile and smaller width screens
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderLogo(),
          HeaderRow(selectedHeader: selectedHeader),
        ],
      ),
    );
  }
}
