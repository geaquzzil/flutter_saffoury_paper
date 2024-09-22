import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/customs_widget/popup_widget.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/popup_widget.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';

import 'package:badges/badges.dart' as badges;

class FilterIcon extends StatelessWidget {
  ViewAbstract viewAbstract;
  Map<String, FilterableProviderHelper>? initialData;

  ///return result could be true for deleteing initialData;
  ///false for dismissing initial
  ///list of initial if submitting
  Function(dynamic value)? onDoneClickedPopResults;
  FilterIcon(
      {super.key,
      required this.viewAbstract,
      this.onDoneClickedPopResults,
      this.initialData});

  @override
  Widget build(BuildContext context) {
    // if (isLargeScreenFromCurrentScreenSize(context)) {
    //   return PopupWidgetBuilder(
    //     builder: BaseFilterableMainWidget(
    //       viewAbstract: viewAbstract,
    //     ),
    //     icon: Icons.filter_alt_rounded,
    //   );
    // }
    debugPrint("FilterIcon $initialData");
    return IconButton(
      icon: badges.Badge(
          badgeStyle: badges.BadgeStyle(
            shape: badges.BadgeShape.circle,
            borderRadius: BorderRadius.circular(20),
            badgeColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
          ),
          showBadge: initialData != null && initialData?.isNotEmpty == true,
          badgeAnimation: const badges.BadgeAnimation.scale(
            animationDuration: Duration(milliseconds: 200),
            toAnimate: true,
            disappearanceFadeAnimationDuration: Duration(milliseconds: 100),
          ),
          child: const Icon(Icons.filter_alt_rounded)),
      onPressed: () async {
        await showBottomSheetExt(
          isScrollable: true,
          withHeightFactor: false,
          
          context: context,
          builder: (p0) {
            return BaseFilterableMainWidget(
              initialData: initialData,
              viewAbstract: viewAbstract,
            );
          },
        ).then(
          (value) {
            debugPrint("dsadasdsa $value");
            onDoneClickedPopResults?.call(value);
          },
        );
        return;
        if (isMobile(context)) {
          await showBottomSheetExt(
            isScrollable: true,
            withHeightFactor: false,
            context: context,
            builder: (p0) {
              return BaseFilterableMainWidget(
                viewAbstract: viewAbstract,
              );
            },
          ).then(
            (value) {},
          );
        } else {
          await showFullScreenDialogExt<ViewAbstract?>(
              anchorPoint: const Offset(1000, 1000),
              context: context,
              builder: (p0) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    // color: Theme.of(context).colorScheme.secondaryContainer,
                    child: IntrinsicWidth(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              (isTablet(context) ? 0.5 : 0.25),
                          height: MediaQuery.of(context).size.height * .8,
                          child: BaseFilterableMainWidget(
                            viewAbstract: viewAbstract,
                          )),
                    ),
                  ),
                );
              }).then((value) {
            {
              if (value != null) {}
              debugPrint("getEditDialog result $value");
            }
          });
        }
        // Navigator.pushNamed(context, "/search");
      },
    );
  }
}
