import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/models/design_process.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'grid_view_api_category.dart';

final List<DesignProcess> designProcesses = [
  DesignProcess(
    title: "CUSTOMIZE",
    imageUrl: "https://saffoury.com/wp-content/uploads/imag02.jpg",
    iconData: Icons.design_services,
    subtitle:
        "Modify and design the product that suits the nature of your business.If u need to customize , the lead time about 25 work day\nIf customization is not required, the lead time about 7-10days.",
  ),
  DesignProcess(
    imageUrl: "https://saffoury.com/wp-content/uploads/cropped-imag01.jpg",
    title: "Restaurants and hotels".toUpperCase(),
    iconData: Icons.hotel_class,
    subtitle: "We have a special section for serving restaurants and hotels",
  ),
  DesignProcess(
    imageUrl: "https://saffoury.com/wp-content/uploads/toilet.jpg",
    title: "HAND PAPER TOWEL\nKITCHEN ROLL",
    iconData: Icons.restaurant_menu_rounded,
    subtitle:
        "Disposable hand drying paper, strong and tear resistant.\nBamboo fiber kitchen paper towel, makes your kitchen clean and health",
  ),
  DesignProcess(
    imageUrl: "https://saffoury.com/wp-content/uploads/cropped-new_jeeb2_b.gif",
    title: "Standard Pocket\nTissue".toUpperCase(),
    iconData: Icons.table_bar_rounded,
    subtitle: "Pereasy Soft Mini Pocket Tissue",
  ),
  DesignProcess(
    imageUrl:
        "https://saffoury.com/wp-content/uploads/67527369_2067570993548140_5540770736852959232_n.jpg",
    title: "QUALITY",
    iconData: Icons.high_quality,
    subtitle:
        "Saffoury products are the best quality products in the local market",
  ),
];

class CvSection extends StatelessWidget {
  const CvSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ScreenHelper(
        desktop: _buildUi(context, kDesktopMaxWidth),
        tablet: _buildUi(context, kTabletMaxWidth),
        mobile: _buildUi(context, getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    
    // we need the context to get maxWidth before the constraints below
    return MaxWidthBox (
      maxWidth: width,
      // minWidth: width,
      // defaultScale: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BETTER DESIGN,\nBETTER EXPERIENCES",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1.8,
                  fontSize: 18.0,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    "DOWNLOAD CV",
                    style: GoogleFonts.roboto(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return ResponsiveGridView.builder(
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                alignment: Alignment.topCenter,
                gridDelegate: ResponsiveGridDelegate(
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  maxCrossAxisExtent: ScreenHelper.isTablet(context) ||
                          ScreenHelper.isMobile(context)
                      ? constraints.maxWidth / 2.0
                      : 250.0,
                  // Hack to adjust child height
                  childAspectRatio: ScreenHelper.isDesktop(context)
                      ? 1
                      : MediaQuery.of(context).size.aspectRatio * 1.5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var designProcesse = designProcesses[index];
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            designProcesse.getImage(),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              designProcesse.title,
                              style: GoogleFonts.roboto(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          designProcesse.subtitle,
                          style: const TextStyle(
                            color: kCaptionColor,
                            height: 1.5,
                            fontSize: 14.0,
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: designProcesses.length,
              );
            },
          )
        ],
      ),
    );
  }
}

class ProductQualityWebSection extends StatelessWidget {
  const ProductQualityWebSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ScreenHelper(
        desktop: _buildUi(context, kDesktopMaxWidth),
        tablet: _buildUi(context, kTabletMaxWidth),
        mobile: _buildUi(context, getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    // we need the context to get maxWidth before the constraints below
    return MaxWidthBox(
      maxWidth: width,
      // minWidth: width,
      // defaultScale: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   "BETTER DESIGN,\nBETTER EXPERIENCES",
              //   style: GoogleFonts.roboto(
              //     color: Colors.white,
              //     fontWeight: FontWeight.w900,
              //     height: 1.8,
              //     fontSize: 18.0,
              //   ),
              // ),
              GestureDetector(
                onTap: () {},
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    "",
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          // Wrap(
          //     spacing: 20.0,
          //     runSpacing: 20.0,
          //     children: designProcesses.map((e) => getItem(e)).toList()),
          LayoutBuilder(
            builder: (context, constraints) {
              return StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: getGridViewItemCustom(designProcesses[0])),
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: getGridViewItemCustom(designProcesses[1])),
                  StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: getGridViewItemCustom(designProcesses[2])),
                  StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: getGridViewItemCustom(designProcesses[3])),
                  StaggeredGridTile.count(
                      crossAxisCellCount: 4,
                      mainAxisCellCount: 2,
                      child: getGridViewItemCustom(designProcesses[4])),
                ],
              );

              return ResponsiveGridView.builder(
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                alignment: Alignment.topCenter,
                gridDelegate: ResponsiveGridDelegate(
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  maxCrossAxisExtent: ScreenHelper.isTablet(context) ||
                          ScreenHelper.isMobile(context)
                      ? constraints.maxWidth / 2
                      : 250.0,
                  // Hack to adjust child height
                  childAspectRatio: ScreenHelper.isDesktop(context) ? 1 : 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var designProcesse = designProcesses[index];
                  return getGridViewItemCustom(designProcesse);

                  // getItem(designProcesse);
                },
                itemCount: designProcesses.length,
              );
            },
          )
        ],
      ),
    );
  }

  WebGridViewItemCustom getGridViewItemCustom(DesignProcess designProcesse) {
    return WebGridViewItemCustom(
      paddingToInside: true,
      showChildOnHoverOnly: true,
      roundedCorners: false,
      imageUrl: designProcesse.imageUrl,
      title: getItemTitle(designProcesse),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Text(
          textAlign: TextAlign.center,
          designProcesse.subtitle,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
            fontSize: 14.0,
          ),
        ),
      )),
    );
  }

  Widget getItemForGrid(DesignProcess designProcesse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getItemTitle(designProcesse),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          designProcesse.subtitle,
          style: const TextStyle(
            color: kCaptionColor,
            height: 1.5,
            fontSize: 14.0,
          ),
        )
      ],
    );
  }

  Row getItemTitle(DesignProcess designProcesse) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        designProcesse.getImage(),
        const SizedBox(
          width: 15.0,
        ),
        Text(
          designProcesse.title,
          style: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget getItem(DesignProcess designProcesse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            designProcesse.getImage(),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              designProcesse.title,
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          designProcesse.subtitle,
          style: const TextStyle(
            color: kCaptionColor,
            height: 1.5,
            fontSize: 14.0,
          ),
        )
      ],
    );
  }
}
