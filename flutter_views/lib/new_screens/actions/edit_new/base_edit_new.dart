import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_custom_list.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_view_abstract_asonefield.dart';
import 'package:flutter_view_controller/new_screens/controllers/edit_controller_chipds.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/size_config.dart';

import '../../../models/view_abstract.dart';
import '../../../models/view_abstract_inputs_validaters.dart';
import '../../controllers/edit_controller_dropdown.dart';
import '../../controllers/edit_controller_dropdown_api.dart';
import '../../controllers/edit_controller_file_picker.dart';
import '../../controllers/ext.dart';
import 'edit_controllers_utils.dart';

@immutable
class BaseEditWidget extends StatefulWidget {
  ViewAbstract viewAbstract;
  bool isTheFirst;
  bool isStandAloneField;
  bool buildAsPrint;
  GlobalKey<FormBuilderState>? formKey;

  ///if viewabstract has parent then we get the parent form key
  GlobalKey<FormBuilderState>? parentFormKey;
  void Function(ViewAbstract? viewAbstract)? onValidate;

  bool isRequiredSubViewAbstract;

  bool requireOnValidateEvenIfNull;
  bool disableCheckEnableFromParent;

  CurrentScreenSize? currentScreenSize;
  BaseEditWidget(
      {super.key,
      this.isStandAloneField = false,
      required this.viewAbstract,
      required this.isTheFirst,
      this.buildAsPrint = false,
      this.formKey,
      this.currentScreenSize,
      this.parentFormKey,
      this.disableCheckEnableFromParent = false,
      this.requireOnValidateEvenIfNull = false,
      this.isRequiredSubViewAbstract = true,
      this.onValidate});

  @override
  State<BaseEditWidget> createState() => BaseEditWidgetState();
}

class BaseEditWidgetState extends State<BaseEditWidget> {
  late List<String> fields;

  late Map<GroupItem, List<String>> groupedFields;
  GlobalKey<FormBuilderState>? formKey;

  late Map<int, List<String>> groupedHorizontalFields;

  Map<String, List<String>>? groupedControllerAfterInput;

  Map<String, TextEditingController> controllers = {};

  final Map<String, GlobalKey<FormBuilderState>> _subformKeys = {};

  late GlobalKey<EditSubViewAbstractHeaderState> keyExpansionTile;

  late ViewAbstract _viewAbstract;

  ValueNotifier groupedControllerNotifier = ValueNotifier(null);

  @override
  void initState() {
    init(context);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BaseEditWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void init(BuildContext context) {
    formKey = widget.formKey ?? GlobalKey<FormBuilderState>();
    _viewAbstract = widget.viewAbstract;
    keyExpansionTile = GlobalKey<EditSubViewAbstractHeaderState>(
        debugLabel: "${_viewAbstract.runtimeType}");
    //removed
    //viewAbstractChangeProvider =
    //     ViewAbstractChangeProvider.init(widget.viewAbstract);
    _viewAbstract.onBeforeGenerateView(context, action: ServerActions.edit);
    debugPrint("BaseEditNew currentScreenSize ${widget.currentScreenSize}");
    // _formKey = Provider.of<ErrorFieldsProvider>(context, listen: false)
    //     .getFormBuilderState;
    if (!widget.isRequiredSubViewAbstract) {
      fields = _viewAbstract
          .getMainFields(context: context)
          .where((element) => !_viewAbstract.isViewAbstract(element))
          .toList();
    } else {
      fields = _viewAbstract.getMainFields(context: context);
      groupedFields = _viewAbstract.getMainFieldsGroups(context);

      groupedHorizontalFields =
          _viewAbstract.getMainFieldsHorizontalGroups(context);
      groupedControllerAfterInput =
          _viewAbstract.getHasControlersAfterInputtMap(context);
      if (groupedControllerAfterInput != null) {
        fields = fields
            .getNotContainsList(groupedControllerAfterInput!.getSumsFromList())
            .cast();
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_viewAbstract.hasParent()) {
        keyExpansionTile.currentState?.setError(hasError(context));
      }
    });
  }

  bool isFieldEnableSubViewAbstract() {
    if (_viewAbstract.hasParent()) {
      bool isEnabled = _viewAbstract.getParnet!
          .isFieldEnabled(_viewAbstract.getFieldNameFromParent!);
      return isEnabled;
    }
    return true;
  }

