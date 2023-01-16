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
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/packages/material_dialogs/shared/types.dart';
import 'package:flutter_view_controller/screens/action_screens/base_actions_page.dart';
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
  bool isCalledApi = false;

  ViewAbstract? currentViewAbstract;
  ViewAbstract? responseViewAbstract;

  @override
  Widget getBody(BuildContext context) {
    // return SliverFillRemaining(
    //   child: Text("dsad"),
    //
    // );
    return SliverFillRemaining(
      // fillOverscroll: true,
      // hasScrollBody: false,
      child: BaseEditWidget(
        onValidate: (viewAbstract) {
          currentViewAbstract = viewAbstract;
        },
        viewAbstract: getExtras() as ViewAbstract,
        isTheFirst: true,
        // onSubmit: (obj) {
        //   if (obj != null) {
        //     debugPrint("baseEditPage onSubmit $obj");
        //   }
        // },
      ),
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
      currentViewAbstract = getExtras() as ViewAbstract;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isExtended = true;
    if (getExtras().isEditing()) {
      currentViewAbstract = getExtras() as ViewAbstract;
    }
  }

  // Widget getLoadingWidget() {
  //   if (currentViewAbstract != null) {
  //     if (isCalledApi == true) {
  //       if (responseViewAbstract == null) {
  //         return Row(
  //           children: [
  //             const Padding(
  //                 padding: EdgeInsets.only(right: 4.0),
  //                 child: Icon(Icons.cancel)),
  //             const Text("faild to added")
  //           ],
  //         );
  //       } else {
  //         return Row(
  //           children: [
  //             const Padding(
  //                 padding: EdgeInsets.only(right: 4.0),
  //                 child: Icon(Icons.done)),
  //             const Text("Successfully added")
  //           ],
  //         );
  //       }
  //     } else {
  //       return const SizedBox(
  //         width: 20,
  //         height: 20,
  //         child: CircularProgressIndicator(
  //           strokeWidth: 2,
  //         ),
  //       );
  //     }
  //   } else {
  //     return Row(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(right: 4.0),
  //           child:
  //               Icon(getExtras().isEditing() ? Icons.edit : Icons.add),
  //         ),
  //         Text(getExtras().getActionText(context))
  //       ],
  //     );
  //   }
  // }

  Widget getAddFloatingButton2(BuildContext context) {
    return FloatingActionButtonExtended(
      expandedWidget: Text("Confirm"),
      onPress: () {},
    );
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
              msg: getExtras().getBaseMessage(context),
              title: getExtras().getBaseTitle(context),
              context: context,
              onClose: (value) {
                if (value != null) {
                  currentViewAbstract = currentViewAbstract!.copyToUplode();
                  if (widget.onFabClickedConfirm != null) {
                    widget.onFabClickedConfirm!(currentViewAbstract);
                  } else {}
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
      onPressed: () {},
      child: AddFromListPopupIconWidget(
        viewAbstract: getExtras(),
        onSelected: (selectedList) {
          setState(() {
            (getExtras() as ListableInterface)
                .onListableSelectedListAdded(selectedList);
          });
        },
      ),
    );
  }

  // Widget getBody() {
  //   bool isListable = getExtras() is ListableInterface;
  //   if (isListable) {
  //     return Column(
  //       children: [
  //         BaseSharedHeaderViewDetailsActions(
  //           viewAbstract: getExtras(),
  //         ),
  //         Expanded(
  //           child: TabBarByListWidget(
  //             tabs: [
  //               TabControllerHelper(
  //                 "EDIT",
  //                 widget: ListView(
  //                     // controller: ScrollController(),
  //                     // physics: const AlwaysScrollableScrollPhysics(),
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: kDefaultPadding),
  //                     children: [
  //                       BaseEditWidget(
  //                         onValidate: (viewAbstract) {
  //                           currentViewAbstract = viewAbstract;
  //                         },
  //                         viewAbstract: getExtras(),
  //                         isTheFirst: true,
  //                         // onSubmit: (obj) {
  //                         //   if (obj != null) {
  //                         //     debugPrint("baseEditPage onSubmit $obj");
  //                         //   }
  //                         // },
  //                       )
  //                     ]),
  //               ),
  //               TabControllerHelper("LIST", widget: getEditableList())
  //             ],
  //           ),
  //         ),
  //       ],
  //     );
  //   } else {
  //     return SingleChildScrollView(
  //         controller: ScrollController(),
  //         physics: const AlwaysScrollableScrollPhysics(),
  //         // padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
  //         child: Column(
  //           children: [
  //             BaseSharedHeaderViewDetailsActions(
  //               viewAbstract: getExtras(),
  //             ),
  //             BaseEditWidget(
  //               onValidate: (viewAbstract) {
  //                 currentViewAbstract = viewAbstract;
  //               },
  //               viewAbstract: getExtras(),
  //               isTheFirst: true,
  //               // onSubmit: (obj) {
  //               //   if (obj != null) {
  //               //     debugPrint("baseEditPage onSubmit $obj");
  //               //   }
  //               // },
  //             ),
  //           ],
  //         ));
  //   }
  // return Row(
  //   children: [
  //     // Expanded(flex: 1, child: Text("TEST")),
  //     Expanded(
  //       flex: 2,
  //       child: BaseEditWidget(
  //         onValidate: (viewAbstract) {
  //           currentViewAbstract = viewAbstract;
  //         },
  //         viewAbstract: getExtras(),
  //         isTheFirst: true,
  //         // onSubmit: (obj) {
  //         //   if (obj != null) {
  //         //     debugPrint("baseEditPage onSubmit $obj");
  //         //   }
  //         // },
  //       ),
  //     ),
  //     if (getExtras().getTabs(context).isNotEmpty)
  //       Expanded(
  //         child: OutlinedCard(
  //           child: TabBarWidget(
  //             viewAbstract: getExtras(),
  //           ),
  //         ),
  //       )
  //   ],
  // );

  Widget getEditableList() {
    return ListableStaticEditable(
        onDelete: (v) => (getExtras() as ListableInterface).onListableDelete(v),
        onUpdate: (v) => (getExtras() as ListableInterface).onListableUpdate(v),
        list: (getExtras() as ListableInterface).getListableList());
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
}
