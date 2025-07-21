import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_list_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class PrintIcon extends StatefulWidget {
  final ViewAbstract viewAbstract;
  final List? list;
  final SecoundPaneHelperWithParentValueNotifier? state;
  const PrintIcon({
    super.key,
    required this.viewAbstract,
    this.list,
    this.state,
  });

  @override
  State<PrintIcon> createState() => _PrintIconState();
}

class _PrintIconState extends State<PrintIcon> {
  @override
  Widget build(BuildContext context) {
    String? printListSetting =
        "${AppLocalizations.of(context)!.printAllAs(AppLocalizations.of(context)!.list)} ${AppLocalizations.of(context)!.action_settings.toLowerCase()}";

    String? printSelfListSetting =
        "${AppLocalizations.of(context)!.printAllAs(widget.viewAbstract.getMainHeaderLabelTextOnly(context))} ${AppLocalizations.of(context)!.action_settings.toLowerCase()}";
    if (widget.viewAbstract is PrintableSelfListInterface &&
        widget.viewAbstract is PrintableMaster) {
      return DropdownStringListControllerListenerByIcon(
        icon: Icons.print,
        showSelectedValueBeside: false,
        hint: AppLocalizations.of(context)!.printType,
        list: [
          DropdownStringListItem(
            icon: Icons.print,
            label: AppLocalizations.of(
              context,
            )!.printAllAs(AppLocalizations.of(context)!.list),
          ),
          DropdownStringListItem(
            icon: Icons.print,
            label: AppLocalizations.of(context)!.printAllAs(
              widget.viewAbstract
                  .getMainHeaderLabelTextOnly(context)
                  .toLowerCase(),
            ),
          ),
          // DropdownStringListItem(
          //     icon: Icons.settings,
          //     enabled: false,
          //     label: AppLocalizations.of(context)!.printerSetting),
          // DropdownStringListItem(icon: Icons.settings, label: printListSetting),
          // DropdownStringListItem(
          //     icon: Icons.settings, label: printSelfListSetting),
        ],
        onSelected: (object) {
          if (object?.label ==
              AppLocalizations.of(
                context,
              )!.printAllAs(AppLocalizations.of(context)!.list)) {
            widget.viewAbstract.printPage(
              context,
              list: widget.list!.cast(),
              isSelfListPrint: false,
              secPaneNotifer: widget.state,
            );
          } else {
            widget.viewAbstract.printPage(
              context,
              list: widget.list!.cast(),
              isSelfListPrint: true,
              secPaneNotifer: widget.state,
            );
          }
        },
      );
    }
    if (widget.viewAbstract is PrintableMaster) {
      return IconButton(
        onPressed: () {
          widget.viewAbstract.printPage(
            context,
            list: widget.list!.cast(),
            isSelfListPrint: false,
            secPaneNotifer: widget.state,
          );
        },
        icon: const Icon(Icons.print),
      );
    } else if (widget.viewAbstract is PrintableSelfListInterface) {
      return IconButton(
        onPressed: () {
          widget.viewAbstract.printPage(
            context,
            list: widget.list!.cast(),
            isSelfListPrint: true,
            secPaneNotifer: widget.state,
          );
        },
        icon: const Icon(Icons.print),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // void changeToPrintPdfList(BuildContext context) {
  //   context.read<ActionViewAbstractProvider>().changeCustomWidget(PdfListPage(
  //       list: listProvider
  //           .getList(findCustomKey())
  //           .whereType<PrintableMaster>()
  //           .toList()));
  // }

  // void changeToPrintPdfSelfList(BuildContext context) {
  //   context
  //       .read<ActionViewAbstractProvider>()
  //       .changeCustomWidget(PdfSelfListPage(
  //         list: listProvider
  //             .getList(findCustomKey())
  //             .whereType<PrintableSelfListInterface>()
  //             .toList(),
  //       ));
  // }
}
