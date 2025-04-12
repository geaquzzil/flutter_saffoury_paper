import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart' as FB;
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/forms/nullable_icon.dart';
import 'package:flutter_view_controller/new_components/forms/reactive_consumer_with_listener.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditNew extends BasePageApi {
  FormBuilderOptions? buildOptions;
  EditNew(
      {super.key, 
      super.extras,
      super.iD,
      this.buildOptions,
      super.tableName,
      super.isFirstToSecOrThirdPane,
      super.parent,
      super.onBuild});

  @override
  State<EditNew> createState() => _BaseNewState();
}

class _BaseNewState extends BasePageStateWithApi<EditNew>
    with BasePageSecoundPaneNotifierState<EditNew> {
  GlobalKey<FB.FormBuilderState> formKey = GlobalKey<FB.FormBuilderState>();
  FormGroup? _baseForm;
  FormBuilderOptions? _builderOption;
  Map<String, ExpansionTileController> expansionController = {};

  @override
  void initStateAfterApiCalled() {
    _builderOption = widget.buildOptions ?? FormBuilderOptions();
    _baseForm ??=
        getExtrasCast().getBaseFormGroup(context, buildOptions: _builderOption);

    _builderOption?.reset();
    expansionController = {};
    _baseForm!.controls.forEach(
      (key, value) {
        if (value is FormGroup) {
          debugPrint("_BaseNewState _baseForm $key:${value.controls}");
          value.controls.forEach(
            (k, v) {
              (e) => debugPrint(
                  "_BaseNewState _baseForm details $k:${v.runtimeType}");
            },
          );
        } else {
          debugPrint("_BaseNewState _baseForm $key:$value");
        }
      },
    );
    debugPrint("_BaseNewState _baseForm all ${_baseForm?.controls}");
  }

  Map<String, dynamic> getInitialData() {
    return getExtrasCast().toJsonViewAbstract();
  }

  Widget getListableFormReactive(FormGroup form) {
    String listableKey = getExtrasCast()
        .castListableInterface()
        .getListableAddFromManual(context)
        .getTableNameApi()!;
    List<ViewAbstract> listableObjects =
        getExtrasCast().castListableInterface().getListableList();
    FormArray arr = form.control(listableKey) as FormArray;
    return ExpansionTile(
      title: Text("List"),
      children: [
        ReactiveFormArray(
          formArrayName: listableKey,
          builder: (context, formArray, child) {
            debugPrint(
                "ReactiveFormArray control list ${arr.controls.length} ${arr.controls.length} ");
            List<Widget> widgets = List.empty(growable: true);
            for (int i = 0; i < listableObjects.length; i++) {
              var e = listableObjects[i];
              debugPrint("ReactiveFormArray e is $e");
              e.onBeforeGenerateView(context, action: ServerActions.edit);
              e.setParent(getExtrasCast());
              e.setFieldNameFromParent(listableKey);

              widgets.add(Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: e.getReactiveForm2(
                      childGroup: arr.controls[i] as FormGroup,
                      context: context),
                ),
              ));
            }

            return Column(
              spacing: 20,
              children: widgets,
            );
          },
        )
      ],
    );
  }

  Widget getFormReactive() {
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
                debugPrint("ReactiveFormBuilder ${form.value}");
              },
              child: const Text('Sign Up'),
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) => TextButton(
                onPressed: form.valid
                    ? () {
                        _baseForm!.markAllAsTouched();
                        debugPrint("${_baseForm!.value}");
                      }
                    : null,
                child: const Text('Sign Up'),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> getFormContentReactive(ViewAbstract viewAbstract,
      {ViewAbstract? parent,
      String? fieldNameFromParent,
      required FormGroup formGroup}) {
    setParents(
        viewAbstract: viewAbstract,
        parent: parent,
        fieldNameFromParent: fieldNameFromParent);
    return <Widget>[
      ...viewAbstract.getMainFields().map((e) {
        return checkToGetControllerWidgetReactive(context, viewAbstract, e,
            formGroup: formGroup);
      }),
    ];
  }

  void setParents(
      {required ViewAbstract<dynamic> viewAbstract,
      ViewAbstract<dynamic>? parent,
      String? fieldNameFromParent}) {
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

  ExpansionTileController? getExpansionTile(
      ViewAbstract viewAbstract, String field) {
    return expansionController[
        viewAbstract.getControllerKey(field, extras: "e")];
  }

  bool isChanged = false;
  Widget checkToGetControllerWidgetReactive(
      BuildContext context, ViewAbstract viewAbstract, String field,
      {required FormGroup formGroup}) {
    dynamic fieldValue = viewAbstract.getFieldValue(field) ??
        viewAbstract.getMirrorNewInstance(field);

    bool enabled = viewAbstract.isFieldEnabled(field);

    if (viewAbstract.isViewAbstract(field)) {
      if (_builderOption?.canContinue(parent: viewAbstract.getParent) ?? true) {
        _builderOption?.plusOne();
        FormGroup childGroup = formGroup.controls[field]! as FormGroup;
        List<Widget> childs = getFormContentReactive(fieldValue,
            formGroup: childGroup,
            parent: viewAbstract,
            fieldNameFromParent: field);
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
              formWidget: formWidget);
        } else {
          expansionController[viewAbstract.getControllerKey(field,
              extras: "e")] = ExpansionTileController();
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
                formWidget: formWidget);
          },
        );
      }
    }
    return viewAbstract.getFormMainControllerWidgetReactive(
        context: context, field: field, baseForm: formGroup);
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
                formControlName:
                    viewAbstract.getControllerKey(field, extras: "n"),
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
        children: [formWidget]);
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
        getExtrasCast().getBaseTitle(context,
            descriptionIsId: true, serverAction: ServerActions.edit),
      );
    }
    if (firstPane == false) {
      return Text(getAppLocal(context)!.details);
    }
    return null;
  }

  @override
  Future getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab}) {
    return (getExtras()).viewCallGetFirstFromList((getExtras()).iD,
        context: context) as Future<ViewAbstract?>;
  }

  @override
  Widget? getFloatingActionButton(
          {bool? firstPane, TabControllerHelper? tab}) =>
      null;

  @override
  Widget? getPaneDraggableExpandedHeader(
          {required bool firstPane, TabControllerHelper? tab}) =>
      null;

  @override
  Widget? getPaneDraggableHeader(
          {required bool firstPane, TabControllerHelper? tab}) =>
      null;

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) => null;

  @override
  List<Widget>? getPaneNotifier(
      {required bool firstPane,
      ScrollController? controler,
      TabControllerHelper? tab,
      SecondPaneHelper? valueNotifier}) {
    // debugPrint("dasdasas dassa");
    // return [];
    return [
      // getFormBuilderWidget()
      SliverToBoxAdapter(child: getFormReactive())
    ];
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
