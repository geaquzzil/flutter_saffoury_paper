import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ChartDateChooser<T extends ViewAbstractEnum> extends StatefulWidget {
  T obj;
  Widget Function(T? obj) onSelected;

  ChartDateChooser({super.key, required this.obj, required this.onSelected});

  @override
  State<ChartDateChooser> createState() => _ChartDateChooserState<T>();
}

class _ChartDateChooserState<T extends ViewAbstractEnum>
    extends State<ChartDateChooser<T>> {
  Widget? selectedObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: DropdownEnumControllerListener<T>(
              viewAbstractEnum: widget.obj,
              onSelected: (object) {
                setState(() {
                  selectedObj = widget.onSelected(object);
                });
              },
            ),
          ),
          Expanded(
            // height: 200,
            // width: 200,
            child: selectedObj == null
                ? EmptyWidget(
                    lottiUrl:
                        "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json",
                    title: AppLocalizations.of(context)!.noItems,
                    subtitle: AppLocalizations.of(context)!.error_empty)
                : selectedObj!,
          )
        ],
      ),
    );
  }
}
