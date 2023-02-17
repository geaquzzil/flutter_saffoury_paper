import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_images.dart';
import 'package:flutter_view_controller/screens/web/views/web_view_details.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class WebProductView extends BaseWebPageSliversApi {
  WebProductView(
      {super.key, super.extras, required super.iD, required super.tableName});

  @override
  Future<ViewAbstract?> getCallApiFunctionIfNull(BuildContext context) {
    if (getExtras() == null) {
      ViewAbstract newViewAbstract =
          context.read<AuthProvider<AuthUser>>().getNewInstance(tableName)!;
      return newViewAbstract.viewCallGetFirstFromList(iD)
          as Future<ViewAbstract?>;
    } else {
      return (getExtras() as ViewAbstract)
              .viewCallGetFirstFromList((getExtras() as ViewAbstract).iD)
          as Future<ViewAbstract?>;
    }
  }

  @override
  List<Widget> getContentWidget(BuildContext context) {
    return [
      SliverToBoxAdapter(
        child: ScreenHelper(
          desktop: _buildUi(kDesktopMaxWidth),
          tablet: _buildUi(kTabletMaxWidth),
          mobile: _buildUi(getMobileMaxWidth(context)),
        ),
      ),
      ...getBottomWidget(context),
      const SliverToBoxAdapter(
        child: SizedBox(height: 80),
      )
    ];
  }

  List<Widget> getTopWidget(BuildContext context) {
    List<Widget>? topWidget =
        getExtras()?.getCustomTopWidget(context, action: getServerActions());
    if (topWidget == null) return [];
    return topWidget;
  }

  List<Widget> getBottomWidget(BuildContext context) {
    List<Widget>? bottomWidget =
        getExtras()?.getCustomBottomWidget(context, action: getServerActions());
    if (bottomWidget == null) return [];
    return bottomWidget.map((e) {
      return getPadding(
          context,
          SliverToBoxAdapter(
            child: ResponsiveWebBuilder(builder: (context, width) => e),
          ),
          bottom: 20);
      // if (bottomWidget.indexOf(e) == bottomWidget.length) {
      //   return getPadding(
      //       context,
      //       SliverToBoxAdapter(
      //         child: ResponsiveWebBuilder(builder: (context, width) => e),
      //       ),
      //       bottom: 20);
      // }
      return SliverToBoxAdapter(
          child: ResponsiveWebBuilder(builder: (context, width) => e));
    }).toList();
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }

  Widget _buildUi(double width) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveWrapper(
            maxWidth: width,
            minWidth: width,
            defaultScale: false,
            child: Container(
              child: Flex(
                direction: constraints.maxWidth > 720
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                  Expanded(
                      flex: constraints.maxWidth > 720.0 ? 1 : 0,
                      child: WebProductImages(
                        item: extras!,
                      )),
                  Expanded(
                      flex: constraints.maxWidth > 720.0 ? 1 : 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getWebText(
                              title: extras!.getMainHeaderTextOnly(context)),
                          const SizedBox(
                            height: 20,
                          ),
                          ...getTopWidget(context),
                          WebViewDetails(
                            viewAbstract: extras!,
                          ),
                          if (extras is CartableProductItemInterface)
                            BottomWidgetOnViewIfCartable(
                                viewAbstract:
                                    extras as CartableProductItemInterface)
                        ],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
