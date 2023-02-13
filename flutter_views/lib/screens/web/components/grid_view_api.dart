import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/models/design_process.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

final List<DesignProcess> designProcesses = [
  DesignProcess(
    title: "DESIGN",
    iconData: Icons.design_services,
    subtitle:
        "A full stack allround designer thay may or may not include a guide for specific creative",
  ),
  DesignProcess(
    title: "DEVELOP",
    iconData: Icons.developer_board,
    subtitle:
        "A full stack allround developer thay may or may not include a guide for specific creative",
  ),
  DesignProcess(
    title: "QUALITY",
    iconData: Icons.high_quality,
    subtitle:
        "A full stack allround writer thay may or may not include a guide for specific creative",
  ),
  DesignProcess(
    title: "PROMOTE",
    iconData: Icons.high_quality,
    subtitle:
        "A full stack allround promoter thay may or may not include a guide for specific creative",
  ),
  DesignProcess(
    title: "PROMOTE",
    iconData: Icons.high_quality,
    subtitle:
        "A full stack allround promoter thay may or may not include a guide for specific creative",
  ),
];

class GridViewApi extends StatelessWidget {
  final ViewAbstract? viewAbstract;
  final String? title;
  final String? description;
  ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(false);
  GridViewApi({Key? key, this.viewAbstract, this.title, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(
      onHover: valueNotifier,
      builder: (isHover) {
        return AspectRatio(
          aspectRatio: 8 / 3,
          child: Stack(children: [
            ValueListenableBuilder<bool>(
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                return Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: double.infinity,
                        child: value == false
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            size: 100,
                                            Icons.arrow_back_ios_new_sharp)),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            size: 100,
                                            Icons.arrow_forward_ios_sharp)),
                                  ],
                                ),
                              )),
                  ),
                );
              },
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: ScreenHelper(
                    desktop: _buildUi(context, kDesktopMaxWidth),
                    tablet: _buildUi(context, kTabletMaxWidth),
                    mobile: _buildUi(context, getMobileMaxWidth(context)),
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    debugPrint("GridViewApi is building");
    // we need the context to get maxWidth before the constraints below
    return ResponsiveWrapper(
      maxWidth: width,
      minWidth: width,
      defaultScale: false,
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
              return FutureBuilder(
                future: viewAbstract.lis,
                child: ResponsiveGridView.builder(
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
                    return Stack(
                      children: [
                        _buildParallaxBackground(context),
                        if (customCenterWidget == null) _buildGradient(),
                        if (customCenterWidget == null) _buildTitleAndSubtitle(),
                        if (customCenterWidget != null)
                          _buildCenterWidget(context)
                      ],
                    );
                  },
                  itemCount: designProcesses.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class WebGridViewItem extends StatelessWidget {
  final ViewAbstract item;
  late WebCategoryGridableInterface _categoryGridable;

  WebGridViewItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    _categoryGridable = item as WebCategoryGridableInterface;
    return Stack(
      children: [
        _buildBackground(context),
        _buildGradient(),
        _buildTitleAndSubtitle(context),
        // _buildCenterWidget(context)
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Positioned.fill(child: item.getCardLeading(context));
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.getMainHeaderTextOnly(context),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item.getMainHeaderLabelTextOnly(context),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
