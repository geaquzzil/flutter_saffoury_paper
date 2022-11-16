import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:material_dialogs/material_dialogs.dart';

class BaseEditNewPage extends StatefulWidget {
  ViewAbstract viewAbstract;
  BaseEditNewPage({Key? key, required this.viewAbstract}) : super(key: key);

  @override
  State<BaseEditNewPage> createState() => _BaseEditNewPageState();
}

class _BaseEditNewPageState extends State<BaseEditNewPage> {
  late bool isExtended;
  bool isCalledApi = false;

  ViewAbstract? currentViewAbstract;
  ViewAbstract? responseViewAbstract;

  @override
  void initState() {
    super.initState();
    isExtended = true;
    if (widget.viewAbstract.isEditing()) {
      currentViewAbstract = widget.viewAbstract;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isExtended = true;
    if (widget.viewAbstract.isEditing()) {
      currentViewAbstract = widget.viewAbstract;
    }
  }

  Widget getLoadingWidget() {
    if (currentViewAbstract != null) {
      if (isCalledApi == true) {
        if (responseViewAbstract == null) {
          return Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.cancel)),
              Text("faild to added")
            ],
          );
        } else {
          return Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.done)),
              Text("Successfully added")
            ],
          );
        }
      } else {
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      }
    } else {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child:
                Icon(widget.viewAbstract.isEditing() ? Icons.edit : Icons.add),
          ),
          Text(widget.viewAbstract.getActionText(context))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (currentViewAbstract == null) {
                isCalledApi = false;
                debugPrint(
                    "BaseEditMainPage  ready to upload currentViewAbstract=null");
                _showToast(context);
                return;
              }
              Dialogs.materialDialog(
                  msgAlign: TextAlign.end,
                  dialogWidth:
                      kIsWeb || Responsive.isDesktop(context) ? 0.3 : null,
                  color: Theme.of(context).colorScheme.background,
                  msg: 'Are you sure? you can\'t undo this action',
                  title: 'Delete',
                  context: context,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('TextButton'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ViewAbstract viewAbstractToUpload =
                              currentViewAbstract!.copyToUplode();
                          debugPrint(
                              "BaseEditMainPage ready to upload  copyToUplode=> $viewAbstractToUpload");
                        },
                        child: Text("OK")),
                  ]);
              // showModalBottomSheet<void>(
              //   context: context,
              //   shape: RoundedRectangleBorder(
              //       borderRadius:
              //           BorderRadius.vertical(top: Radius.circular(20))),
              //   builder: (BuildContext context) {
              //     return Container(
              //       // height: 200,
              //       // color: Colors.amber,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         mainAxisSize: MainAxisSize.min,
              //         children: <Widget>[
              //           ListTile(
              //             title:
              //                 (widget.viewAbstract.getMainHeaderText(context)),
              //             leading: Icon(Icons.arrow_back_sharp),
              //             subtitle: Text(widget.viewAbstract
              //                 .getMainHeaderLabelTextOnly(context)),
              //           ),
              //           const Text('Modal BottomSheet'),
              //           ElevatedButton(
              //             child: const Text('Close BottomSheet'),
              //             onPressed: () => Navigator.pop(context),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // );
            },
            label: AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  child: child,
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                ),
              ),
              child:
                  isExtended ? Icon(Icons.arrow_forward) : getLoadingWidget(),
            )),
        body: BaseEditWidget(
          onValidate: (viewAbstract) {
            currentViewAbstract = viewAbstract;
          },
          viewAbstract: widget.viewAbstract,
          isTheFirst: true,
          // onSubmit: (obj) {
          //   if (obj != null) {
          //     debugPrint("baseEditPage onSubmit $obj");
          //   }
          // },
        ));
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showMaterialBanner(
      MaterialBanner(
        content: Text('This is a MaterialBanner'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              scaffold.hideCurrentMaterialBanner();
            },
            child: Text('DISMISS'),
          ),
        ],
      ),
    );
  }
}
