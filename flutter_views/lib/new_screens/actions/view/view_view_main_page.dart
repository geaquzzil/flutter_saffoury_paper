import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_screens/actions/base_action_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../new_components/cards/outline_card.dart';
import '../../lists/list_static_editable.dart';
import '../../../providers/actions/list_multi_key_provider.dart';
import '../../../screens/base_shared_actions_header.dart';
import 'package:nil/nil.dart';

class BaseViewNewPage extends BaseActionScreenPage {
  ViewAbstract viewAbstract;

  BaseViewNewPage({Key? key, required this.viewAbstract})
      : super(key: key, viewAbstract: viewAbstract);

  @override
  Widget getBody(BuildContext context) {
    return MasterView(viewAbstract: viewAbstract);
  }

  @override
  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context) {
    return [getAddFloatingButton2(context)];
  }

  FloatingActionButton getAddFloatingButton2(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: UniqueKey(),
        onPressed: () async {},
        icon: Icon(Icons.edit),
        label: Text(AppLocalizations.of(context)!.edit));
  }
}

class _BaseViewNewPage extends State<BaseViewNewPage> {
  late bool isExtended;
  bool isCalledApi = false;

  ViewAbstract? currentViewAbstract;

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
            getAddFloatingButton2(context),
            const SizedBox(
              width: kDefaultPadding,
            ),
          ],
        ),
        body: getFutureBody());
  }

  FloatingActionButton getAddFloatingButton2(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: UniqueKey(),
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
              onClose: (value) {
                if (value != null) {
                  currentViewAbstract = currentViewAbstract!.copyToUplode();
                  debugPrint(
                      "onConfirm currentViewAbstract => $currentViewAbstract");
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
                    child: Text(AppLocalizations.of(context)!.ok)),
              ]);
        },
        icon: Icon(Icons.arrow_forward),
        label: Text("Confirm"));
  }

  List<ViewAbstract> selectedList = [];
  FloatingActionButton getDeleteFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
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

  bool getBodyWithoutApi() {
    bool canGetBody =
        widget.viewAbstract.isRequiredObjectsList()?[ServerActions.view] ==
            null;
    if (canGetBody) {
      debugPrint("BaseEditWidget getBodyWithoutApi skiped");
      return true;
    }
    bool res = widget.viewAbstract.isNew() ||
        widget.viewAbstract.isRequiredObjectsListChecker();
    debugPrint("BaseEditWidget getBodyWithoutApi result => $res");
    return res;
  }

  Widget getFutureBody() {
    if (getBodyWithoutApi()) {
      return getBody();
    }
    return FutureBuilder(
      future:
          widget.viewAbstract.viewCallGetFirstFromList(widget.viewAbstract.iD),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            widget.viewAbstract = snapshot.data as ViewAbstract;
            context
                .read<ListMultiKeyProvider>()
                .edit(snapshot.data as ViewAbstract);

            return getBody();
          } else {
            return EmptyWidget(
                lottiUrl:
                    "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
                title: AppLocalizations.of(context)!.cantConnect,
                subtitle: AppLocalizations.of(context)!.cantConnectRetry);
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget getBody() {
    // return MasterView(viewAbstract: widget.viewAbstract);
    return ListView(
      children: [
        BaseSharedHeaderViewDetailsActions(
          viewAbstract: widget.viewAbstract,
        ),
        MasterView(viewAbstract: widget.viewAbstract),
      ],
    );
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
              MasterView(
                viewAbstract: widget.viewAbstract,
              )
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