import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/components/web_button.dart';
import 'package:flutter_view_controller/screens/web/models/education.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

final List<Education> educationList = [
  Education(
    description:
        "This is a sample education and details about it is stated below. This is a sample education and details about it is stated below",
    linkName: "www.flutterpanda.com",
    period: "2019 - PRESENT",
  ),
  Education(
    description:
        "This is a sample education and details about it is stated below.This is a sample education and details about it is stated below",
    linkName: "www.flutterpanda.com",
    period: "2018 - 2019",
  ),
  Education(
    description:
        "This is a sample education and details about it is stated below. This is a sample education and details about it is stated below",
    linkName: "www.flutterpanda.com",
    period: "2017 - 2018",
  ),
  Education(
    description:
        "This is a sample education and details about it is stated below. This is a sample education and details about it is stated below",
    linkName: "www.flutterpanda.com",
    period: "2016 - 2017",
  ),
];
final List<Education> historyList = [
  Education(
    description:
        "`Saffoury` celebrates another factory location in Chtoura - Lebanon ",
    // linkName: "www.flutterpanda.com",
    period: "2020 - PRESENT",
  ),
  Education(
    description:
        "`Saffoury` Company established another factory for tissues manufacturer in `Dubai - United Arab Emirates`, which makes the company's expertise match the global expertise in the tissue industry",
    // linkName: "www.flutterpanda.com",
    period: "2010 - 2014",
  ),
  Education(
    description:
        "The company opened a paper and cardboard trading center under the name of `SaffouryPaper`",
    period: "2008 - PRESENT",
  ),
  Education(
    description:
        "`Saffoury` started exporting some products to neighboring countries such as\nJordan, Iraq, Lebanon",
    period: "2000 - PRESENT",
  ),
  Education(
    description:
        "`Saffoury` release over 10+ products to all Syrian governorates, making it the best tissue manufacturer in the entire region",
    // linkName: "www.flutterpanda.com",
    period: "1995",
  ),
  Education(
    description:
        "`Saffoury` celebrates its first factory location in Damascus - Syria",
    // linkName: "www.flutterpanda.com",
    period: "1990 - PRESENT",
  ),
];

class EducationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth),
        tablet: _buildUi(kTabletMaxWidth),
        mobile: _buildUi(getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(double width) {
    return Container(
      alignment: Alignment.center,
      child: ResponsiveWrapper(
        maxWidth: width,
        minWidth: width,
        defaultScale: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "EDUCATION",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30.0,
                height: 1.3,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Wrap(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: const Text(
                    "A full stack all round developer that does all the job he needs to do at all times. Actually this is a false statement",
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: educationList
                        .map(
                          (education) => SizedBox(
                            width: constraints.maxWidth / 2.0 - 20.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  education.period,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  education.description,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: kCaptionColor,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                if (education.linkName != null)
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        education.linkName!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 40.0,
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth),
        tablet: _buildUi(kTabletMaxWidth),
        mobile: _buildUi(getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(double width) {
    return Container(
      alignment: Alignment.center,
      child: ResponsiveWrapper(
        maxWidth: width,
        minWidth: width,
        defaultScale: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "OUR HISTORY",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30.0,
                height: 1.3,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Wrap(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: const Text(
                    "We were founded in 1990, and our first overseas offices opened in 2000, making us the oldest company in Syria",
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: historyList
                        .map(
                          (education) => SizedBox(
                            width: constraints.maxWidth / 2.0 - 20.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  education.period,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  education.description,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: kCaptionColor,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                if (education.linkName != null)
                                  WebButton(
                                      primary: false, title: "EXPLORE MORE"),
                                // MouseRegion(
                                //   cursor: SystemMouseCursors.click,
                                //   child: GestureDetector(
                                //     onTap: () {},
                                //     child: Text(
                                //       education.linkName!,
                                //       style: const TextStyle(
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 40.0,
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
