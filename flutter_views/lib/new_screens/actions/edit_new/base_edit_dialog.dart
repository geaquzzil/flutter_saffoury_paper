import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';

class BaseEditDialog extends StatelessWidget {
  ViewAbstract viewAbstract;
  ViewAbstract? _updatedViewAbstract;
  GlobalKey<FormBuilderState>? formKey;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool disableCheckEnableFromParent;
  late ValueNotifier<ViewAbstract?> onValidate;
  BaseEditDialog({
    super.key,
    required this.viewAbstract,
    this.formKey,
    this.disableCheckEnableFromParent = false,
  });

  @override
  Widget build(BuildContext context) {
    onValidate = ValueNotifier<ViewAbstract?>(
        viewAbstract.isEditing() ? viewAbstract : null);
    return Center(
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: ValueListenableBuilder<ViewAbstract?>(
          builder: (context, value, child) {
            return FloatingActionButton.small(
                heroTag: null,
                onPressed: value == null ? null : () => _onPress(context),
                child: const Icon(Icons.save));
          },
          valueListenable: onValidate,
        ),
        appBar:
            AppBar(title: Text(viewAbstract.getBaseTitle(context)), actions: [
          ValueListenableBuilder<ViewAbstract?>(
            builder: (context, value, child) {
              return TextButton(
                  onPressed: value == null ? null : () => _onPress(context),
                  child: Text(AppLocalizations.of(context)!.save));
            },
            valueListenable: onValidate,
          )
        ]),
        resizeToAvoidBottomInset: false,
        body: BaseEditWidget(
            disableCheckEnableFromParent: disableCheckEnableFromParent,
            formKey: formKey,
            viewAbstract: viewAbstract,
            isTheFirst: true,
            // isRequiredSubViewAbstract: false,
            onValidate: (viewAbstract) {
              onValidate.value = viewAbstract;
              debugPrint("BaseEditDialog onValidate");
              _updatedViewAbstract = viewAbstract;
              // widget.onUpdate(validated as T);
              // setState(() {
              //   validated = viewAbstract;
              // });
            }),
      ),
    );
  }

  void _onPress(BuildContext context) {
    if (onValidate.value == null) {
      ScaffoldMessenger.maybeOf(context)?.showMaterialBanner(
        const MaterialBanner(
          padding: EdgeInsets.all(20),
          content: Text('Hello, I am a Material Banner'),
          leading: Icon(Icons.error),
          // backgroundColor: Colors.green,
          actions: <Widget>[
            TextButton(
              onPressed: null,
              child: Text('DISMISS'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pop(context, _updatedViewAbstract);
  }
}
