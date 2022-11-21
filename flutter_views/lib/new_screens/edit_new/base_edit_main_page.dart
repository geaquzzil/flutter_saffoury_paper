import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/edit_new/base_edit_new.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../../constants.dart';
import '../../new_components/cards/outline_card.dart';
import '../../screens/base_shared_actions_header.dart';
import '../lists/list_api_selected_searchable_widget.dart';
import '../lists/list_static_editable.dart';

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
              const Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.cancel)),
              const Text("faild to added")
            ],
          );
        } else {
          return Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.done)),
              const Text("Successfully added")
            ],
          );
        }
      } else {
        return const SizedBox(
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.viewAbstract is ListableInterface)
              getAddToListFloatingButton(context),
            const SizedBox(
              width: kDefaultPadding,
            ),
            getAddFloatingButton2(context),
          ],
        ),
        body: getBody());
  }

  FloatingActionButton getAddFloatingButton2(BuildContext context) {
    return FloatingActionButton.extended(
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
              dialogWidth: kIsWeb || Responsive.isDesktop(context) ? 0.3 : null,
              color: Theme.of(context).colorScheme.background,
              msg: 'Are you sure? you can\'t undo this action',
              title: 'Delete',
              context: context,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('TextButton'),
                ),
                ElevatedButton(
                    onPressed: () {
                      ViewAbstract viewAbstractToUpload =
                          currentViewAbstract!.copyToUplode();
                      debugPrint(
                          "BaseEditMainPage ready to upload  copyToUplode=> $viewAbstractToUpload");
                    },
                    child: const Text("OK")),
              ]);
        },
        label: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
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
              isExtended ? const Icon(Icons.arrow_forward) : getLoadingWidget(),
        ));
  }

  List<ViewAbstract> selectedList = [];
  FloatingActionButton getAddToListFloatingButton(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () {
          // var dia = await showModalBottomSheet<String>(
          //   isScrollControlled: true,
          //   context: context,
          //   shape: RoundedRectangleBorder(
          //       borderRadius:
          //           BorderRadius.vertical(top: Radius.circular(20))),
          //   builder: (BuildContext context) {
          //     List<ViewAbstract> selectedList = [];
          //     return FractionallySizedBox(
          //       heightFactor: 0.9,
          //       child: Container(
          //         // height: 200,
          //         // color: Colors.amber,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             ListTile(
          //               title: Text((widget.viewAbstract
          //                       .getMainHeaderTextOnly(context)) +
          //                   " items Selected ${selectedList.length}"),
          //               leading: Icon(Icons.arrow_back_sharp),
          //               subtitle: Text(widget.viewAbstract
          //                   .getMainHeaderLabelTextOnly(context)),
          //             ),
          //             OutlinedCard(
          //               child: SizedBox(
          //                   height: 400,
          //                   width: double.infinity,
          //                   child: ListApiSelectedSearchableWidget(
          //                     viewAbstract: (widget.viewAbstract
          //                             as ListableInterface)
          //                         .getListablePickObject(),
          //                     onSelected: (sList) {
          //                       setState(() {
          //                         selectedList = sList.cast();
          //                       });
          //                     },
          //                   )),
          //             ),
          //             ElevatedButton(
          //                 onPressed: () =>
          //                     Navigator.of(context).pop("is pop up"),
          //                 child: Text("OK"))
          //             // But(
          //             //   onPressed: () {

          //             //     Navigator.of(context).pop();
          //             //   },
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );

          // debugPrint("on popup navigator $dia");
          // YY(
          //   items: [RadioItem(text: "dsad")],
          // );
          // YYListViewDialogListTile();
          Dialogs.materialDialog(
              // isScrollControlled: true,
              msgAlign: TextAlign.end,
              customView: Align(
                alignment: Alignment(0, 1),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: double.infinity,
                    child: ListApiSelectedSearchableWidget(
                      viewAbstract: (widget.viewAbstract as ListableInterface)
                          .getListablePickObject(),
                      onSelected: (sList) {
                        selectedList = sList.cast();
                        // setState(() {
                        //   selectedList=sList.cast();
                        // });
                      },
                    )),
              ),
              dialogShape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              dialogWidth: kIsWeb || Responsive.isDesktop(context) ? 0.5 : null,
              useSafeArea: false,
              onClose: (value) {
                debugPrint("onClosed $selectedList");
                setState(() {
                  (widget.viewAbstract as ListableInterface)
                      .onListableSelectedListAdded(selectedList);
                });
              },
              color: Theme.of(context).colorScheme.background,
              // msg: 'Are you sure? you can\'t undo this action',
              // title: 'Delete',
              context: context,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop("dasda");
                  },
                  child: const Text('TextButton'),
                ),
                ElevatedButton(
                    onPressed: () {
                      // ViewAbstract viewAbstractToUpload =
                      //     currentViewAbstract!.copyToUplode();
                      // debugPrint(
                      //     "BaseEditMainPage ready to upload  copyToUplode=> $viewAbstractToUpload");
                    },
                    child: const Text("OK")),
              ]);
        },
        label: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(
            opacity: animation,
            child: SizeTransition(
              child: child,
              sizeFactor: animation,
              axis: Axis.horizontal,
            ),
          ),
          child: isExtended ? const Icon(Icons.add) : getLoadingWidget(),
        ));
  }

  Widget getBody() {
    bool isListable = widget.viewAbstract is ListableInterface;
    if (isListable) {
      return Column(
        children: [
          BaseSharedHeaderViewDetailsActions(
            viewAbstract: widget.viewAbstract,
          ),
          Expanded(
            child: TabBarByListWidget(
              tabs: [
                TabControllerHelper(
                  "EDIT",
                  widget: ListView(
                      // controller: ScrollController(),
                      // physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      children: [
                        BaseEditWidget(
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
                        )
                      ]),
                ),
                TabControllerHelper("LIST", widget: getEditableList())
              ],
            ),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
          controller: ScrollController(),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              BaseSharedHeaderViewDetailsActions(
                viewAbstract: widget.viewAbstract,
              ),
              BaseEditWidget(
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
              ),
            ],
          ));
    }
    // return Row(
    //   children: [
    //     // Expanded(flex: 1, child: Text("TEST")),
    //     Expanded(
    //       flex: 2,
    //       child: BaseEditWidget(
    //         onValidate: (viewAbstract) {
    //           currentViewAbstract = viewAbstract;
    //         },
    //         viewAbstract: widget.viewAbstract,
    //         isTheFirst: true,
    //         // onSubmit: (obj) {
    //         //   if (obj != null) {
    //         //     debugPrint("baseEditPage onSubmit $obj");
    //         //   }
    //         // },
    //       ),
    //     ),
    //     if (widget.viewAbstract.getTabs(context).isNotEmpty)
    //       Expanded(
    //         child: OutlinedCard(
    //           child: TabBarWidget(
    //             viewAbstract: widget.viewAbstract,
    //           ),
    //         ),
    //       )
    //   ],
    // );
  }

  Widget getEditableList() {
    return ListableStaticEditable(
        onDelete: (v) =>
            (widget.viewAbstract as ListableInterface).onListableDelete(v),
        onUpdate: (v) =>
            (widget.viewAbstract as ListableInterface).onListableUpdate(v),
        list: (widget.viewAbstract as ListableInterface).getListableList());
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showMaterialBanner(
      MaterialBanner(
        content: const Text('This is a MaterialBanner'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              scaffold.hideCurrentMaterialBanner();
            },
            child: const Text('DISMISS'),
          ),
        ],
      ),
    );
  }
}
