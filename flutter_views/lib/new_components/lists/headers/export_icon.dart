import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

///first is! ExcelableReaderInterace && first is! PrintableMaster
class ExportIcon extends StatefulWidget {
  final ViewAbstract viewAbstract;

  final List<ViewAbstract>? list;
    final ValueNotifier<SecondPaneHelper?>? secPaneNotifer;
  const ExportIcon({super.key, required this.viewAbstract, this.list,this.secPaneNotifer});

  @override
  State<ExportIcon> createState() => _ExportIconState();
}

class _ExportIconState extends State<ExportIcon> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return DropdownStringListControllerListenerByIcon(
      icon: Icons.file_upload_outlined,
      hint: AppLocalizations.of(context)!.exportAll,
      showSelectedValueBeside: false,
      isLoading: isLoading,
      list: [
        DropdownStringListItem(
            icon: Icons.picture_as_pdf,
            label: AppLocalizations.of(context)!
                .exportAllAs(AppLocalizations.of(context)!.pdf)),
        DropdownStringListItem(
            icon: Icons.source,
            label: AppLocalizations.of(context)!
                .exportAllAs(AppLocalizations.of(context)!.excel)),
      ],
      onSelected: (object) async {
        if (object?.label ==
            AppLocalizations.of(context)!
                .exportAllAs(AppLocalizations.of(context)!.excel)) {
          widget.viewAbstract.exportPage(context, asList: widget.list);
        } else {
          setState(() {
            isLoading = true;
          });

          var pdfList = PDFListApi(
              list: widget.list!.whereType<PrintableMaster>().toList(),
              context: context,
              setting: await getSetting(
                  context, widget.viewAbstract as PrintableMaster));
          var data = await pdfList.generate(PdfPageFormat.a4);
          setState(() {
            isLoading = false;
          });
          Printing.sharePdf(
              emails: ["paper@saffoury.com"],
              filename: widget.viewAbstract.getMainHeaderLabelTextOnly(context),
              subject: widget.viewAbstract.getMainHeaderLabelTextOnly(context),
              bytes: data);
        }
      },
    );
  }
}
