// ignore_for_file: use_build_context_synchronously, constant_identifier_names, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/base_action_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_dialog.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/packages/material_dialogs/shared/types.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../new_components/fabs/floating_action_button_extended.dart';
import '../../../providers/actions/list_multi_key_provider.dart';

class BaseEditNewPage extends BaseActionScreenPage {
  void Function(ViewAbstract? ViewAbstract)? onFabClickedConfirm;

  BaseEditNewPage(
      {super.key,
      required super.viewAbstract,
      this.onFabClickedConfirm,
      super.currentScreenSize});

  @override
  State<BaseEditNewPage> createState() => _BaseEditNewPageState();
}

class _BaseEditNewPageState extends BaseActionScreenPageState<BaseEditNewPage> {
  late bool isExtended;

  ViewAbstract? currentViewAbstract;

  late ValueNotifier<ViewAbstract?> onValidateViewAbstract;

  @override
  Widget getBody(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (c, i) => BaseEditWidget(
        currentScreenSize: widget.currentScreenSize,
        onValidate: (viewAbstract) {
          currentViewAbstract = viewAbstract;
          if (isListableInterface()) {
            if (getListableInterface().isListableRequired(context)) {
              if (getListableInterface().getListableList().isEmpty) {
                onValidateViewAbstract.value = null;
              } else {
                for (var item in getListableInterface().getListableList()) {
                  if (item.onManuallyValidate(context) == null) {
                    onValidateViewAbstract.value = null;
                    return;
                  }
                }
                onValidateViewAbstract.value = currentViewAbstract;
              }
            }
          } else {
            onValidateViewAbstract.value = currentViewAbstract;
          }

          if (currentViewAbstract != null) {
            debugPrint(
                "BaseEdit main form onValidate on main page ${currentViewAbstract?.toJsonString()}");
          }
        },
        viewAbstract: getExtras(),
        isTheFirst: true,
      ),
      itemCount: 1,
    );
    return BaseEditWidget(
      onValidate: (viewAbstract) {
        currentViewAbstract = viewAbstract;
        if (isListableInterface()) {
          if (getListableInterface().isListableRequired(context)) {
            if (getListableInterface().getListableList().isEmpty) {
              onValidateViewAbstract.value = null;
            } else {
              for (var item in getListableInterface().getListableList()) {
                if (item.onManuallyValidate(context) == null) {
                  onValidateViewAbstract.value = null;
                  return;
                }
              }
              onValidateViewAbstract.value = currentViewAbstract;
            }
          }
        } else {
          onValidateViewAbstract.value = currentViewAbstract;
        }

        if (currentViewAbstract != null) {
          debugPrint(
              "BaseEdit main form onValidate on main page ${currentViewAbstract?.toJsonString()}");
        }
      },
      viewAbstract: getExtras(),
      isTheFirst: true,
    );
  }

  @override
  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context) {
    Widget? widget = getAddToListManualFloatingButton(context);
    Widget? listSelect = getAddToListFloatingButton(context);
    return [
      if (widget != null) widget,
      if (widget != null)
        const SizedBox(
          width: kDefaultPadding,
        ),
      if (listSelect != null) listSelect,
      if (listSelect != null)
        const SizedBox(
          width: kDefaultPadding,
        ),
      if (getExtras().hasPermissionEdit(context))
        getAddFloatingButton2(context),
    ];
  }

  @override
  void initState() {
    super.initState();
    isExtended = true;

    if (getExtras().isEditing()) {
      currentViewAbstract = getExtras();
      onValidateViewAbstract = ValueNotifier<ViewAbstract?>(getExtras());
    } else {
      onValidateViewAbstract = ValueNotifier<ViewAbstract?>(null);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isExtended = true;
    if (getExtras().isEditing()) {
      currentViewAbstract = getExtras();
      onValidateViewAbstract = ValueNotifier<ViewAbstract?>(getExtras());
    } else {
      onValidateViewAbstract = ValueNotifier<ViewAbstract?>(null);
    }
  }

  Widget getAddFloatingButton2(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: onValidateViewAbstract,
      builder: (context, masterValue, child) {
        return ValueListenableBuilder<ApiCallState>(
          valueListenable: apiCallState,
          builder: (context, value, child) {
            if (value == ApiCallState.LOADING) {
              return FloatingActionButton(
                heroTag: UniqueKey(),
                onPressed: null,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: const CircularProgressIndicator(),
              );
            } else if (value == ApiCallState.ERROR) {
              return FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  onPressed: () {},
                  icon: const Icon(Icons.error),
                  label:
                      Text(AppLocalizations.of(context)!.errOperationFailed));
            } else {
              return FloatingActionButtonExtended(
                expandedWidget: Text(AppLocalizations.of(context)!.subment),
                onExpandIcon: getExtras().isEditing() ? Icons.edit : Icons.add,
                colapsed:
                    masterValue == null ? Icons.error : Icons.arrow_forward,
                onPress: masterValue == null
                    ? null
                    : () async {
                        if (widget.onFabClickedConfirm != null) {
                          debugPrint(
                              "onFabClickedConfirm !=null convert destination");
                          widget.onFabClickedConfirm!(currentViewAbstract);
                          return;
                        }
                        currentViewAbstract =
                            currentViewAbstract!.copyToUplode();
                        apiCallState.value = ApiCallState.LOADING;
                        currentViewAbstract =
                            await currentViewAbstract!.addCall(
                                context: context,
                                onResponse: OnResponseCallback(
                                    onServerResponse: (response) {},
                                    onServerNoMoreItems: () {},
                                    onClientFailure: (d) {},
                                    onServerFailureResponse: (s) {
                                      debugPrint("onServerFailure $s");
                                      apiCallState.value = ApiCallState.ERROR;
                                    }));
                        if (currentViewAbstract != null) {
                          apiCallState.value = ApiCallState.DONE;
                          extras = currentViewAbstract;
                          currentViewAbstract!.onCardClicked(context);
                          context.read<ListMultiKeyProvider>().notifyAdd(
                              currentViewAbstract!,
                              context: context);
                        }

                        // context.read<ListMultiKeyProvider>().addCustomSingle(viewAbstract);
                      },
              );
            }
          },
        );
      },
    );
  }

  List<ViewAbstract> selectedList = [];
  FloatingActionButton getDeleteFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        Dialogs.materialDialog(
            customViewPosition: CustomViewPosition.BEFORE_TITLE,
            msgAlign: TextAlign.end,
            dialogWidth: kIsWeb || Responsive.isDesktop(context) ? 0.3 : null,
            color: Theme.of(context).colorScheme.surface,
            msg: getExtras().getBaseMessage(context),
            title: getExtras().getBaseTitle(context),
            context: context,
            onClose: (value) {
              if (value != null) {
                context.read<ListMultiKeyProvider>().delete(getExtras());
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

  FloatingActionButton? getAddToListManualFloatingButton(BuildContext context) {
    if (getExtras() is! ListableInterface) return null;
    ViewAbstract? value =
        getListableInterface().getListableAddFromManual(context);
    if (value == null) return null;
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () async {
        value = getListableInterface().getListableAddFromManual(context)
            as ViewAbstract;
        value!.setParent(getExtras());
        await showFullScreenDialogExt<ViewAbstract?>(
            anchorPoint: const Offset(1000, 1000),
            context: context,
            builder: (p0) {
              return BaseEditDialog(
                disableCheckEnableFromParent: true,
                viewAbstract: value!,
              );
            }).then((value) {
          {
            if (value != null) {
              getListableInterface().onListableAddFromManual(context, value);
              onListableSelectedItem.value = [];
              onEditListableItem.value = value;
            }
            debugPrint("getEditDialog result $value");
          }
        });
      },
      child: const Icon(Icons.post_add_rounded),

      // child: AddFromListPopupIconWidget(
      //   viewAbstract: getExtras(),
      //   onSelected: (selectedList) {
      //     getListableInterface()
      //         .onListableSelectedListAdded(context, selectedList);
      //     onListableSelectedItem.value = selectedList;
      //     onEditListableItem.value = null;
      //   },
      // ),
    );
  }

  Widget? getAddToListFloatingButton(BuildContext context) {
    if (getExtras() is! ListableInterface) return null;
    if (getListableInterface().getListablePickObject() == null) return null;
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () async {
        await getSelectedItemsDialog(context);
      },
      child: const Icon(Icons.list),

      // child: AddFromListPopupIconWidget(
      //   viewAbstract: getExtras(),
      //   onSelected: (selectedList) {
      //     getListableInterface()
      //         .onListableSelectedListAdded(context, selectedList);
      //     onListableSelectedItem.value = selectedList;
      //     onEditListableItem.value = null;
      //   },
      // ),
    );
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

  @override
  Widget? getSliverImageBackground(BuildContext context) {
    return null;
  }

  @override
  bool getBodyIsSliver() {
    return true;
  }
}

enum ApiCallState { NONE, LOADING, DONE, ERROR }
