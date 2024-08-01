import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/cupertino.dart';
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
    if (endPane == null) {
      return startPane;
    }
    bool isSingleScreen = !SizeConfig.isLargeScreen(context);
    var panePriority = TwoPanePriority.both;
    if (isSingleScreen || endPane == null) {
      panePriority = TwoPanePriority.start;
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return TwoPane(
            allowedOverrides: const {
              TwoPaneAllowedOverrides.paneProportion,
              TwoPaneAllowedOverrides.direction,
              // TwoPaneAllowedOverrides.direction,
              TwoPaneAllowedOverrides.panePriority,
            },
            // padding: EdgeInsets.only(
            //     top: kToolbarHeight + MediaQuery.of(context).padding.top),
            panePriority: panePriority,
            direction: orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.horizontal,
            paneProportion: customPaneProportion ??
                SizeConfig.getPaneProportion(context, orientation: orientation),
            startPane: startPane,
            endPane: endPane ?? const Text("its not going to be visible"));
      },
    );
  }
}
