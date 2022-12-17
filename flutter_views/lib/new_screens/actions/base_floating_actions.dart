import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../constants.dart';
import '../file_reader/base_file_reader_page.dart';

@immutable
class BaseFloatingActionButtons extends StatelessWidget {
  ViewAbstract viewAbstract;
  ServerActions serverActions;
  List<Widget>? addOnList;

  BaseFloatingActionButtons(
      {super.key,
      required this.viewAbstract,
      required this.serverActions,
      this.addOnList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        getFileImportFloatingButton(context),
        const SizedBox(
          width: kDefaultPadding,
        ),
        getFileReaderFloatingButton(context),
        const SizedBox(
          width: kDefaultPadding,
        ),
        viewAbstract.onHasPermission(
          context,
          function: viewAbstract.hasPermissionDelete(context),
          onHasPermissionWidget: () {
            return Row(
              children: [
                getDeleteFloatingButton(context),
                const SizedBox(
                  width: kDefaultPadding,
                ),
              ],
            );
          },
        ),
        if (addOnList != null) ...addOnList!
      ],
    );
  }

  FloatingActionButton getDeleteFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        Dialogs.materialDialog(
            msgAlign: TextAlign.end,
            dialogWidth: SizeConfig.isDesktopOrWeb(context) ? 0.3 : null,
            color: Theme.of(context).colorScheme.background,
            msg: getMessage(context),
            title: getTitle(context),
            context: context,
            onClose: (value) {
              if (value != null) {
                context.read<ListMultiKeyProvider>().delete(viewAbstract);
              }
            },
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop("confirm");
                  },
                  child: Text(AppLocalizations.of(context)!.delete)),
            ]);
      },
      child: const Icon(Icons.delete),
    );
  }

  Widget getFileImportFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        onPressed: () {
          if (SizeConfig.isDesktopOrWeb(context)) {
            context
                .read<ActionViewAbstractProvider>()
                .changeCustomWidget(FileExporterPage(
                  viewAbstract: viewAbstract,
                ));
          } else {
            Navigator.pushNamed(context, "/export", arguments: viewAbstract);
          }

          // context.read().change()
        },
        child: Icon(Icons.file_upload_outlined));
  }

  Widget getFileReaderFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        onPressed: () {
          if (SizeConfig.isDesktopOrWeb(context)) {
            context
                .read<ActionViewAbstractProvider>()
                .changeCustomWidget(FileReaderPage(
                  viewAbstract: viewAbstract,
                ));
          } else {
            Navigator.pushNamed(context, "/import", arguments: viewAbstract);
          }

          // context.read().change()
        },
        child: Icon(Icons.file_download_outlined));
  }

  String getActionText(BuildContext context) {
    if (viewAbstract == null) {
      return "NOT FOUND";
    }
    if (viewAbstract!.isNew()) {
      return AppLocalizations.of(context)!.add.toLowerCase();
    } else {
      return AppLocalizations.of(context)!.edit.toLowerCase();
    }
  }

  String getTitle(BuildContext context) {
    String descripon = "";
    if (viewAbstract.isEditing()) {
      descripon = viewAbstract.getMainHeaderTextOnly(context).toLowerCase();
    } else {
      descripon =
          viewAbstract.getMainHeaderLabelTextOnly(context).toLowerCase();
    }
    return "${getActionText(context).toUpperCase()} $descripon ";
  }

  String getLabelViewAbstract(BuildContext context) {
    return viewAbstract.getMainHeaderLabelTextOnly(context).toLowerCase();
  }

  String getMessage(BuildContext context) {
    return "${AppLocalizations.of(context)!.areYouSure}${getActionText(context)} ${getLabelViewAbstract(context)} ";
  }
}