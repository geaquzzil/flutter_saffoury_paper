import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: WrapCrossAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (serverActions != ServerActions.print)
          getFileImportFloatingButton(context),
        if (serverActions != ServerActions.print)
          const SizedBox(
            width: kDefaultPadding,
          ),
        if (serverActions != ServerActions.print)
          getFileReaderFloatingButton(context),
        if (serverActions != ServerActions.print)
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
            msg: viewAbstract.getBaseMessage(context),
            title: viewAbstract.getBaseTitle(context),
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
        child: const Icon(Icons.file_upload_outlined));
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
        child: const Icon(Icons.file_download_outlined));
  }
}
