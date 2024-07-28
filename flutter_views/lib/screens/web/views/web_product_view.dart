import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_images.dart';
import 'package:flutter_view_controller/screens/web/views/web_view_details.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

@immutable
class WebProductView extends BaseWebPageSliversApi {
  final bool? buildSmallView;
  final bool usePaddingOnBottomWidgets;
  ValueNotifier<ViewAbstract?>? onHorizontalItemClick;
  WebProductView(
      {super.key,
      super.extras,
      required super.iD,
      this.buildSmallView,
      required super.tableName,
      super.buildFooter,
      super.buildHeader,
      this.usePaddingOnBottomWidgets = false,
      super.pinToolbar,
      super.useSmallFloatingBar,
      this.onHorizontalItemClick,
      super.customSliverHeader});

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
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      if (buildSmallView ?? false)
        getSliverPadding(
            context,
            constraints,
            SliverToBoxAdapter(
              child: getDetailsView(context),
            ))
      else
        SliverToBoxAdapter(
          child: ScreenHelper(
            largeTablet: _buildUi(context, kDesktopMaxWidth, constraints),
            smallTablet: _buildUi(context, kTabletMaxWidth, constraints),
            mobile: _buildUi(context, getMobileMaxWidth(context), constraints),
          ),
        ),
      ...getBottomWidget(context, constraints),
      const SliverToBoxAdapter(
        child: SizedBox(height: 80),
      )
    ];
  }

  List<Widget> getTopWidget(BuildContext context) {
    List<Widget>? topWidget = getExtras()?.getCustomTopWidget(context,
        action: getServerActions(),
        onHorizontalListItemClicked: onHorizontalItemClick);
    if (topWidget == null) return [];
    return topWidget;
  }

  List<Widget> getBottomWidget(
      BuildContext context, BoxConstraints constraint) {
    List<Widget>? bottomWidget = getExtras()?.getCustomBottomWidget(context,
        action: getServerActions(),
        onHorizontalListItemClicked: onHorizontalItemClick);
    if (bottomWidget == null) return [];
    return bottomWidget.map((e) {
      if (buildSmallView ?? false) {
        return usePaddingOnBottomWidgets
            ? getPadding(
                context,
                SliverToBoxAdapter(
                  child: e,
                ),
                bottom: 20)
            : getSliverPadding(
                context,
                constraint,
                SliverToBoxAdapter(
                  child: e,
                ));
      } else {
        return usePaddingOnBottomWidgets
            ? getPadding(
                context,
                SliverToBoxAdapter(
                  child: ResponsiveWebBuilder(builder: (context, width) => e),
                ),
                bottom: 20)
            : getSliverPadding(
                context,
                constraint,
                SliverToBoxAdapter(
                  child: e,
                ));
      }
    }).toList();
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }

  Widget _buildUi(
      BuildContext context, double width, BoxConstraints constraints) {
    return Center(
        child: MaxWidthBox(
      maxWidth: width,
      // minWidth: width,
      // defaultScale: false,
      child: Flex(
        direction: constraints.maxWidth > 720 ? Axis.horizontal : Axis.vertical,
        children: [
          // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
          Expanded(
              flex: constraints.maxWidth > 720.0 ? 1 : 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kBorderRadius / 2),
                child: 
                
                WebProductImages(
                  item: extras!,
                ),
              )),
          Expanded(
              flex: constraints.maxWidth > 720.0 ? 1 : 0,
              child: getDetailsView(context)),
        ],
      ),
    ));
  }

  Column getDetailsView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (buildSmallView == false)
          getWebText(title: extras!.getMainHeaderTextOnly(context)),
        if (buildSmallView == false)
          const SizedBox(
            height: 20,
          ),
        ...getTopWidget(context),
        WebViewDetails(
          viewAbstract: extras!,
        ),
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
        if (extras is CartableProductItemInterface)
          BottomWidgetOnViewIfCartable(
              viewAbstract: extras as CartableProductItemInterface),

        // if(extras is SharableInterface)
      ],
    );
  }
}
