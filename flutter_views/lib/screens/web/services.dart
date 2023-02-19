import 'package:flutter/material.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/parallex/parallexes.dart';

import 'components/title_and_image_left.dart';

class ServicesWebPage extends BaseWebPageSlivers {
  ServicesWebPage({Key? key}) : super(key: key);

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      SliverToBoxAdapter(
        child: LocationListItem(
          usePadding: false,
          useClipRect: false,
          useResponsiveLayout: false,
          country: "",
          name: "",
          customBottomWidget: SizedBox(
            height: MediaQuery.of(context).size.height * .2,
            child: Lottie.network(
                "https://assets7.lottiefiles.com/packages/lf20_jodo00xd.json"),
          ),
          imageUrl:
              "https://saffoury.com/wp-content/uploads/2022/05/center_15.jpg",
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(height: 70),
      ),
      SliverToBoxAdapter(
        child: TitleAndDescriptopnAndImageLeft(
          primaryTitle: "IOS APP",
          title: "UNIVERSAL\nSMART HOME APP",
          description:
              "This is a random text about the project, I should have used the regular lorem ipsum text, but I am too lazy to search for that. This should be long enough",
          customIconData: Icons.play_arrow,
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(height: 70),
      ),
      SliverToBoxAdapter(
        child: TitleAndDescriptopnAndImageLeft(
          primaryTitle: "IOS APP",
          title: "UNIVERSAL\nSMART HOME APP",
          description:
              "This is a random text about the project, I should have used the regular lorem ipsum text, but I am too lazy to search for that. This should be long enough",
          customIconData: Icons.play_arrow,
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(height: 70),
      ),
      SliverToBoxAdapter(
        child: TitleAndDescriptopnAndImageLeft(
          primaryTitle: "IOS APP",
          title: "UNIVERSAL\nSMART HOME APP",
          description:
              "This is a random text about the project, I should have used the regular lorem ipsum text, but I am too lazy to search for that. This should be long enough",
          customIconData: Icons.play_arrow,
        ),
      )
    ];
  }
}
