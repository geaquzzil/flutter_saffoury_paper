import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/providers/settings/language_provider.dart';
import 'package:provider/provider.dart';

class DrawerLanguageButton extends StatelessWidget {
  const DrawerLanguageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownStringListControllerListenerByIcon(
      icon: Icons.language,
      hint: AppLocalizations.of(context)!.language,
      list: [
        DropdownStringListItem(
            Icons.translate, AppLocalizations.of(context)!.systemDefault),
        DropdownStringListItem(
            Icons.translate, AppLocalizations.of(context)!.english),
        DropdownStringListItem(
            Icons.translate, AppLocalizations.of(context)!.arabic),
      ],
      onSelected: (object) {
        if (object == null) {
          context
              .read<LangaugeProvider>()
              .change(Localizations.localeOf(context));
          return;
        }
        if (object.label == null) {
          context
              .read<LangaugeProvider>()
              .change(Localizations.localeOf(context));
        } else {
          if (object.label == AppLocalizations.of(context)!.english) {
            context.read<LangaugeProvider>().change(const Locale('en', ''));
          } else if (object.label == AppLocalizations.of(context)!.arabic) {
            context.read<LangaugeProvider>().change(const Locale('ar', ''));
          } else {
            context
                .read<LangaugeProvider>()
                .change(Localizations.localeOf(context));
          }
        }
      },
    );
  }
}
