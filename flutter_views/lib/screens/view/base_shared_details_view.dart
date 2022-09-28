import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/base_shared_header_description.dart';
import 'package:flutter_view_controller/screens/view/view_list_details.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BaseSharedDetailsView extends StatefulWidget {
  const BaseSharedDetailsView({Key? key}) : super(key: key);

  @override
  State<BaseSharedDetailsView> createState() => _BaseSharedDetailsViewState();
}

class _BaseSharedDetailsViewState extends State<BaseSharedDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> tabs = [];
  @override
  void initState() {
    super.initState();
    ActionViewAbstractProvider abstractProvider =
        Provider.of<ActionViewAbstractProvider>(context, listen: false);
    tabs.addAll(abstractProvider.getObject?.getTabs(context) ?? []);
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    ActionViewAbstractProvider actionViewAbstractProvider =
        context.watch<ActionViewAbstractProvider>();

    ViewAbstract? viewAbstract = actionViewAbstractProvider.getObject;
    if (viewAbstract == null) {
      return Scaffold(body: getEmptyView(context));
    } else {
      tabs.clear();
      tabs.addAll(viewAbstract.getTabs(context));

      switch (actionViewAbstractProvider.getServerActions) {
        case ServerActions.edit:
          return Scaffold(body: BaseEditPage(parent: viewAbstract));
        default:
          return Scaffold(body: getBodyView(context, viewAbstract));
      }
    }
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets3.lottiefiles.com/private_files/lf30_gctc76jz.json"),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget getBodyView(BuildContext context, ViewAbstract viewAbstract) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
        
            BaseSharedHeaderViewDetailsActions(
                tabController: _tabController, tabs: tabs),

            Divider(thickness: 1),
            BaseSharedHeaderDescription(viewAbstract: viewAbstract),
            // Expanded(
            //   child: TabBarView(controller: _tabController, children: [
            //     Container(
            //       color: Colors.red,
            //     ),
            //     // Container(
            //     //   color: Colors.orange,
            //     // ),
            //   ]),
            // ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     padding: const EdgeInsets.all(kDefaultPadding),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         CircleAvatar(
            //             maxRadius: 24,
            //             backgroundColor: Colors.transparent,
            //             child: viewAbstract.getCardLeadingImage(context)),
            //         const SizedBox(width: kDefaultPadding),
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 children: [
            //                   Expanded(
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text.rich(
            //                           TextSpan(
            //                             text: viewAbstract
            //                                 .getMainHeaderTextOnly(context),
            //                             style:
            //                                 Theme.of(context).textTheme.button,
            //                             children: [
            //                               TextSpan(
            //                                   text:
            //                                       "  <elvia.atkins@gmail.com> to Jerry Torp",
            //                                   style: Theme.of(context)
            //                                       .textTheme
            //                                       .caption),
            //                             ],
            //                           ),
            //                         ),
            //                         Text(
            //                           viewAbstract
            //                               .getMainHeaderLabelTextOnly(context),
            //                           style:
            //                               Theme.of(context).textTheme.headline6,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                   const SizedBox(width: kDefaultPadding / 2),
            //                   Text(
            //                     "Today at 15:32",
            //                     style: Theme.of(context).textTheme.caption,
            //                   ),
            //                 ],
            //               ),
            //               const SizedBox(height: kDefaultPadding),
            //               LayoutBuilder(
            //                 builder: (context, constraints) => SizedBox(
            //                   width: constraints.maxWidth > 850
            //                       ? 800
            //                       : constraints.maxWidth,
            //                   child: Expanded(
            //                       child: getBodyWidget(context, viewAbstract)),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget getViewLoop(List<String> fields, ViewAbstract viewAbstract) {
    return ViewDetailsListWidget(
      viewAbstract: viewAbstract,
    );
  }

  Widget getBodyWidget(BuildContext context, ViewAbstract viewAbstract) {
    return getViewLoop(viewAbstract.getMainFields(), viewAbstract);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hello my love, \n \nSunt architecto voluptatum esse tempora sint nihil minus incidunt nisi. Perspiciatis natus quo unde magnam numquam pariatur amet ut. Perspiciatis ab totam. Ut labore maxime provident. Voluptate ea omnis et ipsum asperiores laborum repellat explicabo fuga. Dolore voluptatem praesentium quis eos laborum dolores cupiditate nemo labore. \n \nLove you, \n\nElvia",
          style: TextStyle(
            height: 1.5,
            color: Color(0xFF4D5875),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        Row(
          children: [
            const Text(
              "6 attachments",
              style: TextStyle(fontSize: 12),
            ),
            const Spacer(),
            Text(
              "Download All",
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(width: kDefaultPadding / 4),
            const Icon(
              Icons.download,
              size: 16,
              color: kGrayColor,
            ),
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(height: kDefaultPadding / 2),
        // SizedBox(
        //   height: 200,
        //   child: StaggeredGrid.custom(
        //     physics: NeverScrollableScrollPhysics(),
        //     crossAxisCount: 4,
        //     itemCount: 3,
        //     itemBuilder:
        //         (BuildContext context, int index) =>
        //             ClipRRect(
        //       borderRadius:
        //           BorderRadius.circular(8),
        //       child: Image.asset(
        //         "assets/images/Img_$index.png",
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //     staggeredTileBuilder: (int index) =>
        //         StaggeredGridTile.count(
        //                 crossAxisCellCount: 2,
        //                 mainAxisCellCount: ,

        //       2,
        //       index.isOdd ? 2 : 1,
        //     ),
        //     mainAxisSpacing: kDefaultPadding,
        //     crossAxisSpacing: kDefaultPadding,
        //   ),
        // )
      ],
    );
  }
}
