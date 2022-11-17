import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../interfaces/cartable_interface.dart';
import '../../models/view_abstract.dart';
import '../../models/view_abstract_inputs_validaters.dart';
import '../../new_components/tables_widgets/cart_data_table_master.dart';
import '../../screens/base_shared_actions_header.dart';
import '../edit/controllers/edit_controller_checkbox.dart';
import '../edit/controllers/edit_controller_dropdown.dart';
import '../edit/controllers/edit_controller_dropdown_api.dart';
import '../edit/controllers/edit_controller_file_picker.dart';
import '../edit/controllers/ext.dart';
import 'edit_controllers_utils.dart';

@immutable
class BaseEditWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  bool isTheFirst;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late List<String> fields;
  Map<String, TextEditingController> controllers = {};
  late ViewAbstractChangeProvider viewAbstractChangeProvider;
  void Function(ViewAbstract? viewAbstract)? onValidate;
  BaseEditWidget(
      {Key? key,
      required this.viewAbstract,
      required this.isTheFirst,
      this.onValidate})
      : super(key: key);
  void init(BuildContext context) {
    viewAbstractChangeProvider = ViewAbstractChangeProvider.init(viewAbstract);

    // _formKey = Provider.of<ErrorFieldsProvider>(context, listen: false)
    //     .getFormBuilderState;

    fields = viewAbstract.getMainFields();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewAbstract.hasParent()) {
        viewAbstractChangeProvider.notifyListeners();
      }
    });
  }

  bool isFieldEnabled(String field) {
    if (!viewAbstract.hasParent()) return viewAbstract.isFieldEnabled(field);
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

  bool hasError(BuildContext context) {
    bool isFieldCanBeNullable = viewAbstract.parent!
        .isFieldCanBeNullable(context, viewAbstract.getFieldNameFromParent!);

    bool hasErr = _formKey.currentState?.validate() == false;
    bool isNull = viewAbstract.isNull;
    if (!isFieldCanBeNullable) {
      return hasErr;
    }
    if (isNull) {
      return false;
    }
    return hasErr;
  }

  TextEditingController getController(BuildContext context,
      {required String field,
      required dynamic value,
      bool isAutoCompleteVA = false}) {
    if (controllers.containsKey(field)) {
      return controllers[field]!;
    }
    value = getEditControllerText(value);
    controllers[field] = TextEditingController();
    controllers[field]!.text = value;
    controllers[field]!.addListener(() {
      viewAbstract.onTextChangeListener(
          context, field, controllers[field]!.text);
      bool? validate =
          _formKey.currentState!.fields[viewAbstract.getTag(field)]?.validate();
      if (validate ?? false) {
        _formKey.currentState!.fields[viewAbstract.getTag(field)]?.save();
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
        Widget? table;
        if (viewAbstract is CartableInvoiceMasterObjectInterface) {
          table = CartDataTableMaster(
              action: ServerActions.edit,
              obj: viewAbstract as CartableInvoiceMasterObjectInterface);
        }
        Widget form = SingleChildScrollView(
            controller: ScrollController(),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                // if (isTheFirst)
                //   BaseSharedHeaderViewDetailsActions(
                //     viewAbstract: viewAbstract,
                //   ),
                buildForm(context),
                if (table != null) table,
              ],
            ));

        return isTheFirst
            ? form
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ExpansionTileCustom(
                    // initiallyExpanded: !viewAbstract.isNull,
                    // isExpanded: false,
                    hasError: hasError(context),
                    canExpand: () => true,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: viewAbstract.getCardLeading(context),
                    ),
                    subtitle: viewAbstract.getMainLabelSubtitleText(context),
                    trailing: getTrailing(context),
                    title: viewAbstract.getMainHeaderTextOnEdit(context),
                    children: [form]),
              );
      }),
    );
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
    return SizedBox(
      width: 200,
      height: double.infinity,
      child: Row(
        children: [
          // AnimatedIcon(icon: AnimatedIcons.add_event, progress: progress)
          Spacer(),
          if (viewAbstract.isNew()) Icon(Icons.new_label_sharp),
          if (field != null)
            if (viewAbstract.canBeNullableFromParentCheck(context, field!) ??
                false)
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: viewAbstract.isNull
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    viewAbstract.toggleIsNullable();
                    viewAbstract.parent!.setFieldValue(
                        viewAbstract.fieldNameFromParent!, viewAbstract);
                    viewAbstractChangeProvider.toggleNullbale();

                    debugPrint(
                        "onToggleNullbale pressed null ${viewAbstract.isNull}");
                  }),
          if (viewAbstract.isEditing())
            viewAbstract.getPopupMenuActionWidget(context, ServerActions.edit)
        ],
      ),
    );
  }

  FormBuilder buildForm(BuildContext context) {
    debugPrint("_BaseEdit buildForm ${viewAbstract.runtimeType}");
    return FormBuilder(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        onChanged: () {
          if (onValidate != null) {
            bool validate = _formKey.currentState!.validate();
            if (validate) {
              _formKey.currentState!.save();
              onValidate!(viewAbstract);
            }
          }
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              ...fields.map((e) => buildWidget(context, e)).toList(),
              // ElevatedButton(
              //   onPressed: () {
              //     // validate();
              //   },
              //   child: const Text('Subment'),
              // )
            ]));
  }

  Widget buildWidget(BuildContext context, String field) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    fieldValue ??= viewAbstract.getMirrorNewInstance(field);
    TextInputType? textInputType = viewAbstract.getTextInputType(field);
    ViewAbstractControllerInputType textFieldTypeVA =
        viewAbstract.getInputType(field);

    bool isAutoComplete = viewAbstract.getTextInputTypeIsAutoComplete(field);
    bool isAutoCompleteViewAbstract =
        viewAbstract.getTextInputTypeIsAutoCompleteViewAbstract(field);
    // if(fieldType== ViewAbstractEnum){
    //   return EditControllerDropdown(enumViewAbstract: enumViewAbstract, field: field)
    // }
    if (isAutoComplete) {
      return getControllerEditTextAutoComplete(context,
          viewAbstract: viewAbstract,
          field: field,
          controller: getController(context, field: field, value: fieldValue));
    }
    if (isAutoCompleteViewAbstract) {
      return getControllerEditTextViewAbstractAutoComplete(
        context,
        viewAbstract: viewAbstract,
        field: field,
        controller: getController(context,
            field: field, value: fieldValue, isAutoCompleteVA: true),
        onSelected: (selectedViewAbstract) {
          viewAbstract = selectedViewAbstract;
          viewAbstract.parent?.setFieldValue(field, selectedViewAbstract);
          refreshControllers(context, field);
          viewAbstractChangeProvider.change(viewAbstract);
          // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
        },
      );
    }
    if (fieldValue is ViewAbstract) {
      fieldValue.setFieldNameFromParent(field);
      fieldValue.setParent(viewAbstract);

      if (textFieldTypeVA == ViewAbstractControllerInputType.DROP_DOWN_API) {
        return EditControllerDropdownFromViewAbstract(
            parent: viewAbstract, viewAbstract: fieldValue, field: field);
      }
      return BaseEditWidget(
        viewAbstract: fieldValue,
        isTheFirst: false,
        onValidate: ((ob) {
          // String? fieldName = ob?.getFieldNameFromParent()!;
          debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
          viewAbstract.setFieldValue(field, ob);
        }),
      );
    } else if (fieldValue is ViewAbstractEnum) {
      return EditControllerDropdown(
          parent: viewAbstract, enumViewAbstract: fieldValue, field: field);
    } else {
      if (textFieldTypeVA == ViewAbstractControllerInputType.CHECKBOX) {
        return EditControllerCheckBox(viewAbstract: viewAbstract, field: field);
      } else if (textFieldTypeVA ==
          ViewAbstractControllerInputType.COLOR_PICKER) {
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
      return ListTile(
        title: Text(field),
        subtitle: Text(fieldValue.toString()),
      );
    }
  }
}

