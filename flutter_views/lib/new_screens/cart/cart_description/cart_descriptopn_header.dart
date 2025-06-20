import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';

class CartDescriptionHeader extends StatelessWidget {
  const CartDescriptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        TitleText(
          text: AppLocalizations.of(context)!.no_summary,
          fontSize: 27,
          fontWeight: FontWeight.w400,
        ),
      ]),
    );
  }
}
