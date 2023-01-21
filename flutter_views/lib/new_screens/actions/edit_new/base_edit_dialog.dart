import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseEditDialog extends StatelessWidget {
  ViewAbstract viewAbstract;
  ViewAbstract? _updatedViewAbstract;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late ValueNotifier<ViewAbstract?> onValidate;
  BaseEditDialog({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext _) {
    onValidate = ValueNotifier<ViewAbstract?>(viewAbstract);
    return Builder(
      builder: (context) {
        return Center(
          child: Scaffold(
            key: scaffoldKey,
            floatingActionButton: ValueListenableBuilder<ViewAbstract?>(
              builder: (context, value, child) {
                return FloatingActionButton.small(
                    heroTag: null,
                    child: Icon(Icons.save),
                    onPressed: value == null ? null : () => _onPress(context));
              },
              valueListenable: onValidate,
            ),
            appBar:
                AppBar(title: Text(viewAbstract.getBaseTitle(context)), actions: [
              TextButton(
                  onPressed: () => _onPress(context),
                  child: Text(AppLocalizations.of(context)!.save))
            ]),
            resizeToAvoidBottomInset: false,
            body: BaseEditWidget(
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