class ViewAbstractChangeProvider with ChangeNotifier {
  late ViewAbstract viewAbstract;
  ViewAbstractChangeProvider.init(ViewAbstract viewAbstract) {
    this.viewAbstract = viewAbstract;
  }
  void change(ViewAbstract view) {
    this.viewAbstract = view;
    notifyListeners();
  }

  void toggleNullbale() {
    // viewAbstract.toggleIsNullable();
    notifyListeners();
    // viewAbstract.isNul
  }
}




  // Widget? _buildSubtitle(BuildContext context) {
  //   ViewAbstract viewAbstractWatched = getViewAbstractReturnSameIfNull(context,
  //       widget.viewAbstract, widget.viewAbstract.getFieldNameFromParent ?? "");
  //   return Text(viewAbstractWatched.isNew()
  //       ? "IS NEW"
  //       : viewAbstractWatched.getMainHeaderLabelTextOnly(context));
  // }

  // Widget? _buildTitle(BuildContext context) {
  //   ViewAbstract? viewAbstractWatched = getViewAbstract(
  //       context, widget.viewAbstract.getFieldNameFromParent ?? "");

  //   return (viewAbstractWatched?.isNew() ?? true)
  //       ? getIsNullable(
  //               context, widget.viewAbstract.getFieldNameFromParent ?? "")
  //           ? widget.viewAbstract.getMainNullableText(context)
  //           : viewAbstractWatched == null
  //               ? widget.viewAbstract.getMainHeaderText(context)
  //               : viewAbstractWatched.getMainHeaderText(context)
  //       : viewAbstractWatched!.getMainHeaderText(context);
  // }

  // Widget _buildLeadingIcon(BuildContext context) {
  //   ViewAbstract? viewAbstractWatched =
  //       getViewAbstract(context, getFieldNameFromParent(widget.viewAbstract));
  //   // return RoundedIconButtonTowChilds(
  //   //   largChild: viewAbstractWatched == null
  //   //       ? widget.viewAbstract.getCardLeadingCircleAvatar(context)
  //   //       : viewAbstractWatched.getCardLeadingCircleAvatar(context),
  //   //   smallIcon: Icons.add,
  //   // );
  //   Widget mainLeading = RotationTransition(
  //     turns: _iconTurns,
  //     child: viewAbstractWatched == null
  //         ? widget.viewAbstract.getCardLeadingCircleAvatar(context)
  //         : viewAbstractWatched.getCardLeadingCircleAvatar(context),
  //   );
  //   if (_isExpanded) {
  //     return RoundedIconButtonTowChilds2(
  //       largChild: mainLeading,
  //       smallIcon: Icons.add,
  //     );
  //   } else {
  //     return mainLeading;
  //   }
  // }