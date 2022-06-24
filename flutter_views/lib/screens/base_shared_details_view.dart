import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_header.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BaseSharedDetailsView extends StatelessWidget {
  BaseSharedDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: getBodyView(context),
    // );
    return Scaffold(
        body: context.watch<ActionViewAbstractProvider>().getObject == null
            ? getEmptyView(context)
            : getBodyView(context));
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets3.lottiefiles.com/private_files/lf30_gctc76jz.json"),
    );
  }

  Widget getBodyView(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            BaseSharedHeader(),
            Divider(thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("emails[1].image"),
                    ),
                    SizedBox(width: kDefaultPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: "emails[1].name",
                                        style:
                                            Theme.of(context).textTheme.button,
                                        children: [
                                          TextSpan(
                                              text:
                                                  "  <elvia.atkins@gmail.com> to Jerry Torp",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Inspiration for our new home",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: kDefaultPadding / 2),
                              Text(
                                "Today at 15:32",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          SizedBox(height: kDefaultPadding),
                          LayoutBuilder(
                            builder: (context, constraints) => SizedBox(
                              width: constraints.maxWidth > 850
                                  ? 800
                                  : constraints.maxWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello my love, \n \nSunt architecto voluptatum esse tempora sint nihil minus incidunt nisi. Perspiciatis natus quo unde magnam numquam pariatur amet ut. Perspiciatis ab totam. Ut labore maxime provident. Voluptate ea omnis et ipsum asperiores laborum repellat explicabo fuga. Dolore voluptatem praesentium quis eos laborum dolores cupiditate nemo labore. \n \nLove you, \n\nElvia",
                                    style: TextStyle(
                                      height: 1.5,
                                      color: Color(0xFF4D5875),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: kDefaultPadding),
                                  Row(
                                    children: [
                                      Text(
                                        "6 attachments",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Download All",
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      SizedBox(width: kDefaultPadding / 4),
                                      Icon(
                                        Icons.download,
                                        size: 16,
                                        color: kGrayColor,
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 1),
                                  SizedBox(height: kDefaultPadding / 2),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
