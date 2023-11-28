import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/customs_widget/expandable_sliver_list.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_custom_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_view_abstract_asonefield.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_chipds.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../interfaces/cartable_interface.dart';
import '../../../interfaces/listable_interface.dart';
import '../../../models/view_abstract.dart';
import '../../../models/view_abstract_inputs_validaters.dart';
import '../../../new_components/edit_listeners/controller_dropbox_list.dart';
import '../../../new_components/tables_widgets/editable_table_widget.dart';
import '../../../new_components/editables/paginated_data_table2.dart';
import '../../../new_components/tables_widgets/cart_data_table_master.dart';

import '../../edit/controllers/edit_controller_checkbox.dart';
import '../../edit/controllers/edit_controller_dropdown.dart';
import '../../edit/controllers/edit_controller_dropdown_api.dart';
import '../../edit/controllers/edit_controller_file_picker.dart';
import '../../edit/controllers/ext.dart';
import 'edit_controllers_utils.dart';

@immutable
class BaseEditWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  bool isTheFirst;
  bool isStandAloneField;
  GlobalKey<FormBuilderState>? formKey;
  late List<String> fields;
  late Map<GroupItem, List<String>> groupedFields;
  late Map<int, List<String>> groupedHorizontalFields;

  Map<String, TextEditingController> controllers = {};
  Map<String, GlobalKey<FormBuilderState>> _subformKeys = {};
  late ViewAbstractChangeProvider viewAbstractChangeProvider;
  void Function(ViewAbstract? viewAbstract)? onValidate;

  late GlobalKey<EditSubViewAbstractHeaderState> keyExpansionTile;
  bool isRequiredSubViewAbstract;

  bool requireOnValidateEvenIfNull;
  bool disableCheckEnableFromParent;
  BaseEditWidget(
      {super.key,
      this.isStandAloneField = false,
      required this.viewAbstract,
      required this.isTheFirst,
      this.formKey,
      this.disableCheckEnableFromParent = false,
      this.requireOnValidateEvenIfNull = false,
      this.isRequiredSubViewAbstract = true,
      this.onValidate});
  void init(BuildContext context) {
    formKey = formKey ?? GlobalKey<FormBuilderState>();
    keyExpansionTile = GlobalKey<EditSubViewAbstractHeaderState>(
        debugLabel: "${viewAbstract.runtimeType}");
    viewAbstractChangeProvider = ViewAbstractChangeProvider.init(viewAbstract);
    viewAbstract.onBeforeGenerateView(context, action: ServerActions.edit);

    // _formKey = Provider.of<ErrorFieldsProvider>(context, listen: false)
    //     .getFormBuilderState;
    if (!isRequiredSubViewAbstract) {
      fields = viewAbstract
          .getMainFields(context: context)
          .where((element) => !viewAbstract.isViewAbstract(element))
          .toList();
    } else {
      fields = viewAbstract.getMainFields(context: context);
      groupedFields = viewAbstract.getMainFieldsGroups(context);
      groupedHorizontalFields =
          viewAbstract.getMainFieldsHorizontalGroups(context);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewAbstract.hasParent()) {
        //TODO viewAbstractChangeProvider.notifyListeners();
        keyExpansionTile.currentState?.setError(hasError(context));
      }
    });
  }

  bool isFieldEnableSubViewAbstract() {
    if (viewAbstract.hasParent()) {
      bool isEnabled = viewAbstract.getParnet!
          .isFieldEnabled(viewAbstract.getFieldNameFromParent!);
      return isEnabled;
    }
    return true;
  }

  bool isFieldEnabled(String field) {
    if (!viewAbstract.hasParent()) return viewAbstract.isFieldEnabled(field);
    if (disableCheckEnableFromParent) return true;
    return viewAbstract.isNew() && viewAbstract.isFieldEnabled(field);
  }

  void refreshControllers(BuildContext context, String currentField) {
    controllers.forEach((key, value) {
      if (key != currentField) {
        viewAbstract.toJsonViewAbstract().forEach((field, value) {
          if (key == field) {
            controllers[key]!.text =
                getEditControllerText(viewAbstract.getFieldValue(field));
          }
        });
      }
    });
  }

  bool isValidated(BuildContext context) {
    bool? isValidate = formKey?.currentState?.validate();
    if (isValidate == null) {
      debugPrint("isValidated is null manually checking");
      return viewAbstract.onManuallyValidate(context) != null;
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
    if (viewAbstract.isEditing()) return false;
    bool isFieldCanBeNullable = viewAbstract.parent!
        .isFieldCanBeNullable(context, viewAbstract.getFieldNameFromParent!);

    bool hasErr = formKey?.currentState?.validate() == false;
    bool isNull = viewAbstract.isNull;
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
      return controllers[field]!;
    }
    value = getEditControllerText(value);
    controllers[field] = TextEditingController();
    controllers[field]!.text = value;
    controllers[field]!.addListener(() {
      viewAbstract.onTextChangeListener(
          context, field, controllers[field]!.text,
          formKey: formKey);
      bool? validate =
          formKey?.currentState!.fields[viewAbstract.getTag(field)]?.validate();
      if (validate ?? false) {
        formKey?.currentState!.fields[viewAbstract.getTag(field)]?.save();
      }
      debugPrint("onTextChangeListener field=> $field validate=$validate");
      if (isAutoCompleteVA) {
        if (controllers[field]!.text ==
            getEditControllerText(viewAbstract.getFieldValue(field))) {
          return;
        }
        viewAbstract =
            viewAbstract.copyWithSetNew(field, controllers[field]!.text);
        viewAbstract.parent?.setFieldValue(field, viewAbstract);
        //  refreshControllers(context);
        viewAbstractChangeProvider.change(viewAbstract);
      }

      // }
      // modifieController(field);
    });
    viewAbstract.addTextFieldController(field, controllers[field]!);
    return controllers[field]!;
  }

  @override
  Widget build(BuildContext context) {
    init(context);

    return ChangeNotifierProvider.value(
      value: viewAbstractChangeProvider,
      child: Consumer<ViewAbstractChangeProvider>(
          builder: (context, provider, listTile) {
        Widget form = buildForm(context);
        if (isTheFirst) {
          return form;
        } else if (isStandAloneField) {
          return ControllerViewAbstractAsOneField(
              viewAbstract: viewAbstract,
              parent: viewAbstract.parent!,
              children: form);
        } else {
          return getExpansionTileCustom(context, form);
        }
      }),
    );
  }

  Widget getExpansionTileCustom(BuildContext context, Widget form) {
    return ExpansionTileCustom(
        key: keyExpansionTile,
        padding: false,
        useLeadingOutSideCard: SizeConfig.isSoLargeScreen(context),
        wrapWithCardOrOutlineCard: viewAbstract.getParentsCount() == 1,
        initiallyExpanded: viewAbstract.getIsSubViewAbstractIsExpanded(
            viewAbstract.getFieldNameFromParent ?? ""),
        // isExpanded: false,
        isDeleteButtonClicked: viewAbstract.isNullTriggerd,
        hasError: hasError(context),
        canExpand: () => isFieldEnableSubViewAbstract(),
        leading: SizedBox(
            width: 25,
            height: 25,
            child: viewAbstract.getCardLeadingImage(context)),
        subtitle: !_canBuildChildern()
            ? null
            : viewAbstract.getMainLabelSubtitleText(context),
        trailing: getTrailing(context),
        title: !_canBuildChildern()
            ? form
            : viewAbstract.getMainHeaderTextOnEdit(context),
        children: [if (_canBuildChildern()) form else const Text("dsa")]);
  }

  bool canExpand(BuildContext context) {
    String? field = viewAbstract.getFieldNameFromParent;
    if (field == null) return true;
    // return viewAbstract.isNull
    return !viewAbstract.isNull;
    // return viewAbstract.isNullableAlreadyFromParentCheck(field) ==
    //     false;
  }

  Widget getTrailing(BuildContext context) {
    String? field = viewAbstract.getFieldNameFromParent;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        if (viewAbstract.isNew()) const Icon(Icons.fiber_new_outlined),
        if (field != null)
          if (viewAbstract.canBeNullableFromParentCheck(context, field) ??
              false)
            IconButton(
                icon: Icon(
                  !viewAbstract.isNull
                      ? Icons.delete
                      : Icons.delete_forever_rounded,
                  color: !viewAbstract.isNull
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  viewAbstract.toggleIsNullable();
                  viewAbstract.parent!.setFieldValue(
                      viewAbstract.fieldNameFromParent!, viewAbstract);
                  viewAbstractChangeProvider.toggleNullbale();
                  if (viewAbstract.isNull) {
                    keyExpansionTile.currentState?.collapsedOnlyIfExpanded();
                  } else {
                    keyExpansionTile.currentState?.setError(hasError(context));
                  }
                  debugPrint(
                      "onToggleNullbale pressed null ${viewAbstract.isNull}");
                }),
        if (viewAbstract.isEditing())
          viewAbstract.getPopupMenuActionWidget(context, ServerActions.edit)
      ],
    );
  }

  Widget buildForm(BuildContext context) {
    debugPrint("_BaseEdit buildForm ${viewAbstract.runtimeType}");
    return FormBuilder(
        autovalidateMode: AutovalidateMode.always,
        key: formKey,
        onChanged: () {
          onValidateForm(context);
        },
        child: getFormContent(context));
  }

  void onValidateForm(BuildContext context) {
    if (onValidate != null) {
      bool? validate = formKey?.currentState!.validate();
      _subformKeys.forEach((key, value) {
        bool? subValidate = value.currentState?.validate() ?? false;
        debugPrint(
            "BaseEdit main checking subViewAbstract for => $key and validate value is = > $subValidate");
        //TODO break if we find first value with false;
        validate = (validate ?? false) && subValidate;
      });
      if (validate ?? false) {
        formKey?.currentState!.save();
        ViewAbstract? objcet = viewAbstract.onAfterValidate(context);
        onValidate!(objcet);
        debugPrint("BaseEdit main form onValidate => ${objcet?.toJsonString()}",
            wrapWidth: 1024);
        if (viewAbstract.parent != null) {
          debugPrint(
              "BaseEdit main form onValidate => ${objcet?.getTableNameApi()}  has parent and has error=> false");
          keyExpansionTile.currentState?.setError(false);
        }
      } else {
        onValidate!(null);
        if (viewAbstract.parent != null) {
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
      const SizedBox(height: kDefaultPadding),
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
      children: child,
    );
  }

  bool _canBuildChildern() {
    return true;
    // return viewAbstract.getMainFields(context: context).length > 1;
  }

  Widget getControllerWidget(BuildContext context, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    fieldValue ??= viewAbstract.getMirrorNewInstance(field);
    TextInputType? textInputType = viewAbstract.getTextInputType(field);
    ViewAbstractControllerInputType textFieldTypeVA =
        viewAbstract.getInputType(field);

    bool isAutoComplete = viewAbstract.getTextInputTypeIsAutoComplete(field);
    bool isAutoCompleteViewAbstract =
        viewAbstract.getTextInputTypeIsAutoCompleteViewAbstract(field);
    bool isAutoCompleteByCustomList =
        viewAbstract.getTextInputIsAutoCompleteCustomList(context, field);
    debugPrint(
        "getControllerWidget field => $field isAutoComplete=> $isAutoComplete isAutoCompleteViewAbstract=>$isAutoCompleteViewAbstract  isAutoCompleteByCustomList=>$isAutoCompleteByCustomList");
    if (isAutoComplete) {
      return getControllerEditTextAutoComplete(context,
          enabled: isFieldEnabled(field),
          viewAbstract: viewAbstract,
          field: field,
          controller: getController(context, field: field, value: fieldValue));
    }
    if (isAutoCompleteByCustomList) {
      return DropdownCustomListWithFormListener(
        viewAbstract: viewAbstract,
        field: field,
        formKey: formKey,
        onSelected: (selectedObj) {
          viewAbstract.setFieldValue(field, selectedObj);
        },
      );
      return getControllerDropdownCustomList(
        context,
        field: field,
        viewAbstract: viewAbstract,
        list: viewAbstract
            .getTextInputIsAutoCompleteCustomListMap(context)[field]!,
        formKey: formKey,
        onSelected: (selectedObj) {
          viewAbstract.setFieldValue(field, selectedObj);
        },
      );
    }
    if (isAutoCompleteViewAbstract) {
      if (viewAbstract.getParnet == null) {
        return getControllerEditText(context,
            viewAbstract: viewAbstract,
            field: field,
            controller: getController(context, field: field, value: fieldValue),
            enabled: isFieldEnabled(field));
      }
      return getControllerEditTextViewAbstractAutoComplete(
        context,
        viewAbstract: viewAbstract,
        withDecoration: !isStandAloneField,
        // enabled: isFieldEnabled(field),
        field: field,
        controller: getController(context,
            field: field, value: fieldValue, isAutoCompleteVA: true),
        onSelected: (selectedViewAbstract) {
          viewAbstract.parent?.setFieldValue(field, selectedViewAbstract);
          viewAbstract.parent
              ?.onDropdownChanged(context, field, selectedViewAbstract);
          viewAbstract = selectedViewAbstract;
          refreshControllers(context, field);
          viewAbstractChangeProvider.change(viewAbstract);
          keyExpansionTile.currentState?.manualExpand(false);

          // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
        },
      );
    }
    if (fieldValue is ViewAbstract) {
      fieldValue.setFieldNameFromParent(field);
      fieldValue.setParent(viewAbstract);
      if (textFieldTypeVA == ViewAbstractControllerInputType.MULTI_CHIPS_API) {
        return wrapController(
            EditControllerChipsFromViewAbstract(
                enabled: isFieldEnabled(field),
                parent: viewAbstract,
                viewAbstract: fieldValue,
                field: field),
            requiredSpace: true);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.DROP_DOWN_API) {
        return wrapController(
            EditControllerDropdownFromViewAbstract(
                formKey: formKey,
                enabled: isFieldEnabled(field),
                parent: viewAbstract,
                viewAbstract: fieldValue,
                field: field),
            requiredSpace: true);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.VIEW_ABSTRACT_AS_ONE_FIELD) {
        return BaseEditWidget(
          viewAbstract: fieldValue,
          isStandAloneField: true,
          isTheFirst: false,
          onValidate: ((ob) {
            // String? fieldName = ob?.getFieldNameFromParent()!;
            debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
            viewAbstract.setFieldValue(field, ob);
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
                  : ''),
          onSelected: (selectedViewAbstract) {
            // viewAbstract = selectedViewAbstract;
            fieldValue.parent?.setFieldValue(field, selectedViewAbstract);
            fieldValue.parent
                ?.onAutoComplete(context, field, selectedViewAbstract);

            refreshControllers(context, field);
            // //TODO viewAbstractChangeProvider.change(viewAbstract);
            // // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
          },
        );
      }
      return BaseEditWidget(
        viewAbstract: fieldValue,
        formKey: getSubFormState(context, field),
        isTheFirst: false,
        onValidate: ((ob) {
          // String? fieldName = ob?.getFieldNameFromParent()!;
          debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
          viewAbstract.setFieldValue(field, ob);
          // if (ob != null) {
          //   viewAbstractChangeProvider.change(viewAbstract);
          // }
        }),
      );
    } else if (fieldValue is ViewAbstractEnum) {
      return wrapController(
          EditControllerDropdown(
              parent: viewAbstract, enumViewAbstract: fieldValue, field: field),
          requiredSpace: true);
    } else {
      if (textFieldTypeVA == ViewAbstractControllerInputType.CHECKBOX) {
        return getContollerCheckBox(context,
            viewAbstract: viewAbstract,
            field: field,
            value: fieldValue,
            enabled: isFieldEnabled(field));
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.COLOR_PICKER) {
        return getContolerColorPicker(context,
            viewAbstract: viewAbstract,
            field: field,
            value: fieldValue,
            enabled: isFieldEnabled(field));
      } else if (textFieldTypeVA == ViewAbstractControllerInputType.IMAGE) {
        return EditControllerFilePicker(
          viewAbstract: viewAbstract,
          field: field,
        );
      } else {
        if (textInputType == TextInputType.datetime) {
          return getControllerDateTime(context,
              viewAbstract: viewAbstract,
              field: field,
              value: fieldValue,
              enabled: isFieldEnabled(field));
        } else {
          return getControllerEditText(context,
              viewAbstract: viewAbstract,
              field: field,
              controller:
                  getController(context, field: field, value: fieldValue),
              enabled: isFieldEnabled(field));
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
