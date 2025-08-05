import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart' as FB;
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/forms/nullable_icon.dart';
import 'package:flutter_view_controller/new_components/forms/reactive_consumer_with_listener.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_dialog.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/packages/material_dialogs/shared/types.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditNew extends BasePageApi {
  FormBuilderOptions? buildOptions;
  EditNew({
    super.key,
    super.extras,
    super.iD,
    this.buildOptions,
    super.tableName,
    super.isFirstToSecOrThirdPane,
    super.parent,
    super.onBuild,
  });

  @override
  State<EditNew> createState() => _BaseNewState();
}

class _BaseNewState extends BasePageStateWithApi<EditNew>
    with BasePageSecoundPaneNotifierState<EditNew> {
  GlobalKey<FB.FormBuilderState> formKey = GlobalKey<FB.FormBuilderState>();
  FormGroup? _baseForm;
  FormBuilderOptions? _builderOption;
  Map<String, ExpansibleController> expansionController = {};

  @override
  void initStateAfterApiCalled() {
    _builderOption = widget.buildOptions ?? FormBuilderOptions();
    _baseForm ??= getExtrasCast().getBaseFormGroup(
      context,
      buildOptions: _builderOption,
    );

    _builderOption?.reset();
    expansionController = {};
    _baseForm!.controls.forEach((key, value) {
      if (value is FormGroup) {
        debugPrint("_BaseNewState _baseForm $key:${value.controls}");
        value.controls.forEach((k, v) {
          (e) =>
              debugPrint("_BaseNewState _baseForm details $k:${v.runtimeType}");
        });
      } else {
        debugPrint("_BaseNewState _baseForm $key:$value");
      }
    });
    debugPrint("_BaseNewState _baseForm all ${_baseForm?.controls}");
  }

  Map<String, dynamic> getInitialData() {
    return getExtrasCast().toJsonViewAbstract();
  }

  Widget getListableFormReactive(
    FormGroup form, {
    bool wrapeWithExpansionTile = true,
  }) {
    String listableKey = getExtrasCast()
        .castListableInterface()
        .getListableAddFromManual(context)
        .getTableNameApi()!;
    List<ViewAbstract> listableObjects = getExtrasCast()
        .castListableInterface()
        .getListableList();
    FormArray arr = form.control(listableKey) as FormArray;
    Widget t = getReactiveFormArray(listableKey, arr, listableObjects);
    if (wrapeWithExpansionTile) {
      return ExpansionTile(
        //TODO translate
        title: Text("List"),
        children: [t],
      );
    }
    return t;
  }

  ReactiveFormArray<Object?> getReactiveFormArray(
    String listableKey,
    FormArray<dynamic> arr,
    List<ViewAbstract<dynamic>> listableObjects,
  ) {
    return ReactiveFormArray(
      formArrayName: listableKey,
      builder: (context, formArray, child) {
        debugPrint(
          "ReactiveFormArray control list ${arr.controls.length} ${arr.controls.length} ",
        );
        List<Widget> widgets = List.empty(growable: true);
        for (int i = 0; i < listableObjects.length; i++) {
          var e = listableObjects[i];
          debugPrint("ReactiveFormArray e is $e");
          e.onBeforeGenerateView(context, action: ServerActions.edit);
          e.setParent(getExtrasCast());
          e.setFieldNameFromParent(listableKey);

          widgets.add(
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: e.getReactiveForm2(
                  childGroup: arr.controls[i] as FormGroup,
                  context: context,
                ),
              ),
            ),
          );
        }

        return Column(spacing: 20, children: widgets);
      },
    );
  }

  Map<String, dynamic> getObject(FormGroup form) {
    return getExtrasCast().getObjectFromForm(context, form);
  }
  // @override
  // Widget wrapBuildWidget(Widget buildWidget) {
  //   return ReactiveFormBuilder(form: ()=>_baseForm! ,builder: ,);
  // }
  // get

  @override
  Widget getMainPanes({TabControllerHelper? baseTap}) {
    initStateAfterApiCalled();
    if (_baseForm == null) {
      return Text("_baseForm is null");
    }
    return ReactiveFormBuilder(
      builder: (context, formGroup, child) =>
          super.getMainPanes(baseTap: baseTap),
      form: () => _baseForm!,
    );
  }

  Widget getFormReactive() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...getFormContentReactive(getExtrasCast(), formGroup: _baseForm!),

        if (getExtrasCast().isListable() &&
            getCurrentScreenSize() == CurrentScreenSize.MOBILE)
          getListableFormReactive(_baseForm!),
        TextButton(
          onPressed: () {
            _baseForm!.hasErrors;
            debugPrint("ReactiveFormBuilder error ${_baseForm!.errors}");
            _baseForm!.markAllAsTouched();

            debugPrint("ReactiveFormBuilder ${getObject(_baseForm!)}");
          },
          child: const Text('Sign Up'),
        ),
        ReactiveFormConsumer(
          builder: (context, form, child) => TextButton(
            onPressed: form.valid
                ? () {
                    _baseForm!.markAllAsTouched();
                    debugPrint("${_baseForm!.value}");
                    //todo
                    (getExtrasCast().copyWith(getObject(form)) as ViewAbstract)
                        .editCall(context: context);
                  }
                : null,
            child: const Text('Sign Up api'),
          ),
        ),
      ],
    );
    if (_baseForm == null) {
      return Text("_baseForm is null");
    }
    return ReactiveFormBuilder(
      form: () => _baseForm!,
      builder: (context, form, child) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...getFormContentReactive(getExtrasCast(), formGroup: _baseForm!),
            if (getExtrasCast().isListable()) getListableFormReactive(form),
            TextButton(
              onPressed: () {
                form.hasErrors;
                debugPrint("ReactiveFormBuilder error ${form.errors}");
                form.markAllAsTouched();

                debugPrint("ReactiveFormBuilder ${getObject(form)}");
              },
              child: const Text('Sign Up'),
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) => TextButton(
                onPressed: form.valid
                    ? () {
                        _baseForm!.markAllAsTouched();
                        debugPrint("${_baseForm!.value}");
                        //todo
                        (getExtrasCast().copyWith(getObject(form))
                                as ViewAbstract)
                            .editCall(context: context);
                      }
                    : null,
                child: const Text('Sign Up api'),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> getFormContentReactive(
    ViewAbstract viewAbstract, {
    ViewAbstract? parent,
    String? fieldNameFromParent,
    required FormGroup formGroup,
  }) {
    setParents(
      viewAbstract: viewAbstract,
      parent: parent,
      fieldNameFromParent: fieldNameFromParent,
    );
    return <Widget>[
      ...viewAbstract.getMainFieldsForForms(context: context).map((e) {
        return checkToGetControllerWidgetReactive(
          context,
          viewAbstract,
          e,
          formGroup: formGroup,
        );
      }),
    ];
  }

  void setParents({
    required ViewAbstract<dynamic> viewAbstract,
    ViewAbstract<dynamic>? parent,
    String? fieldNameFromParent,
  }) {
    viewAbstract.onBeforeGenerateView(context, action: ServerActions.edit);
    viewAbstract.setParent(parent);
    viewAbstract.setFieldNameFromParent(fieldNameFromParent);
  }

  Widget wrapWithColumn(List<Widget> childs) {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: childs,
    );
  }

  ExpansibleController? getExpansionTile(
    ViewAbstract viewAbstract,
    String field,
  ) {
    return expansionController[viewAbstract.getControllerKey(
      field,
      extras: "e",
    )];
  }

  bool isChanged = false;
  Widget checkToGetControllerWidgetReactive(
    BuildContext context,
    ViewAbstract viewAbstract,
    String field, {
    required FormGroup formGroup,
  }) {
    dynamic fieldValue =
        viewAbstract.getFieldValue(field) ??
        viewAbstract.getMirrorNewInstance(field);

    bool enabled = viewAbstract.isFieldEnabled(field);

    if (viewAbstract.isViewAbstract(field)) {
      if (_builderOption?.canContinue(parent: viewAbstract.getParent) ?? true) {
        _builderOption?.plusOne();
        FormGroup childGroup = formGroup.controls[field]! as FormGroup;
        List<Widget> childs = getFormContentReactive(
          fieldValue,
          formGroup: childGroup,
          parent: viewAbstract,
          fieldNameFromParent: field,
        );
        bool canBeNullable = viewAbstract.isFieldCanBeNullable(context, field);
        Widget formWidget = ReactiveForm(
          formGroup: childGroup,
          child: wrapWithColumn(childs),
        );
        if (!canBeNullable) {
          // return formWidget;
          return getExpansionTileWidget(
            viewAbstract: viewAbstract,
            field: field,
            title: (fieldValue as ViewAbstract).getMainLabelText(context),
            childGroup: childGroup,
            setReactiveNullableSwitch: false,
            formWidget: formWidget,
          );
        } else {
          expansionController[viewAbstract.getControllerKey(
                field,
                extras: "e",
              )] =
              ExpansibleController();
        }

        return ReactiveValueListenableBuilderListener<bool>(
          formControlName: viewAbstract.getControllerKey(field, extras: "n"),
          onData: (value) {
            if (value == true) {
              getExpansionTile(viewAbstract, field)?.collapse();
            } else {
              getExpansionTile(viewAbstract, field)?.expand();
            }
          },
          builder: (context, value, child) {
            return getExpansionTileWidget(
              viewAbstract: viewAbstract,
              field: field,
              title: (fieldValue as ViewAbstract).getMainLabelText(context),
              childGroup: childGroup,
              enabled: value.value == false,
              isExpanded: value.value == false,
              formWidget: formWidget,
            );
          },
        );
      }
    }
    return viewAbstract.getFormMainControllerWidgetReactive(
      context: context,
      field: field,
      baseForm: formGroup,
    );
  }

  ExpansionTile getExpansionTileWidget({
    required ViewAbstract<dynamic> viewAbstract,
    required String field,
    required Widget title,
    required FormGroup childGroup,
    required Widget formWidget,
    bool enabled = true,
    bool isExpanded = true,
    bool setReactiveNullableSwitch = true,
  }) {
    return ExpansionTile(
      controller: getExpansionTile(viewAbstract, field),
      initiallyExpanded: isExpanded,
      enabled: enabled,
      childrenPadding: EdgeInsets.all(kDefaultPadding),
      title: title,
      trailing: !setReactiveNullableSwitch
          ? null
          : ReactiveNullableSwitch<bool>(
              context: context,
              formControlName: viewAbstract.getControllerKey(
                field,
                extras: "n",
              ),
              onChange: (value) {
                debugPrint("ReactiveValueListenableBuilder $value ");
                if (value == false) {
                  childGroup.markAsEnabled();
                  childGroup.markAllAsTouched();
                } else {
                  childGroup.markAsDisabled();
                  childGroup.markAllAsTouched();
                }
              },
            ),
      children: [formWidget],
    );
  }

  // List<Widget> getFormContent(ViewAbstract viewAbstract,
  //     {ViewAbstract? parent, String? fieldNameFromParent}) {
  //   viewAbstract.onBeforeGenerateView(context, action: ServerActions.edit);
  //   viewAbstract.setParent(parent);
  //   viewAbstract.setFieldNameFromParent(fieldNameFromParent);
  //   // List l = viewAbstract.getMainFields()..add("iD");
  //   var child = <Widget>[
  //     ...viewAbstract.getMainFields().map((e) {
  //       return checkToGetControllerWidget(context, viewAbstract, e);
  //     }),
  //   ];
  //   return child;
  // }
  // Widget checkToGetControllerWidget(
  //     BuildContext context, ViewAbstract viewAbstract, String field) {
  //   dynamic fieldValue = viewAbstract.getFieldValue(field) ??
  //       viewAbstract.getMirrorNewInstance(field);

  //   bool enabled = viewAbstract.isFieldEnabled(field);

  //   if (viewAbstract.isViewAbstract(field)) {
  //     bool shouldWrap = viewAbstract.shouldWrapWithExpansionCardWhenChild();

  //     if (shouldWrap) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .25),
  //         child: ExpansionEdit(
  //           name: field,
  //           parentFormKey: formKey,
  //           viewAbstract: fieldValue,
  //           valueFromParent: viewAbstract.getFieldValue(field),
  //         ),
  //       );
  //     } else {
  //       List<Widget> childs = getFormContent(fieldValue,
  //           parent: viewAbstract, fieldNameFromParent: field);
  //       return NestedFormBuilder(
  //         name: field,
  //         parentFormKey: formKey,
  //         enabled: enabled,
  //         skipDisabled: !enabled,
  //         child: wrapWithColumn(childs),
  //       );
  //     }
  //   }
  //   return viewAbstract.getFormMainControllerWidget(
  //       context: context, field: field, formKey: formKey);
  // }

  @override
  Widget? getAppbarTitle({bool? firstPane, TabControllerHelper? tab}) {
    if (firstPane == true) {
      return Text(
        getExtrasCast().getBaseTitle(
          context,
          descriptionIsId: true,
          serverAction: ServerActions.edit,
        ),
      );
    }
    if (firstPane == false) {
      return Text(getSecPaneTitle());
    }
    return null;
  }

  @override
  FutureOr getOverrideCallApiFunction(
    BuildContext context, {
    TabControllerHelper? tab,
  }) {
    if (getExtrasCast(tab: tab).isNew()) {
      return getExtrasCast();
    }
    return (getExtrasCast()).viewCall(context: context)
        as Future<ViewAbstract?>;
  }

  @override
  Widget? getFloatingActionButtonPaneNotifier({
    bool? firstPane,
    TabControllerHelper? tab,
  }) {
    if (firstPane == true) {
      return BaseFloatingActionButtons(
        base: getSecoundPaneHelper(),
        // key: widget.key,
        viewAbstract: getExtrasCast(),
        serverActions: ServerActions.edit,
        // addOnList: getFloatingActionWidgetAddOns(context),
      );
    }
    if (firstPane != null && firstPane == false) {
      Widget? widget = getAddToListManualFloatingButton(context);
      Widget? listSelect = getAddToListFloatingButton(context);
      return Row(
        spacing: kDefaultPadding,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget != null) widget,
          if (listSelect != null) listSelect,
        ],
      );
    }
    return null;
  }
  // Widget getAddFloatingButton2(BuildContext context) {
  //   return ValueListenableBuilder(
  //     valueListenable: onValidateViewAbstract,
  //     builder: (context, masterValue, child) {
  //       return ValueListenableBuilder<ApiCallState>(
  //         valueListenable: apiCallState,
  //         builder: (context, value, child) {
  //           if (value == ApiCallState.LOADING) {
  //             return FloatingActionButton(
  //               heroTag: UniqueKey(),
  //               onPressed: null,
  //               backgroundColor: Theme.of(context).colorScheme.surface,
  //               child: const CircularProgressIndicator(),
  //             );
  //           } else if (value == ApiCallState.ERROR) {
  //             return FloatingActionButton.extended(
  //                 heroTag: UniqueKey(),
  //                 onPressed: () {},
  //                 icon: const Icon(Icons.error),
  //                 label:
  //                     Text(AppLocalizations.of(context)!.errOperationFailed));
  //           } else {
  //             return FloatingActionButtonExtended(
  //               expandedWidget: Text(AppLocalizations.of(context)!.subment),
  //               onExpandIcon: getExtras().isEditing() ? Icons.edit : Icons.add,
  //               colapsed:
  //                   masterValue == null ? Icons.error : Icons.arrow_forward,
  //               onPress: masterValue == null
  //                   ? null
  //                   : () async {
  //                       if (widget.onFabClickedConfirm != null) {
  //                         debugPrint(
  //                             "onFabClickedConfirm !=null convert destination");
  //                         widget.onFabClickedConfirm!(currentViewAbstract);
  //                         return;
  //                       }
  //                       currentViewAbstract =
  //                           currentViewAbstract!.copyToUplode();
  //                       apiCallState.value = ApiCallState.LOADING;
  //                       currentViewAbstract = await currentViewAbstract!
  //                           .addCall(
  //                               context: context,
  //                               onResponse: OnResponseCallback(
  //                                   onServerFailureResponse: (s) {
  //                                 debugPrint("onServerFailure $s");
  //                                 apiCallState.value = ApiCallState.ERROR;
  //                               }));
  //                       if (currentViewAbstract != null) {
  //                         apiCallState.value = ApiCallState.DONE;
  //                         extras = currentViewAbstract;
  //                         currentViewAbstract!.onCardClicked(context);
  //                         context.read<ListMultiKeyProvider>().notifyAdd(
  //                             currentViewAbstract!,
  //                             context: context);
  //                       }

  //                       // context.read<ListMultiKeyProvider>().addCustomSingle(viewAbstract);
  //                     },
  //             );
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context) {
    Widget? widget = getAddToListManualFloatingButton(context);
    Widget? listSelect = getAddToListFloatingButton(context);
    return [
      if (widget != null) widget,
      if (widget != null) const SizedBox(width: kDefaultPadding),
      if (listSelect != null) listSelect,
      if (listSelect != null) const SizedBox(width: kDefaultPadding),
      // if (getExtras().hasPermissionEdit(context))
      //   getAddFloatingButton2(context),
    ];
  }

  FloatingActionButton getDeleteFloatingButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        Dialogs.materialDialog(
          customViewPosition: CustomViewPosition.BEFORE_TITLE,
          msgAlign: TextAlign.end,
          // dialogWidth: kIsWeb || isDesktop(context) ? 0.3 : null,
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
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
      child: const Icon(Icons.delete),
    );
  }

  FloatingActionButton? getAddToListManualFloatingButton(BuildContext context) {
    if (getExtras() is! ListableInterface) return null;
    ViewAbstract? value = getListableInterface().getListableAddFromManual(
      context,
    );
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () async {
        value = getListableInterface().getListableAddFromManual(context);
        value!.setParent(getExtras());
        await showFullScreenDialogExt<ViewAbstract?>(
          anchorPoint: const Offset(1000, 1000),
          context: context,
          builder: (p0) {
            return BaseEditDialog(
              disableCheckEnableFromParent: true,
              viewAbstract: value!,
            );
          },
        ).then((value) {
          {
            if (value != null) {
              getListableInterface().onListableAddFromManual(context, value);
              // onListableSelectedItem.value = [];
              // onEditListableItem.value = value;
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
        // await getSelectedItemsDialog(context);
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

  @override
  Widget? getPaneDraggableExpandedHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) => null;

  @override
  Widget? getPaneDraggableHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) => null;

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) => null;

  @override
  bool enableAutomaticFirstPaneNullDetector() {
    return false;
  }

  @override
  List<Widget>? getPaneNotifier({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
    SecondPaneHelper? valueNotifier,
  }) {
    // debugPrint("dasdasas dassa");
    // return [];'

    if (firstPane) {
      return [
        // getFormBuilderWidget()
        SliverToBoxAdapter(child: getFormReactive()),
      ];
    } else {
      return [
        // getFormBuilderWidget()
        if (getExtrasCast().isListable() &&
            getCurrentScreenSize() != CurrentScreenSize.MOBILE)
          SliverToBoxAdapter(
            child: getListableFormReactive(
              _baseForm!,
              wrapeWithExpansionTile: false,
            ),
          ),
        // SliverToBoxAdapter(child: Text("TODO LISTABLE")),
      ];
    }
  }

  // FB.FormBuilder getFormBuilderWidget() {
  //   return FormBuilder(
  //       initialValue: getInitialData(),
  //       // autovalidateMode: AutovalidateMode.always,
  //       key: formKey,
  //       skipDisabled: true,
  //       onChanged: () {
  //         bool? res = formKey.currentState?.saveAndValidate(
  //             focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false);
  //         setExtras(
  //             ex: getExtrasCast()
  //                 .copyWithFromForms(formKey.currentState?.value ?? {}));
  //         // setState(() {});
  //         // debugPrint(
  //         //     "BaseEditFinal FormBuilder onChanged res $res onChanged${formKey.currentState?.value}");

  //         // formKey.currentState?.fields["status"]?.

  //         // onValidateForm(context);
  //       },
  //       child: MultiSliver(children: [...getFormContent(getExtrasCast())]));
  // }

  @override
  ServerActions getServerActions() => ServerActions.edit;
  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) =>
      firstPane && isLargeScreen(context);

  @override
  String onActionInitial() => "TODO On API is null";

  @override
  bool setClipRect(bool? firstPane) => firstPane == true;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) => false;

  // TextEditingController getController(BuildContext context,
  //     {required String field,
  //     required dynamic value,
  //     bool isAutoCompleteVA = false}) {
  //   if (controllers.containsKey(field)) {
  //     // value = getEditControllerText(value);
  //     // controllers[field]!.text = value;
  //     // FocusScope.of(context).unfocus();
  //     // WidgetsBinding.instance
  //     //     .addPostFrameCallback((_) => controllers[field]!.clear());
  //     return controllers[field]!;
  //   }
  //   value = getEditControllerText(value);
  //   controllers[field] = TextEditingController();
  //   controllers[field]!.text = value;

  //   controllers[field]!.addListener(() {
  //     bool? validate = widget
  //         .formKey?.currentState!.fields[_viewAbstract.getTag(field)]
  //         ?.validate(focusOnInvalid: false);
  //     // formKey?.currentState!.fields[viewAbstract.getTag(field)]?.save();
  //     if (validate ?? false) {
  //       formKey?.currentState!.fields[_viewAbstract.getTag(field)]?.save();
  //     }
  //     debugPrint("onTextChangeListener field=> $field validate=$validate");
  //     _viewAbstract.setFieldValue(field, controllers[field]!.text);
  //     _viewAbstract.onTextChangeListener(
  //         context, field, controllers[field]!.text,
  //         formKey: formKey);

  //     if (_viewAbstract.getParnet != null) {
  //       _viewAbstract.getParnet!.onTextChangeListenerOnSubViewAbstract(
  //           context, _viewAbstract, _viewAbstract.getFieldNameFromParent!,
  //           parentformKey: widget.parentFormKey);
  //     }
  //     if (isAutoCompleteVA) {
  //       if (controllers[field]!.text ==
  //           getEditControllerText(_viewAbstract.getFieldValue(field))) {
  //         return;
  //       }
  //       _viewAbstract =
  //           _viewAbstract.copyWithSetNew(field, controllers[field]!.text);
  //       _viewAbstract.parent?.setFieldValue(field, _viewAbstract);
  //       //  refreshControllers(context);
  //       //removed
  //       // viewAbstractChangeProvider.change(_viewAbstract);
  //     }

  //     // }
  //     // modifieController(field);
  //   });
  //   // FocusScope.of(context).unfocus();
  //   // WidgetsBinding.instance
  //   //     .addPostFrameCallback((_) => controllers[field]!.clear());

  //   _viewAbstract.addTextFieldController(field, controllers[field]!);
  //   return controllers[field]!;
  // }
}

class FormBuilderOptions {
  int recursiveLevel;
  int _currentLevel = 0;

  FormBuilderOptions({this.recursiveLevel = -1});

  @Deprecated("")
  void plusOne() {
    // _currentLevel = _currentLevel + 1;
  }

  bool canContinue({required ViewAbstract? parent}) {
    if (parent == null) return true;
    final res = _currentLevel <= recursiveLevel;
    _currentLevel = _currentLevel + 1;
    debugPrint("canContinue curentLevel $_currentLevel =>$res");

    return res;
  }

  void reset() {
    _currentLevel = 0;
  }
}
