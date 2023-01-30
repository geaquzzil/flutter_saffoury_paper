import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_view_controller/customs_widget/expandable_sliver_list.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/file_reader_popup_icon_widget.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_screens/actions/base_action_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_widget_sliver.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/packages/material_dialogs/shared/types.dart';
import 'package:flutter_view_controller/screens/action_screens/base_actions_page.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../new_components/add_from_list_popup_icon_widget.dart';
import '../../../new_components/cards/outline_card.dart';
import '../../../new_components/fabs/floating_action_button_extended.dart';
import '../../../providers/actions/action_viewabstract_provider.dart';
import '../../../providers/actions/list_multi_key_provider.dart';

import '../../home/components/empty_widget.dart';
import '../../lists/list_api_selected_searchable_widget.dart';
import '../../lists/list_static_editable.dart';
import 'package:nil/nil.dart';

class BaseEditNewPage extends BaseActionScreenPage {
  void Function(ViewAbstract? ViewAbstract)? onFabClickedConfirm;

  BaseEditNewPage(
      {Key? key, required super.viewAbstract, this.onFabClickedConfirm})
      : super(key: key);

  @override
  State<BaseEditNewPage> createState() => _BaseEditNewPageState();
}

class _BaseEditNewPageState extends BaseActionScreenPageState<BaseEditNewPage> {
  late bool isExtended;

  ViewAbstract? currentViewAbstract;

  late ValueNotifier<ViewAbstract?> onValidateViewAbstract;

  @override
  Widget getBody(BuildContext context) {
    return BaseEditWidget(
      onValidate: (viewAbstract) {
        currentViewAbstract = viewAbstract;
        if (isListableInterface()) {
          if (getListableInterface().isListableRequired(context)) {
            if (getListableInterface().getListableList().isEmpty) {
              onValidateViewAbstract.value = null;
            } else {
              //TODO check every list item
              
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
    return [
      if (getExtras() is ListableInterface) getAddToListFloatingButton(context),
      if (getExtras() is ListableInterface)
        const SizedBox(
          width: kDefaultPadding,
        ),
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
                backgroundColor: Theme.of(context).colorScheme.background,
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
                        currentViewAbstract =
                            currentViewAbstract!.copyToUplode();
                        apiCallState.value = ApiCallState.LOADING;
                        currentViewAbstract =
                            await currentViewAbstract!.addCall(
                                onResponse: OnResponseCallback(
                                    onServerNoMoreItems: () {},
                                    onServerFailure: (d) {},
                                    onServerFailureResponse: (s) {
                                      debugPrint(
                                          "onServerFailure ${s.toJson()}");
                                      apiCallState.value = ApiCallState.ERROR;
                                    }));
                        if (currentViewAbstract != null) {
                          apiCallState.value = ApiCallState.DONE;
                          extras = currentViewAbstract;
                          currentViewAbstract!.onCardClicked(context);
                          context
                              .read<ListMultiKeyProvider>()
                              .notifyAdd(currentViewAbstract!);
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
            color: Theme.of(context).colorScheme.background,
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

  FloatingActionButton getAddToListFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () async {
        await getSelectedItemsDialog(context);
      },
      child: Icon(Icons.list),

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
    return false;
  }
}

enum ApiCallState { NONE, LOADING, DONE, ERROR }
