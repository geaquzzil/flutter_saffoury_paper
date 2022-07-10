import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/auto_complete_list_item.dart';
import 'package:flutter_view_controller/new_components/text_bold.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:provider/provider.dart';

class EditControllerEditTextAutoCompleteViewAbstract extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerEditTextAutoCompleteViewAbstract(
      {Key? key, required this.viewAbstract, required this.field})
      : super(key: key);

  @override
  State<EditControllerEditTextAutoCompleteViewAbstract> createState() =>
      _EditControllerEditTextAutoCompleteViewAbstractState();
}

class _EditControllerEditTextAutoCompleteViewAbstractState
    extends State<EditControllerEditTextAutoCompleteViewAbstract> {
  late final _formValidationManager;
  List<ViewAbstract> suggestionList = [];

  @override
  void initState() {
    super.initState();
    ErrorFieldsProvider errorFieldsProvider =
        Provider.of<ErrorFieldsProvider>(context, listen: false);
    _formValidationManager = errorFieldsProvider.getFormValidationManager;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    super.dispose();
  }

  Widget buildListTile(
      BuildContext context, ViewAbstract view, String searchQuery) {
    debugPrint("AutoCompleteCardItem query=> $searchQuery");
    debugPrint("AutoCompleteCardItem viewAbstract=> $view");
    return ListTile(title: Text(view.getHeaderTextOnly(context)));
    return ListTile(
        onTap: () => {},
        onLongPress: () => {},
        title: TextBold(
            text: view.getHeaderTextOnly(context), regex: searchQuery.trim()),
        subtitle: TextBold(
            text: view.getSubtitleHeaderTextOnly(context),
            regex: searchQuery.trim()),
        leading: view.getCardLeading(context));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderTypeAheadCustom<String>(
            // controller: textController,
            // valueTransformer: (value) {
            //   return value?.trim();
            // },
            name: widget.viewAbstract.getTag(widget.field),
            initialValue: widget.viewAbstract.getFieldValue(widget.field),
            decoration:
                getDecoration(context, widget.viewAbstract, widget.field),
            maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(widget.field),
            keyboardType: widget.viewAbstract.getTextInputType(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (value) {
              // textController.text = value.getHeaderTextOnly(context);
            },

            //TODO enabled: viewAbstract.getTextInputIsEnabled(widget.field),
            focusNode: _formValidationManager.getFocusNodeForField(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field),
            itemBuilder: (context, continent) {
              debugPrint("continent $continent");
              ViewAbstract whereViewAbstract = widget.viewAbstract
                  .getListSearchViewByTextInputList(widget.field, continent);
              debugPrint("founded  $whereViewAbstract");
              if (whereViewAbstract == null) {
                return Text(continent);
              }
              return buildListTile(
                context,
                whereViewAbstract,
                continent,
              );
            },
            inputFormatters:
                widget.viewAbstract.getTextInputFormatter(widget.field),
            validator: _formValidationManager.wrapValidator(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field, (value) {
              return widget.viewAbstract
                  .getTextInputValidator(context, widget.field, value);
            }),
            onSaved: (dynamic value) {
              print('onSave=   ${value?.getHeaderTextOnly(context)}');
            },
            suggestionsCallback: (query) {
              if (query.isEmpty) return [];
              return widget.viewAbstract.searchViewAbstractByTextInput(
                  field: widget.field, searchQuery: query);
            }),
        getSpace()
      ],
    );
  }
}
