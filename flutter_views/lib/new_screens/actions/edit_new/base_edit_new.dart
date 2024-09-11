import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_custom_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_view_abstract_asonefield.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_chipds.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/view_abstract.dart';
import '../../../models/view_abstract_inputs_validaters.dart';

import '../../edit/controllers/edit_controller_dropdown.dart';
import '../../edit/controllers/edit_controller_dropdown_api.dart';
import '../../edit/controllers/edit_controller_file_picker.dart';
import '../../edit/controllers/ext.dart';
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

  Map<String, TextEditingController> controllers = {};

  Map<String, GlobalKey<FormBuilderState>> _subformKeys = {};

  late ViewAbstractChangeProvider viewAbstractChangeProvider;

  late GlobalKey<EditSubViewAbstractHeaderState> keyExpansionTile;

  ViewAbstract? viewAbstract;

  @override
  void initState() {
    init(context);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BaseEditWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget baseEditNew");
  }

  void init(BuildContext context) {
    formKey = widget.formKey ?? GlobalKey<FormBuilderState>();
    keyExpansionTile = GlobalKey<EditSubViewAbstractHeaderState>(
        debugLabel: "${widget.viewAbstract.runtimeType}");
    viewAbstractChangeProvider =
        ViewAbstractChangeProvider.init(widget.viewAbstract);
    widget.viewAbstract
        .onBeforeGenerateView(context, action: ServerActions.edit);
    debugPrint("BaseEditNew currentScreenSize ${widget.currentScreenSize}");
    // _formKey = Provider.of<ErrorFieldsProvider>(context, listen: false)
    //     .getFormBuilderState;
    if (!widget.isRequiredSubViewAbstract) {
      fields = widget.viewAbstract
          .getMainFields(context: context)
          .where((element) => !widget.viewAbstract.isViewAbstract(element))
          .toList();
    } else {
      fields = widget.viewAbstract.getMainFields(context: context);
      groupedFields = widget.viewAbstract.getMainFieldsGroups(context);
      groupedHorizontalFields =
          widget.viewAbstract.getMainFieldsHorizontalGroups(context);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.viewAbstract.hasParent()) {
        //TODO viewAbstractChangeProvider.notifyListeners();
        keyExpansionTile.currentState?.setError(hasError(context));
      }
    });
  }

  bool isFieldEnableSubViewAbstract() {
    if (widget.viewAbstract.hasParent()) {
      bool isEnabled = widget.viewAbstract.getParnet!
          .isFieldEnabled(widget.viewAbstract.getFieldNameFromParent!);
      return isEnabled;
    }
    return true;
  }

  bool isFieldEnabled(String field) {
    if (!widget.viewAbstract.hasParent())
      return widget.viewAbstract.isFieldEnabled(field);
    if (widget.disableCheckEnableFromParent) return true;
    return widget.viewAbstract.isNew() &&
        widget.viewAbstract.isFieldEnabled(field);
  }

  void refreshControllers(BuildContext context, String currentField) {
    controllers.forEach((key, value) {
      if (key != currentField) {
        widget.viewAbstract.toJsonViewAbstract().forEach((field, value) {
          if (key == field) {
            controllers[key]!.text =
                getEditControllerText(widget.viewAbstract.getFieldValue(field));
          }
        });
      }
    });
  }

  bool isValidated(BuildContext context) {
    bool? isValidate =
        widget.formKey?.currentState?.validate(focusOnInvalid: false);
    if (isValidate == null) {
      debugPrint("isValidated is null manually checking");
      return widget.viewAbstract.onManuallyValidate(context) != null;
    } else {
      debugPrint("isValidated is not null  automatic checking");
      return isValidate;
    }
  }

  bool hasErrorGroupWidget(BuildContext context, List<String> groupedFields) {
    for (var element in groupedFields) {
      bool? res = widget.formKey?.currentState?.fields[element]?.validate();
      if (res != null) {
        if (res == false) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasError(BuildContext context) {
    if (widget.viewAbstract.isEditing()) return false;
    bool isFieldCanBeNullable = widget.viewAbstract.parent!
        .isFieldCanBeNullable(
            context, widget.viewAbstract.getFieldNameFromParent!);

    bool hasErr =
        widget.formKey?.currentState?.validate(focusOnInvalid: false) == false;
    bool isNull = widget.viewAbstract.isNull;
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
          .formKey?.currentState!.fields[widget.viewAbstract.getTag(field)]
          ?.validate(focusOnInvalid: false);
      // formKey?.currentState!.fields[viewAbstract.getTag(field)]?.save();
      if (validate ?? false) {
        widget.formKey?.currentState!.fields[widget.viewAbstract.getTag(field)]
            ?.save();
      }
      debugPrint("onTextChangeListener field=> $field validate=$validate");
      widget.viewAbstract.setFieldValue(field, controllers[field]!.text);
      widget.viewAbstract.onTextChangeListener(
          context, field, controllers[field]!.text,
          formKey: widget.formKey);

      if (widget.viewAbstract.getParnet != null) {
        widget.viewAbstract.getParnet!.onTextChangeListenerOnSubViewAbstract(
            context,
            widget.viewAbstract,
            widget.viewAbstract.getFieldNameFromParent!,
            parentformKey: widget.parentFormKey);
      }
      if (isAutoCompleteVA) {
        if (controllers[field]!.text ==
            getEditControllerText(widget.viewAbstract.getFieldValue(field))) {
          return;
        }
        viewAbstract =
            widget.viewAbstract.copyWithSetNew(field, controllers[field]!.text);
        widget.viewAbstract.parent?.setFieldValue(field, widget.viewAbstract);
        //  refreshControllers(context);

        viewAbstractChangeProvider.change(widget.viewAbstract);
      }

      // }
      // modifieController(field);
    });
    // FocusScope.of(context).unfocus();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => controllers[field]!.clear());

    widget.viewAbstract.addTextFieldController(field, controllers[field]!);
    return controllers[field]!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        TextEditingController().clear();
      },
      child: ChangeNotifierProvider.value(
        value: viewAbstractChangeProvider,
        child: Consumer<ViewAbstractChangeProvider>(
            builder: (context, provider, listTile) {
          Widget form = buildForm(context);
          if (widget.isTheFirst) {
            if (widget.buildAsPrint) {}
            return form;
          } else if (widget.isStandAloneField) {
            return Text("sda");
            return ControllerViewAbstractAsOneField(
                viewAbstract: widget.viewAbstract,
                parent: widget.viewAbstract.parent!,
                children: form);
          } else {
            return getExpansionTileCustom(context, form);
            return wrapController(getExpansionTileCustom(context, form),
                isExpansionTile: true, requiredSpace: true);
          }
        }),
      ),
    );
  }

  Widget getExpansionTileCustom(BuildContext context, Widget form) {
    bool f = widget.viewAbstract.getParnet?.getIsSubViewAbstractIsExpanded(
            widget.viewAbstract.getFieldNameFromParent ?? "") ??
        false;
    debugPrint(
        "getExpansionTileCustom initiallyExpanded => $f field=>${widget.viewAbstract.getFieldNameFromParent} table= ${widget.viewAbstract.getParnet?.getTableNameApi()}");
    return ExpansionTileCustom(
        key: keyExpansionTile,
        padding: false,
        useLeadingOutSideCard: SizeConfig.isSoLargeScreen(context),
        wrapWithCardOrOutlineCard: widget.viewAbstract.getParentsCount() == 1,
        initiallyExpanded: f,
        // isExpanded: false,
        isDeleteButtonClicked: widget.viewAbstract.isNullTriggerd,
        hasError: hasError(context),
        canExpand: () => isFieldEnableSubViewAbstract(),
        leading: SizedBox(
            width: 25,
            height: 25,
            child: widget.viewAbstract.getCardLeadingImage(context)),
        subtitle: !_canBuildChildern()
            ? null
            : widget.viewAbstract.getMainLabelSubtitleText(context),
        trailing: getTrailing(context),
        title: !_canBuildChildern()
            ? form
            : widget.viewAbstract.getMainHeaderTextOnEdit(context),
        children: [if (_canBuildChildern()) form else const Text("dsa")]);
  }

  bool canExpand(BuildContext context) {
    String? field = widget.viewAbstract.getFieldNameFromParent;
    if (field == null) return true;
    // return viewAbstract.isNull
    return !widget.viewAbstract.isNull;
    // return viewAbstract.isNullableAlreadyFromParentCheck(field) ==
    //     false;
  }

  Widget getTrailing(BuildContext context) {
    String? field = widget.viewAbstract.getFieldNameFromParent;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        if (widget.viewAbstract.isNew()) const Icon(Icons.fiber_new_outlined),
        if (field != null)
          if (widget.viewAbstract
                  .canBeNullableFromParentCheck(context, field) ??
              false)
            IconButton(
                icon: Icon(
                  !widget.viewAbstract.isNull
                      ? Icons.delete
                      : Icons.delete_forever_rounded,
                  color: !widget.viewAbstract.isNull
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  widget.viewAbstract.toggleIsNullable();
                  widget.viewAbstract.parent!.setFieldValue(
                      widget.viewAbstract.fieldNameFromParent!,
                      widget.viewAbstract);
                  viewAbstractChangeProvider.toggleNullbale();
                  if (widget.viewAbstract.isNull) {
                    keyExpansionTile.currentState?.collapsedOnlyIfExpanded();
                  } else {
                    keyExpansionTile.currentState?.setError(hasError(context));
                  }
                  debugPrint(
                      "onToggleNullbale pressed null ${widget.viewAbstract.isNull}");
                }),
        if (widget.viewAbstract.isEditing())
          widget.viewAbstract
              .getPopupMenuActionWidget(context, ServerActions.edit)
      ],
    );
  }

  Widget buildForm(BuildContext context) {
    debugPrint("_BaseEdit buildForm ${widget.viewAbstract.runtimeType}");
    
    return FormBuilder(

        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: widget.formKey,
        onChanged: () {
          debugPrint("_BaseEdit onChanged");

          // onValidateForm(context);
        },
        child: getFormContent(context));
  }

  ViewAbstract? onValidateFormReturnViewAbstract() {
    onValidateForm(context);
    return viewAbstract;
  }

  void onValidateForm(BuildContext context) {
    // return;
    if (widget.onValidate != null) {
      bool? validate = widget.formKey?.currentState!
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
        widget.formKey?.currentState!.save();
        ViewAbstract? objcet = widget.viewAbstract.onAfterValidate(context);
        widget.onValidate!(objcet);
        debugPrint("BaseEdit main form onValidate => ${objcet?.toJsonString()}",
            wrapWidth: 1024);
        if (widget.viewAbstract.parent != null) {
          debugPrint(
              "BaseEdit main form onValidate => ${objcet?.getTableNameApi()}  has parent and has error=> false");
          keyExpansionTile.currentState?.setError(false);
        }
      } else {
        widget.onValidate!(null);
        if (widget.viewAbstract.parent != null) {
          debugPrint(
              "BaseEdit main form onValidate =>  has parent and has error=> true");
          keyExpansionTile.currentState?.setError(true);
        }
      }
    }
  }

  Widget getFormContent(BuildContext context) {
    // return SliverList(
    //     delegate: SliverChildBuilderDelegate((context, index) {
    //   return getControllerWidget(context, fields[index]);
    // }, childCount: fields.length));
    var child = <Widget>[
      // const SizedBox(height: kDefaultPadding),
      ...fields.map((e) => getControllerWidget(context, e)),
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
    dynamic fieldValue = widget.viewAbstract.getFieldValue(field);
    fieldValue ??= widget.viewAbstract.getMirrorNewInstance(field);
    TextInputType? textInputType = widget.viewAbstract.getTextInputType(field);
    ViewAbstractControllerInputType textFieldTypeVA =
        widget.viewAbstract.getInputType(field);

    bool isAutoComplete =
        widget.viewAbstract.getTextInputTypeIsAutoComplete(field);
    bool isAutoCompleteViewAbstract =
        widget.viewAbstract.getTextInputTypeIsAutoCompleteViewAbstract(field);
    bool isAutoCompleteByCustomList = widget.viewAbstract
        .getTextInputIsAutoCompleteCustomList(context, field);
    debugPrint(
        "getControllerWidget field => $field isAutoComplete=> $isAutoComplete isAutoCompleteViewAbstract=>$isAutoCompleteViewAbstract  isAutoCompleteByCustomList=>$isAutoCompleteByCustomList");
    if (isAutoComplete) {
      return getControllerEditTextAutoComplete(context,
          enabled: isFieldEnabled(field),
          viewAbstract: widget.viewAbstract,
          field: field,
          controller: getController(context, field: field, value: fieldValue),
          currentScreenSize: widget.currentScreenSize);
    }
    if (isAutoCompleteByCustomList) {
      // return wrapController(Text("dsa"));
      return DropdownCustomListWithFormListener(
        viewAbstract: widget.viewAbstract,
        field: field,
        formKey: widget.formKey,
        onSelected: (selectedObj) {
          widget.viewAbstract.setFieldValue(field, selectedObj);
        },
      );
    }
    if (isAutoCompleteViewAbstract) {
      if (textFieldTypeVA ==
          ViewAbstractControllerInputType.DROP_DOWN_TEXT_SEARCH_API) {
        throw Exception(
            "Do not select isAutoCompleteViewAbstract and DROP_DOWN_TEXT_SEARCH_API");
      }
      if (widget.viewAbstract.getParnet == null) {
        return getControllerEditText(context,
            viewAbstract: widget.viewAbstract,
            field: field,
            controller: getController(context, field: field, value: fieldValue),
            enabled: isFieldEnabled(field),
            currentScreenSize: widget.currentScreenSize);
      }
      return getControllerEditTextViewAbstractAutoComplete(
        context,
        viewAbstract: widget.viewAbstract,
        withDecoration: !widget.isStandAloneField,
        // enabled: isFieldEnabled(field),
        field: field,
        controller: getController(context,
            field: field, value: fieldValue, isAutoCompleteVA: true),
        onSelected: (selectedViewAbstract) {
          widget.viewAbstract.parent
              ?.setFieldValue(field, selectedViewAbstract);
          widget.viewAbstract.parent
              ?.onDropdownChanged(context, field, selectedViewAbstract);
          viewAbstract = selectedViewAbstract;
          refreshControllers(context, field);
          viewAbstractChangeProvider.change(widget.viewAbstract);
          keyExpansionTile.currentState?.manualExpand(false);

          // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
        },
      );
    }
    if (fieldValue is ViewAbstract) {
      fieldValue.setFieldNameFromParent(field);
      fieldValue.setParent(widget.viewAbstract);
      if (textFieldTypeVA == ViewAbstractControllerInputType.MULTI_CHIPS_API) {
        return wrapController(
            EditControllerChipsFromViewAbstract(
                enabled: isFieldEnabled(field),
                parent: widget.viewAbstract,
                viewAbstract: fieldValue,
                field: field),
            requiredSpace: true,
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.DROP_DOWN_API) {
        return wrapController(
            EditControllerDropdownFromViewAbstract(
                formKey: widget.formKey,
                enabled: isFieldEnabled(field),
                parent: widget.viewAbstract,
                viewAbstract: fieldValue,
                field: field),
            requiredSpace: true,
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.VIEW_ABSTRACT_AS_ONE_FIELD) {
        return BaseEditWidget(
          viewAbstract: fieldValue,
          isStandAloneField: true,
          currentScreenSize: widget.currentScreenSize,
          isTheFirst: false,
          onValidate: ((ob) {
            // String? fieldName = ob?.getFieldNameFromParent()!;
            debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
            widget.viewAbstract.setFieldValue(field, ob);
          }),
        );
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType
              .DROP_DOWN_TEXT_SEARCH_API_AS_ONE_FIELD_NEW_IF_NOT_FOUND) {
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.DROP_DOWN_TEXT_SEARCH_API) {
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
        parentFormKey: widget.formKey,
        currentScreenSize: widget.currentScreenSize,
        formKey: getSubFormState(context, field),
        isTheFirst: false,
        onValidate: ((ob) {
          // String? fieldName = ob?.getFieldNameFromParent()!;
          debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
          widget.viewAbstract.setFieldValue(field, ob);
          // if (ob != null) {
          //   viewAbstractChangeProvider.change(viewAbstract);
          // }
        }),
      );
    } else if (fieldValue is ViewAbstractEnum) {
      return wrapController(
          EditControllerDropdown(
              parent: widget.viewAbstract,
              enumViewAbstract: fieldValue,
              field: field),
          requiredSpace: true);
    } else {
      if (textFieldTypeVA == ViewAbstractControllerInputType.CHECKBOX) {
        return getContollerCheckBox(context,
            viewAbstract: widget.viewAbstract,
            field: field,
            value: fieldValue,
            enabled: isFieldEnabled(field),
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.COLOR_PICKER) {
        return getContolerColorPicker(context,
            viewAbstract: widget.viewAbstract,
            field: field,
            value: fieldValue,
            enabled: isFieldEnabled(field),
            currentScreenSize: widget.currentScreenSize);
      } else if (textFieldTypeVA == ViewAbstractControllerInputType.IMAGE) {
        return EditControllerFilePicker(
          viewAbstract: widget.viewAbstract,
          field: field,
        );
      } else {
        if (textInputType == TextInputType.datetime) {
          return getControllerDateTime(context,
              viewAbstract: widget.viewAbstract,
              field: field,
              value: fieldValue,
              enabled: isFieldEnabled(field),
              currentScreenSize: widget.currentScreenSize);
        } else {
          return getControllerEditText(context,
              viewAbstract: widget.viewAbstract,
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