  bool isFieldEnabled(String field) {
    if (!_viewAbstract.hasParent()) return _viewAbstract.isFieldEnabled(field);
    if (widget.disableCheckEnableFromParent) return true;
    return _viewAbstract.isNew() && _viewAbstract.isFieldEnabled(field);
  }

  void refreshControllers(BuildContext context, String currentField) {
    controllers.forEach((key, value) {
      if (key != currentField) {
        _viewAbstract.toJsonViewAbstract().forEach((field, value) {
          if (key == field) {
            controllers[key]!.text =
                getEditControllerText(_viewAbstract.getFieldValue(field));
          }
        });
      }
    });
  }

  bool isValidated(BuildContext context) {
    bool? isValidate = formKey?.currentState?.validate(focusOnInvalid: false);
    if (isValidate == null) {
      debugPrint("isValidated is null manually checking");
      return _viewAbstract.onManuallyValidate(context) != null;
    } else {
      debugPrint("isValidated is not null  automatic checking");
      return isValidate;
    }
  }

  bool hasErrorGroupWidget(BuildContext context, List<String> groupedFields) {
    for (var element in groupedFields) {
      bool? res = formKey?.currentState?.fields[element]?.validate();
      if (res != null) {
        if (res == false) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasError(BuildContext context) {
    if (_viewAbstract.isEditing()) return false;
    bool isFieldCanBeNullable = _viewAbstract.parent!
        .isFieldCanBeNullable(context, _viewAbstract.getFieldNameFromParent!);

    bool hasErr =
        formKey?.currentState?.validate(focusOnInvalid: false) == false;
    bool isNull = _viewAbstract.isNull;
    if (!isFieldCanBeNullable) {
      return hasErr;
    }
    if (isNull) {
      return false;
    }
    return hasErr;
  }

  GlobalKey<FormBuilderState>? getSubFormState(
      BuildContext context, String field) {
    if (_subformKeys.containsKey(field)) {
      return _subformKeys[field];
    }
    _subformKeys[field] = GlobalKey<FormBuilderState>(debugLabel: field);
    return _subformKeys[field];
  }

  TextEditingController getController(BuildContext context,
      {required String field,
      required dynamic value,
      bool isAutoCompleteVA = false}) {
    if (controllers.containsKey(field)) {
      // value = getEditControllerText(value);
      // controllers[field]!.text = value;
      // FocusScope.of(context).unfocus();
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => controllers[field]!.clear());
      return controllers[field]!;
    }
    value = getEditControllerText(value);
    controllers[field] = TextEditingController();
    controllers[field]!.text = value;

    controllers[field]!.addListener(() {
      bool? validate = widget
          .formKey?.currentState!.fields[_viewAbstract.getTag(field)]
          ?.validate(focusOnInvalid: false);
      // formKey?.currentState!.fields[viewAbstract.getTag(field)]?.save();
      if (validate ?? false) {
        formKey?.currentState!.fields[_viewAbstract.getTag(field)]?.save();
      }
      debugPrint("onTextChangeListener field=> $field validate=$validate");
      _viewAbstract.setFieldValue(field, controllers[field]!.text);
      _viewAbstract.onTextChangeListener(
          context, field, controllers[field]!.text,
          formKey: formKey);

      if (_viewAbstract.getParnet != null) {
        _viewAbstract.getParnet!.onTextChangeListenerOnSubViewAbstract(
            context, _viewAbstract, _viewAbstract.getFieldNameFromParent!,
            parentformKey: widget.parentFormKey);
      }
      if (isAutoCompleteVA) {
        if (controllers[field]!.text ==
            getEditControllerText(_viewAbstract.getFieldValue(field))) {
          return;
        }
        _viewAbstract =
            _viewAbstract.copyWithSetNew(field, controllers[field]!.text);
        _viewAbstract.parent?.setFieldValue(field, _viewAbstract);
        //  refreshControllers(context);
        //removed
        // viewAbstractChangeProvider.change(_viewAbstract);
      }

      // }
      // modifieController(field);
    });
    // FocusScope.of(context).unfocus();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => controllers[field]!.clear());

    _viewAbstract.addTextFieldController(field, controllers[field]!);
    return controllers[field]!;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BaseEdit build");
    Widget form = buildForm(context);
    if (widget.isTheFirst) {
      if (widget.buildAsPrint) {}
      return form;
    } else if (widget.isStandAloneField) {
      // return Text("sda");
      return ControllerViewAbstractAsOneField(
          viewAbstract: _viewAbstract,
          parent: _viewAbstract.parent!,
          children: form);
    } else {
      return getExpansionTileCustom(context, form);
    }
  }

  Widget getExpansionTileCustom(BuildContext context, Widget form) {
    bool f = _viewAbstract.getParnet?.getIsSubViewAbstractIsExpanded(
            _viewAbstract.getFieldNameFromParent ?? "") ??
        false;
    debugPrint(
        "getExpansionTileCustom initiallyExpanded => $f field=>${_viewAbstract.getFieldNameFromParent} table= ${_viewAbstract.getParnet?.getTableNameApi()}");
    if (isLargeScreen(context)) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              children: [
                _viewAbstract.getMainLabelText(context),
                const Expanded(
                  child: Divider(),
                )
              ],
            ),
          ),
          form,
        ],
      );
    }
    return ExpansionTileCustom(
        key: keyExpansionTile,
        padding: false,
        useLeadingOutSideCard: SizeConfig.isSoLargeScreen(context),
        wrapWithCardOrOutlineCard: _viewAbstract.getParentsCount() == 1,
        initiallyExpanded: f,
        // isExpanded: false,
        isDeleteButtonClicked: _viewAbstract.isNullTriggerd,
        hasError: hasError(context),
        canExpand: () => isFieldEnableSubViewAbstract(),
        leading: SizedBox(
            width: 25,
            height: 25,
            child: _viewAbstract.getCardLeadingImage(context)),
        subtitle: !_canBuildChildern()
            ? null
            : _viewAbstract.getMainLabelSubtitleText(context),
        trailing: getTrailing(context),
        title: !_canBuildChildern()
            ? form
            : _viewAbstract.getMainHeaderTextOnEdit(context),
        children: [if (_canBuildChildern()) form else const Text("dsa")]);
  }

  bool canExpand(BuildContext context) {
    String? field = _viewAbstract.getFieldNameFromParent;
    if (field == null) return true;
    // return viewAbstract.isNull
    return !_viewAbstract.isNull;
    // return viewAbstract.isNullableAlreadyFromParentCheck(field) ==
    //     false;
  }

  Widget getTrailing(BuildContext context) {
    String? field = _viewAbstract.getFieldNameFromParent;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        if (_viewAbstract.isNew()) const Icon(Icons.fiber_new_outlined),
        if (field != null)
          if (_viewAbstract.canBeNullableFromParentCheck(context, field) ??
              false)
            IconButton(
                icon: Icon(
                  !_viewAbstract.isNull
                      ? Icons.delete
                      : Icons.delete_forever_rounded,
                  color: !_viewAbstract.isNull
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  _viewAbstract.toggleIsNullable();
                  _viewAbstract.parent!.setFieldValue(
                      _viewAbstract.fieldNameFromParent!, _viewAbstract);
                  //removed
                  // viewAbstractChangeProvider.toggleNullbale();
                  if (_viewAbstract.isNull) {
                    keyExpansionTile.currentState?.collapsedOnlyIfExpanded();
                  } else {
                    keyExpansionTile.currentState?.setError(hasError(context));
                  }
                  debugPrint(
                      "onToggleNullbale pressed null ${_viewAbstract.isNull}");
                }),
        if (_viewAbstract.isEditing())
          _viewAbstract.getPopupMenuActionWidget(context, ServerActions.edit)
      ],
    );
  }

  Widget buildForm(BuildContext context) {
    debugPrint("BaseEdit buildForm ${_viewAbstract.runtimeType}");

    return FormBuilder(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        onChanged: () {
          debugPrint("BaseEdit onChanged");
          onValidateForm(context);
        },
        child: getFormContent(context));
  }

  ViewAbstract? onValidateFormReturnViewAbstract() {
    onValidateForm(context);
    return _viewAbstract;
  }

  ViewAbstract? validateFormGetViewAbstract() {
    bool res = validateForm();
    if (res) {
      formKey?.currentState!.save();
      return _viewAbstract.onAfterValidate(context);
    }
    return null;
  }

  bool validateForm() {
    bool? validate = formKey?.currentState!
        .validate(focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false);
    debugPrint("BaseEdit main checking formKey for => validation $validate");
    if (validate == false) {
      return false;
    }
    for (var entery in _subformKeys.entries) {
      bool? subValidate = entery.value.currentState?.validate(
              focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false) ??
          false;

      debugPrint(
          "BaseEdit main checking subViewAbstract for => ${entery.key} and validate value is = > $subValidate");
      if (subValidate == false) {
        return false;
      }
    }

    return true;
  }

  void onValidateForm(BuildContext context) {
    // return;
    if (widget.onValidate != null) {
      bool? validate = formKey?.currentState!
          .validate(focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false);
      _subformKeys.forEach((key, value) {
        bool? subValidate = value.currentState?.validate(
                focusOnInvalid: false, autoScrollWhenFocusOnInvalid: false) ??
            false;
        // if (subValidate) {
        //   _subformKeys[key]?.currentState!.validate(focusOnInvalid: false);
        // }
        debugPrint(
            "BaseEdit main checking subViewAbstract for => $key and validate value is = > $subValidate");
        //TODO break if we find first value with false;
        validate = (validate ?? false) && subValidate;
      });
      if (validate ?? false) {
        formKey?.currentState!.save();
        ViewAbstract? objcet = _viewAbstract.onAfterValidate(context);
        widget.onValidate!(objcet);

        groupedControllerNotifier.value = objcet;
        debugPrint("BaseEdit main form onValidate => ${objcet?.toJsonString()}",
            wrapWidth: 1024);
        if (_viewAbstract.parent != null) {
          debugPrint(
              "BaseEdit main form onValidate => ${objcet?.getTableNameApi()}  has parent and has error=> false");
          keyExpansionTile.currentState?.setError(false);
        }
      } else {
        widget.onValidate!(null);
        groupedControllerNotifier.value = null;
        if (_viewAbstract.parent != null) {
          debugPrint(
              "BaseEdit main form onValidate =>  has parent and has error=> true");
          keyExpansionTile.currentState?.setError(true);
        }
      }
    }
  }

  Widget checkToGetControllerWidget(BuildContext context, String field) {
    if (groupedControllerAfterInput?.containsKey(field) == true) {
      return ValueListenableBuilder(
        builder: (c, v, s) {
          if (v != null) {
            if ((v as ViewAbstract).toJsonViewAbstract().containsKey(field)) {
              List<String> fields = groupedControllerAfterInput![field]!;
              return Column(
                children:
                    fields.map((e) => getControllerWidget(context, e)).toList(),
              );
            }
            return getControllerWidget(context, field);
          } else {
            return getControllerWidget(context, field);
          }
        },
        valueListenable: groupedControllerNotifier,
      );
    }
    return getControllerWidget(context, field);
  }

  Widget getFormContent(BuildContext context) {
    // return SliverList(
    //     delegate: SliverChildBuilderDelegate((context, index) {
    //   return getControllerWidget(context, fields[index]);
    // }, childCount: fields.length));
    var child = <Widget>[
      // const SizedBox(height: kDefaultPadding),
      ...fields.map((e) => checkToGetControllerWidget(context, e)),

      ...groupedFields.entries.map((e) => ExpansionTileCustom(
          canExpand: () => true,
          hasError: hasErrorGroupWidget(context, e.value),
          title: Text(e.key.label),
          leading: Icon(e.key.icon),
          children:
              e.value.map((e) => getControllerWidget(context, e)).toList())),
      ...groupedHorizontalFields.entries.map((e) => Row(
          children: e.value
              .map((e) => Expanded(child: getControllerWidget(context, e)))
              .toList())),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: child,
    );
  }

  bool _canBuildChildern() {
    return true;
    // return viewAbstract.getMainFields(context: context).length > 1;
  }

  Widget getControllerWidget(BuildContext context, String field) {
    dynamic fieldValue = _viewAbstract.getFieldValue(field);
    fieldValue ??= _viewAbstract.getMirrorNewInstance(field);
    TextInputType? textInputType = _viewAbstract.getTextInputType(field);
    FormFieldControllerType textFieldTypeVA = _viewAbstract.getInputType(field);

    bool isAutoComplete = _viewAbstract.getTextInputTypeIsAutoComplete(field);
    bool isAutoCompleteViewAbstract =
        _viewAbstract.getTextInputTypeIsAutoCompleteViewAbstract(field);
    bool isAutoCompleteByCustomList =
        _viewAbstract.getTextInputIsAutoCompleteCustomList(context, field);
    debugPrint(
        "getControllerWidget field => $field isAutoComplete=> $isAutoComplete isAutoCompleteViewAbstract=>$isAutoCompleteViewAbstract  isAutoCompleteByCustomList=>$isAutoCompleteByCustomList");
    if (isAutoComplete) {
      return getControllerEditTextAutoComplete(context,
          enabled: isFieldEnabled(field),
          viewAbstract: _viewAbstract,
          field: field,
          controller: getController(context, field: field, value: fieldValue),
          currentScreenSize: widget.currentScreenSize);
    }
    if (isAutoCompleteByCustomList) {
      // return wrapController(Text("dsa"));
      return DropdownCustomListWithFormListener(
        viewAbstract: _viewAbstract,
        field: field,
        formKey: formKey,
        onSelected: (selectedObj) {
          _viewAbstract.setFieldValue(field, selectedObj);
        },
      );
    }
    if (isAutoCompleteViewAbstract) {
      if (textFieldTypeVA ==
          FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API) {
        throw Exception(
            "Do not select isAutoCompleteViewAbstract and DROP_DOWN_TEXT_SEARCH_API");
      }
      if (_viewAbstract.getParnet == null) {
        return getControllerEditText(context,
            viewAbstract: _viewAbstract,
            field: field,
            controller: getController(context, field: field, value: fieldValue),
            enabled: isFieldEnabled(field),
            currentScreenSize: widget.currentScreenSize);
      }
      return getControllerEditTextViewAbstractAutoComplete(
        context,
        viewAbstract: _viewAbstract,
        withDecoration: !widget.isStandAloneField,
        // enabled: isFieldEnabled(field),
        field: field,
        controller: getController(context,
            field: field, value: fieldValue, isAutoCompleteVA: true),
        onSelected: (selectedViewAbstract) {
          _viewAbstract.parent?.setFieldValue(field, selectedViewAbstract);
          _viewAbstract.parent
              ?.onDropdownChanged(context, field, selectedViewAbstract);
          //todo this should be setState
          _viewAbstract = selectedViewAbstract;
          refreshControllers(context, field);
          //removed
          // viewAbstractChangeProvider.change(_viewAbstract);
          keyExpansionTile.currentState?.manualExpand(false);

          // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
        },
      );
    }
    if (fieldValue is ViewAbstract) {
      fieldValue.setFieldNameFromParent(field);
      fieldValue.setParent(_viewAbstract);
      if (textFieldTypeVA == FormFieldControllerType.MULTI_CHIPS_API) {
        return wrapController(
            context: context,
            icon: fieldValue.getTextInputIconData(field),
            title: fieldValue.getTextInputLabel(context, field) ?? "-",
            EditControllerChipsFromViewAbstract(
                enabled: isFieldEnabled(field),
                parent: _viewAbstract,
                viewAbstract: fieldValue,
                field: field),
            requiredSpace: true,
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA == FormFieldControllerType.DROP_DOWN_API) {
        return wrapController(
            context: context,
            icon: fieldValue.getTextInputIconData(field),
            title: fieldValue.getTextInputLabel(context, field) ?? "-",
            EditControllerDropdownFromViewAbstract(
                formKey: formKey,
                enabled: isFieldEnabled(field),
                parent: _viewAbstract,
                viewAbstract: fieldValue,
                field: field),
            requiredSpace: true,
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA ==
          FormFieldControllerType.VIEW_ABSTRACT_AS_ONE_FIELD) {
        return BaseEditWidget(
          viewAbstract: fieldValue,
          isStandAloneField: true,
          currentScreenSize: widget.currentScreenSize,
          isTheFirst: false,
          onValidate: ((ob) {
            // String? fieldName = ob?.getFieldNameFromParent()!;
            debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
            _viewAbstract.setFieldValue(field, ob);
          }),
        );
      } else if (textFieldTypeVA ==
          FormFieldControllerType
              .DROP_DOWN_TEXT_SEARCH_API_AS_ONE_FIELD_NEW_IF_NOT_FOUND) {
      } else if (textFieldTypeVA ==
          FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API) {
        return getControllerEditTextViewAbstractAutoComplete(
            autoCompleteBySearchQuery: true,
            context,
            enabled: isFieldEnabled(field),
            viewAbstract: fieldValue,
            // enabled: isFieldEnabled(field),
            field: field,
            type: AutoCompleteFor.NORMAL,
            controller: TextEditingController(
                text: fieldValue.isEditing()
                    ? fieldValue.getMainHeaderTextOnly(context)
                    : ''), onSelected: (selectedViewAbstract) {
          // viewAbstract = selectedViewAbstract;
          fieldValue.parent?.setFieldValue(field, selectedViewAbstract);
          fieldValue.parent
              ?.onAutoComplete(context, field, selectedViewAbstract);

          refreshControllers(context, field);
          // //TODO viewAbstractChangeProvider.change(viewAbstract);
          // // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
        }, currentScreenSize: widget.currentScreenSize);
      }

      return BaseEditWidget(
        viewAbstract: fieldValue,
        parentFormKey: formKey,
        currentScreenSize: widget.currentScreenSize,
        formKey: getSubFormState(context, field),
        isTheFirst: false,
        onValidate: ((ob) {
          // String? fieldName = ob?.getFieldNameFromParent()!;
          debugPrint("BaseEdit subViewAbstract field=>$field value=>$ob");
          _viewAbstract.setFieldValue(field, ob);
          onValidateForm(context);
          debugPrint("BaseEdit main object after sub editing $_viewAbstract");

          // if (ob != null) {
          //   viewAbstractChangeProvider.change(viewAbstract);
          // }
        }),
      );
    } else if (fieldValue is ViewAbstractEnum) {
      return wrapController(
          context: context,
          icon: fieldValue.getFieldLabelIconData(context, fieldValue),
          title: fieldValue.getMainLabelText(context) ?? "-",
          EditControllerDropdown(
              parent: _viewAbstract,
              enumViewAbstract: fieldValue,
              field: field),
          requiredSpace: true);
    } else {
      if (textFieldTypeVA == FormFieldControllerType.CHECKBOX) {
        return getContollerCheckBox(context,
            viewAbstract: _viewAbstract,
            field: field,
            value: fieldValue,
            enabled: isFieldEnabled(field),
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA == FormFieldControllerType.COLOR_PICKER) {
        return getContolerColorPicker(context,
            viewAbstract: _viewAbstract,
            field: field,
            value: fieldValue,
            enabled: isFieldEnabled(field),
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA == FormFieldControllerType.IMAGE) {
        return EditControllerFilePicker(
          viewAbstract: _viewAbstract,
          field: field,
        );
      } else {
        if (textInputType == TextInputType.datetime) {
          return getControllerDateTime(context,
              viewAbstract: _viewAbstract,
              field: field,
              value: fieldValue,
              enabled: isFieldEnabled(field),
              currentScreenSize: widget.currentScreenSize);
        } else {
          return getControllerEditText(context,
              withDecoration: true,
              viewAbstract: _viewAbstract,
              field: field,
              controller:
                  getController(context, field: field, value: fieldValue),
              enabled: isFieldEnabled(field),
              currentScreenSize: widget.currentScreenSize);
        }
      }
    }
  }
}

@Deprecated(
    "we dont want ViewAbstractChangeProvider to use this method any more")
class ViewAbstractChangeProvider with ChangeNotifier {
  late ViewAbstract viewAbstract;
  ViewAbstractChangeProvider.init(this.viewAbstract);
  void change(ViewAbstract view) {
    viewAbstract = view;
    notifyListeners();
  }

  void toggleNullbale() {
    // viewAbstract.toggleIsNullable();
    notifyListeners();
    // viewAbstract.isNul
  }
}
