import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class ProductWebPage extends BaseWebPage {
  const ProductWebPage({Key? key}) : super(key: key);

  @override
  Widget? getContentWidget(BuildContext context) {
    // return Expanded(
    //   child: ResponsiveGridList(
    //     horizontalGridMargin: 50,
    //     verticalGridMargin: 50,
    //     minItemWidth: 100,
    //     children: List.generate(
    //       100,
    //       (index) => ColoredBox(
    //         color: Colors.lightBlue,
    //         child: Padding(
    //           padding: const EdgeInsets.all(32),
    //           child: Text(
    //             '$index',
    //             textAlign: TextAlign.center,
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenHelper(
          desktop: _buildUi(kDesktopMaxWidth),
          tablet: _buildUi(kTabletMaxWidth),
          mobile: _buildUi(getMobileMaxWidth(context)),
        )
      ],
    );
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
                  Expanded(
                      flex: constraints.maxWidth > 720.0 ? 1 : 0,
                      child: Center(child: Text("start"))),
                  Divider(),

                  // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                  Expanded(
                    flex: constraints.maxWidth > 720.0 ? 6 : 0,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: ResponsiveGridList(
                        horizontalGridMargin: 50,
                        verticalGridMargin: 50,
                        
                        minItemWidth: 200,
                        children: List.generate(
                          100,
                          (index) => ColoredBox(
                            color: Colors.lightBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                '$index',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Expanded(
                      flex: constraints.maxWidth > 720.0 ? 1 : 0,
                      child: Center(child: Text("END"))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
