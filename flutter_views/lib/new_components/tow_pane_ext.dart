import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/size_config.dart';

class TowPaneExt extends StatelessWidget {
  Widget startPane;
  Widget? endPane;
  double? customPaneProportion;
  TowPaneExt(
      {super.key,
      required this.startPane,
      this.endPane,
      this.customPaneProportion});

  @override
  Widget build(BuildContext context) {
    bool isSingleScreen = SizeConfig.isMobile(context);
    var panePriority = TwoPanePriority.both;
    if (isSingleScreen || endPane == null) {
      panePriority = TwoPanePriority.start;
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return TwoPane(
            // padding: EdgeInsets.only(
            //     top: kToolbarHeight + MediaQuery.of(context).padding.top),
            panePriority: panePriority,
            direction: orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            paneProportion: customPaneProportion ??
                SizeConfig.getPaneProportion(context, orientation: orientation),
            startPane: startPane,
            endPane: endPane ?? Text("its not going to be visible"));
      },
    );
  }
}
