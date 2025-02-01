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
      initialValue: DropdownStringListItem(
          label: getLabelFromPDF(initialValue ?? PdfPageFormat.a4)),
      insetFirstIsSelect: false,
      tag: "printOptions",
      onValueSelectedFunction: (object) {
        if (object != null) {
          PdfPageFormat chosedPageFormat;
          if (object.label == getAppLocal(context)!.a3ProductLabel) {
            chosedPageFormat = PdfPageFormat.a3;
          } else if (object.label == getAppLocal(context)!.a4ProductLabel) {
            chosedPageFormat = PdfPageFormat.a4;
          } else if (object.label == getAppLocal(context)!.a5ProductLabel) {
            chosedPageFormat = PdfPageFormat.a5;
          } else {
            //todo translate
            if (widget.supportsLabelPrinting) {
              chosedPageFormat = roll80;
            } else {
              chosedPageFormat = PdfPageFormat.a4;
            }
          }
          if (chosedPageFormat == initialValue) return;
          notifyValueSelected(chosedPageFormat);
        }
      },
      //todo translate
      hint: "Select size",
      list: [
        if (widget.supportsLabelPrinting)
          DropdownStringListItem(
              icon: null,
              //todo translate
              label: getAppLocal(context)!.productLabel),
        DropdownStringListItem(
            icon: null, label: getAppLocal(context)!.a3ProductLabel),
        DropdownStringListItem(
            icon: null, label: getAppLocal(context)!.a4ProductLabel),
        DropdownStringListItem(
            icon: null, label: getAppLocal(context)!.a5ProductLabel),
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
