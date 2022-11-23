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
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../new_components/cards/outline_card.dart';
import '../../providers/actions/list_multi_key_provider.dart';
import '../../screens/base_shared_actions_header.dart';
import '../lists/list_api_selected_searchable_widget.dart';
import '../lists/list_static_editable.dart';
import 'package:nil/nil.dart';

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
            widget.viewAbstract.onHasPermission(
              context,
              function: widget.viewAbstract.hasPermissionDelete(context),
              onHasPermissionWidget: () {
                return Row(
                  children: [
                    getDeleteFloatingButton(context),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                  ],
                );
              },
            ),
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
              msg: getMessage(),
              title: getTitle(),
              context: context,
              onClose: (value) {},
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
                    child: Text(AppLocalizations.of(context)!.ok)),
              ]);
        },
        icon: Icon(Icons.arrow_forward),
        label: Text("Confirm"));
  }

  List<ViewAbstract> selectedList = [];
  FloatingActionButton getDeleteFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        Dialogs.materialDialog(
            msgAlign: TextAlign.end,
            dialogWidth: kIsWeb || Responsive.isDesktop(context) ? 0.3 : null,
            color: Theme.of(context).colorScheme.background,
            msg: getMessage(),
            title: getTitle(),
            context: context,
            onClose: (value) {
              if (value != null) {
                context
                    .read<ListMultiKeyProvider>()
                    .delete(widget.viewAbstract);
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

  FloatingActionButton getAddToListFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
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
              if (value != null) {
                setState(() {
                  (widget.viewAbstract as ListableInterface)
                      .onListableSelectedListAdded(selectedList);
                });
              }
            },
            color: Theme.of(context).colorScheme.background,
            context: context,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop("dasda");
                  },
                  child: Text(AppLocalizations.of(context)!.ok)),
            ]);
      },
      child: const Icon(Icons.add),
    );
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
          // padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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

  String getActionText() {
    if (currentViewAbstract == null) {
      return "NOT FOUND";
    }
    if (currentViewAbstract!.isNew()) {
      return AppLocalizations.of(context)!.add.toLowerCase();
    } else {
      return AppLocalizations.of(context)!.edit.toLowerCase();
    }
  }

  String getTitle() {
    String descripon = "";
    if (widget.viewAbstract.isEditing()) {
      descripon =
          widget.viewAbstract.getMainHeaderTextOnly(context).toLowerCase();
    } else {
      descripon =
          widget.viewAbstract.getMainHeaderLabelTextOnly(context).toLowerCase();
    }
    return "${getActionText().toUpperCase()} $descripon ";
  }

  String getLabelViewAbstract() {
    return widget.viewAbstract
        .getMainHeaderLabelTextOnly(context)
        .toLowerCase();
  }

  String getMessage() {
    return "${AppLocalizations.of(context)!.areYouSure}${getActionText()} ${getLabelViewAbstract()} ";
  }
}
