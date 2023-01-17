import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseEditDialog extends StatelessWidget {
  ViewAbstract viewAbstract;
  ViewAbstract? _updatedViewAbstract;
  BaseEditDialog({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar:
            AppBar(title: Text(viewAbstract.getBaseTitle(context)), actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, _updatedViewAbstract);
              },
              child: Text(AppLocalizations.of(context)!.save))
        ]),
        resizeToAvoidBottomInset: false,
        body: BaseEditWidget(
            viewAbstract: viewAbstract,
            isTheFirst: true,
            // isRequiredSubViewAbstract: false,
            onValidate: (viewAbstract) {
              _updatedViewAbstract = viewAbstract;
              // widget.onUpdate(validated as T);
              // setState(() {
              //   validated = viewAbstract;
              // });
            }),
      ),
    );
  }
}
