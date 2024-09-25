import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_popup_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_header_description.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class BaseSharedHeaderViewDetailsActions extends StatelessWidget {
  ViewAbstract viewAbstract;

  BaseSharedHeaderViewDetailsActions({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              children: [
                if (SizeConfig.isSoLargeScreen(context) &&
                    (context
                            .read<ActionViewAbstractProvider>()
                            .getStackedActions
                            .length >
                        3))
                  BackButton(
                    onPressed: () {
                      if (context
                              .read<ActionViewAbstractProvider>()
                              .getStackedActions
                              .length >
                          1) {
                        context.read<ActionViewAbstractProvider>().pop();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                // else
                //   BackButton(
                //     onPressed: () {
                //       if (context
                //               .read<ActionViewAbstractProvider>()
                //               .getStackedActions
                //               .length >
                //           1) {
                //         context.read<ActionViewAbstractProvider>().pop();
                //       } else {
                //         Navigator.of(context).pop();
                //       }
                //     },
                //   ),
                Expanded(
                    child: BaseSharedHeaderDescription(
                        viewAbstract: viewAbstract)),
                ActionsOnHeaderWidget(viewAbstract: viewAbstract),
                ActionsOnHeaderPopupWidget(viewAbstract: viewAbstract),
              ],
            ),
          ),
        ),

        // BaseSharedHeaderDescription(viewAbstract: viewAbstract),
        // BaseSharedDetailsRating(viewAbstract: viewAbstract),
        // const BaseSharedActionDrawerNavigation()
      ],
    );
  }
}
