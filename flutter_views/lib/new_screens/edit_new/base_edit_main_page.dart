import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit_new/base_edit_new.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isExtended = true;
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
              if (!isExtended) {
                if (currentViewAbstract == null) {
                  isCalledApi = false;
                  debugPrint(
                      "BaseEditMainPage  ready to upload currentViewAbstract=null");
                  _showToast(context);
                  return;
                } else {
                  debugPrint(
                      "BaseEditMainPage ready to upload => $currentViewAbstract");
                  isCalledApi = true;
                  responseViewAbstract = await currentViewAbstract!.addCall();
                  debugPrint(
                      "BaseEditMainPage  response obj=> $responseViewAbstract");
                  if (responseViewAbstract != null) {
                    widget.viewAbstract = responseViewAbstract!;
                  }
                  setState(() {});
                }

                return;
              }
              setState(() {
                isExtended = !isExtended;
              });
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
        body: BaseEditPageNew(
          onValidate: (viewAbstract) {
            // debugPrint("BaseSharedDetailsView onValidate=> $viewAbstract");
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
