import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/base_controller_with_save_state.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:pdf/pdf.dart';

class PaperListController extends BaseWidgetControllerWithSave<PdfPageFormat> {
  final bool supportsLabelPrinting;
  const PaperListController(
      {super.key,
      required this.supportsLabelPrinting,
      super.initialValue,
      super.onValueSelectedFunction});

  @override
  State<PaperListController> createState() => _PaperListControllerState();
}

class _PaperListControllerState extends State<PaperListController>
    with BaseWidgetControllerWithSaveState<PdfPageFormat, PaperListController> {
  @override
  Widget build(BuildContext context) {
    return DropdownStringListControllerListener(
      initialValue: initialValue == null
          ? null
          : DropdownStringListItem(
              label: getLabelFromPDF(initialValue!), value: initialValue!),
      insetFirstIsSelect: false,
      tag: "printOptions",
      onValueSelectedFunction: (object) {
        notifyValueSelected(object?.value as PdfPageFormat?);
      },
      //todo translate
      hint: "Select size",
      list: [
        if (widget.supportsLabelPrinting)
          DropdownStringListItem(
              //todo translate
              label: getAppLocal(context)!.productLabel,
              value: roll80),
        DropdownStringListItem(
            label: getAppLocal(context)!.a3ProductLabel,
            value: PdfPageFormat.a3),
        DropdownStringListItem(
            label: getAppLocal(context)!.a4ProductLabel,
            value: PdfPageFormat.a4),
        DropdownStringListItem(
            label: getAppLocal(context)!.a5ProductLabel,
            value: PdfPageFormat.a5),
      ],
    );
  }

  String getLabelFromPDF(PdfPageFormat format) {
    if (format == PdfPageFormat.a4) {
      return getAppLocal(context)!.a4ProductLabel;
    } else if (format == PdfPageFormat.a3) {
      return getAppLocal(context)!.a3ProductLabel;
    } else if (format == PdfPageFormat.a5) {
      return getAppLocal(context)!.a5ProductLabel;
    } else {
      return getAppLocal(context)!.productLabel;
    }
  }
}
