import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/providers/settings/language_provider.dart';
import 'package:provider/provider.dart';

class DrawerLanguageButton extends StatelessWidget {
  const DrawerLanguageButton({
    super.key,
  });
  bool? isEnglish(BuildContext context) {
    return context.read<LangaugeProvider>().getLocale?.languageCode == 'en';
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownStringListItem> l = [
      DropdownStringListItem(
          icon: Icons.translate, label: AppLocalizations.of(context)!.english),
      DropdownStringListItem(
          icon: Icons.translate, label: AppLocalizations.of(context)!.arabic),
    ];
    bool? isEng = isEnglish(context);
    return DropdownStringListControllerListenerByIcon(
      showSelectedValueBeside: false,
      icon: Icons.language,
      hint: AppLocalizations.of(context)!.language,
      list: l,
      initialValue: isEng == null ? null : (isEng ? l[0] : l[1]),
      onSelected: (object) {
        if (object == null) {
          context
              .read<LangaugeProvider>()
              .change(Localizations.localeOf(context));
          Configurations.save(
              "ln", Localizations.localeOf(context).languageCode);
          return;
        }
        if (object.label == AppLocalizations.of(context)!.english) {
          context.read<LangaugeProvider>().change(const Locale('en', ''));
          Configurations.save("ln", "en");
        } else if (object.label == AppLocalizations.of(context)!.arabic) {
          context.read<LangaugeProvider>().change(const Locale('ar', ''));
          Configurations.save("ln", "ar");
        } else {
          context
              .read<LangaugeProvider>()
              .change(Localizations.localeOf(context));
          Configurations.save(
              "ln", Localizations.localeOf(context).languageCode);
        }
      },
    );
  }
}
