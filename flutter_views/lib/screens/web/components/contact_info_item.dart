import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/about-us.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ContactInfoItemWidget extends StatelessWidget {
  final ContactItem contactInfo;
  const ContactInfoItemWidget({super.key, required this.contactInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenHelper(
          desktop: _buildUi(kDesktopMaxWidth),
          tablet: _buildUi(kTabletMaxWidth),
          mobile: _buildUi(getMobileMaxWidth(context)),
        ),
      ],
    );
  }

  Widget _buildUi(double width) {
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint("ContactInfoMaxWidth = ${constraints.maxWidth}");
        if (constraints.maxWidth > 500) {
          return contactInfo.getContactWidget(context);
        }
        return ResponsiveWrapper(
          maxWidth: width,
          minWidth: width,
          defaultScale: false,
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            direction:
                constraints.maxWidth >= 450 ? Axis.horizontal : Axis.vertical,
            children: [
              contactInfo.getLeading(),
              Expanded(
                  flex: constraints.maxWidth >= 720 ? 1 : 0,
                  child: contactInfo.getTitle()),
              Expanded(
                  flex: constraints.maxWidth >= 720 ? 1 : 0,
                  child: contactInfo.getTrailing()),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }
}
