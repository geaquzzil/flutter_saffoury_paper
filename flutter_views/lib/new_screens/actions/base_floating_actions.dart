import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/size_config.dart';

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
  bool showImportAndExport() {
    return serverActions != ServerActions.print &&
        serverActions != ServerActions.edit;
  }

  bool showPrint(BuildContext context) {
    return viewAbstract.hasPermissionPrint(context) &&
        viewAbstract is PrintableMaster;
  }

  @override
  Widget build(BuildContext context) {
    bool canPrint = showPrint(context);
    return Row(
      // crossAxisAlignment: WrapCrossAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showImportAndExport()) getFileImportFloatingButton(context),
        if (showImportAndExport())
          const SizedBox(
            width: kDefaultPadding,
          ),
        if (showImportAndExport()) getFileReaderFloatingButton(context),
        if (showImportAndExport())
          const SizedBox(
            width: kDefaultPadding,
          ),
        if (serverActions != ServerActions.print)
          if (viewAbstract.hasPermissionDelete(context))
            Row(
              children: [
                getDeleteFloatingButton(context),
                const SizedBox(
                  width: kDefaultPadding,
                ),
              ],
            ),

        if (canPrint) getAddFloatingButtonPrint(context),
        if (addOnList != null && canPrint)
          const SizedBox(
            width: kDefaultPadding,
          ),

        if (addOnList != null) ...addOnList!

        //  ...addOnList!.map((i){

        // })
      ],
    );
  }

  FloatingActionButton getAddFloatingButtonPrint(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () async {
        viewAbstract.printPage(context);
      },
      child: const Icon(Icons.print),
    );
  }

  FloatingActionButton getDeleteFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        Dialogs.materialDialog(
            msgAlign: TextAlign.end,
            dialogWidth:
                SizeConfig.isDesktopOrWebPlatform(context) ? 0.3 : null,
            color: Theme.of(context).colorScheme.surface,
            msg: viewAbstract.getBaseMessage(context,
                serverAction: ServerActions.delete_action),
            title: viewAbstract
                .getBaseTitle(context,
                    serverAction: ServerActions.delete_action)
                .toUpperCase(),
            context: context,
            onClose: (value) {
              debugPrint("onClose: $value");
              // on close is can be confirm or null
              if (value != null) {
                viewAbstract.deleteCall(context,
                    onResponse: OnResponseCallback(
                        onServerNoMoreItems: () {},
                        onClientFailure: (s) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            // backgroundColor: color,
                            duration: const Duration(seconds: 2),
                            content: Text(AppLocalizations.of(context)!
                                .error_server_not_connected),
                          ));

                          // Scaffold.of(context).
                        },
                        onServerResponse: (s) {},
                        onServerFailureResponse: (s) {
                          ///TODO when tow pane change secound pane
                          ///if mobile pop navigation
                        }));
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
                    //todo translate
                    Navigator.of(context).pop("confirm ");
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
          if (SizeConfig.isDesktopOrWebPlatform(context)) {
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
        child: const Icon(Icons.file_upload_outlined));
  }

  Widget getFileReaderFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        onPressed: () {
          if (SizeConfig.isDesktopOrWebPlatform(context)) {
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
        child: const Icon(Icons.file_download_outlined));
  }
}
