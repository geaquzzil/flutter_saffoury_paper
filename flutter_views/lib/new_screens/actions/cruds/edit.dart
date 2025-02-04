import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/forms/nasted/expansion_edit.dart';
import 'package:flutter_view_controller/new_screens/forms/nasted/nasted_form_builder.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:sliver_tools/sliver_tools.dart';

class EditNew extends BasePageApi {
  EditNew(
      {super.key,
      super.extras,
      super.iD,
      super.tableName,
      super.isFirstToSecOrThirdPane,
      super.parent,
      super.onBuild});

  @override
  State<EditNew> createState() => _BaseNewState();
}

class _BaseNewState extends BasePageStateWithApi<EditNew>
    with BasePageSecoundPaneNotifierState<EditNew> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  late List<String> _fields;

  @override
  void initStateAfterApiCalled() {
    _fields = getExtrasCast().getMainFields(context: context).toList();
  }

  Map<String, dynamic> getInitialData() {
    return getExtrasCast().toJsonViewAbstract();
  }

  List<Widget> getFormContent(ViewAbstract viewAbstract,
      {ViewAbstract? parent, String? fieldNameFromParent}) {
    viewAbstract.onBeforeGenerateView(context, action: ServerActions.edit);
    viewAbstract.setParent(parent);
    viewAbstract.setFieldNameFromParent(fieldNameFromParent);
    // List l = viewAbstract.getMainFields()..add("iD");
    var child = <Widget>[
      ...viewAbstract.getMainFields().map((e) {
        return checkToGetControllerWidget(context, viewAbstract, e);
      }),
    ];
    return child;
  }

  Widget wrapWithColumn(List<Widget> childs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: childs,
    );
  }

  bool isChanged = false;
  Widget checkToGetControllerWidget(
      BuildContext context, ViewAbstract viewAbstract, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field) ??
        viewAbstract.getMirrorNewInstance(field);

    bool enabled = viewAbstract.isFieldEnabled(field);

    if (viewAbstract.isViewAbstract(field)) {
      bool shouldWrap = viewAbstract.shouldWrapWithExpansionCardWhenChild();

      if (shouldWrap) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .25),
          child: ExpansionEdit(
            name: field,
            parentFormKey: formKey,
            viewAbstract: fieldValue,
            valueFromParent: viewAbstract.getFieldValue(field),
          ),
        );
      } else {
        List<Widget> childs = getFormContent(fieldValue,
            parent: viewAbstract, fieldNameFromParent: field);
        return NestedFormBuilder(
          name: field,
          parentFormKey: formKey,
          enabled: enabled,
          skipDisabled: !enabled,
          child: wrapWithColumn(childs),
        );
      }
    }
    return viewAbstract.getFormMainControllerWidget(
        context: context, field: field, formKey: formKey);
  }

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
    debugPrint("dasdasas dassa");
    // return [];
    return [
      FormBuilder(
          initialValue: getInitialData(),
          // autovalidateMode: AutovalidateMode.always,
          key: formKey,
          skipDisabled: true,
          onChanged: () {
            bool? res = formKey.currentState?.saveAndValidate(
                focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false);

            debugPrint(
                "BaseEditFinal FormBuilder onChanged res $res onChanged${formKey.currentState?.value}");

            // formKey.currentState?.fields["status"]?.

            // onValidateForm(context);
          },
          child: MultiSliver(children: [...getFormContent(getExtrasCast())]))
    ];
  }

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
