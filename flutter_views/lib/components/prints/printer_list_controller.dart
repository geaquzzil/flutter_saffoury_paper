import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/base_controller_with_save_state.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_components/lists/skeletonizer/widgets.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:printing/printing.dart';

class PrinterListControllerDropdown
    extends BaseWidgetControllerWithSave<Printer> {
  const PrinterListControllerDropdown(
      {super.key, super.initialValue, super.onValueSelectedFunction});

  @override
  State<PrinterListControllerDropdown> createState() =>
      _PrinterListControllerDropdownState();
}

class _PrinterListControllerDropdownState
    extends State<PrinterListControllerDropdown>
    with
        BaseWidgetControllerWithSaveState<Printer,
            PrinterListControllerDropdown> {
  List<Printer>? _loadedPrinters;
  Printer? getDefaultPrinter() {
    return _loadedPrinters.firstWhereOrNull((o) => o.isDefault == true);
  }

  Widget getPrintersWidget() {
    if (_loadedPrinters != null) {
      return getPrintersWidgetController(context, _loadedPrinters);
    }
    return FutureBuilder<List<Printer>>(
        future: Printing.listPrinters(),
        builder: (context, as) {
          if (as.connectionState == ConnectionState.waiting ||
              as.data == null) {
            return SkeletonListTile(
              hasLeading: false,
            );
          }

          _loadedPrinters = as.data!;
          initialValue = initialValue ?? getDefaultPrinter();
          return getPrintersWidgetController(context, as.data);
        });
  }

  ListTileSameSizeOnTitle getPrintersWidgetController(
      BuildContext context, List<Printer>? as) {
    return ListTileSameSizeOnTitle(
      leading: Text(getAppLocal(context)?.printerName ?? ""),
      title: DropdownStringListControllerListener(
        initialValue: initialValue == null
            ? null
            : DropdownStringListItem(
                label: initialValue!.name, value: initialValue),
        insetFirstIsSelect: false,
        onValueSelectedFunction: (object) {
          // initialValue = object?.value as Printer?;
          notifyValueSelected(object?.value as Printer?);
        },
        hint: "Hist",
        list: as
                ?.map((e) => DropdownStringListItem(value: e, label: e.name))
                .toList() ??
            [],
        tag: 'printerList',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getPrintersWidget();
  }
}
