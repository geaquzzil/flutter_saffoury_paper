import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/components/carousel_items.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Carousel extends StatelessWidget {
  final CarouselSliderController carouselController = CarouselSliderController();

  Carousel({super.key});
  @override
  Widget build(BuildContext context) {
    double carouselContainerHeight = MediaQuery.of(context).size.height *
        (SizeConfig.isMobile(context) ? .7 : .85);
    return SizedBox(
      height: carouselContainerHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                // autoPlay: true,
                viewportFraction: 1,
                scrollPhysics: const NeverScrollableScrollPhysics(),
                height: carouselContainerHeight,
              ),
              items: List.generate(
                carouselItems.length,
                (index) => Builder(
                  builder: (BuildContext context) {
                    return Container(
                      constraints: BoxConstraints(
                        minHeight: carouselContainerHeight,
                      ),
                      child: ScreenHelper(
                        // Responsive views
                        largeTablet: _buildDesktop(
                          context,
                          carouselItems[index].text,
                          carouselItems[index].image,
                        ),
                        smallTablet: _buildTablet(
                          context,
                          carouselItems[index].text,
                          carouselItems[index].image,
                        ),
                        mobile: _buildMobile(
                          context,
                          carouselItems[index].text,
                          carouselItems[index].image,
                        ),
                      ),
                    );
                  },
                ),
              ).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// Big screens
Widget _buildDesktop(BuildContext context, Widget text, Widget image) {
  return Center(
    child: ResponsiveScaledBox(
      width: kDesktopMaxWidth,

      // minWidth: kDesktopMaxWidth,
      // defaultScale: false,
      child: Row(
        children: [
          Expanded(
            child: text,
          ),
          Expanded(
            child: image,
          )
        ],
      ),
    ),
  );
}

// Mid screens
Widget _buildTablet(BuildContext context, Widget text, Widget image) {
  return Center(
    child: ResponsiveScaledBox(
      width: kTabletMaxWidth,
      // minWidth: kTabletMaxWidth,
      // defaultScale: false,
      child: Row(
        children: [
          Expanded(
            child: text,
          ),
          Expanded(
            child: image,
          )
        ],
      ),
    ),
  );
}

// SMall Screens

Widget _buildMobile(BuildContext context, Widget text, Widget image) {
  return Container(
    constraints: BoxConstraints(
      maxWidth: getMobileMaxWidth(context),
    ),
    width: double.infinity,
    child: text,
  );
}
