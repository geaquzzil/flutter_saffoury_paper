import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';

class FilterIcon extends StatelessWidget {
  ViewAbstract viewAbstract;
  Function(dynamic value)? onDoneClickedPopResults;
  FilterIcon(
      {super.key, required this.viewAbstract, this.onDoneClickedPopResults});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_alt_rounded),
      onPressed: () async {
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
