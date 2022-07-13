import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/text_bold.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
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
  // late final _formValidationManager;
  final textController = TextEditingController();
  List<ViewAbstract> suggestionList = [];
  String lastQuery = "";
  late bool isSuggestionSelected;
  late ViewAbstract lastSuggestionSelected;
  @override
  void initState() {
    super.initState();
    isSuggestionSelected = widget.viewAbstract.isEditing();
    if (isSuggestionSelected) {
      lastSuggestionSelected = widget.viewAbstract;
    }
    // ErrorFieldsProvider errorFieldsProvider =
    //     Provider.of<ErrorFieldsProvider>(context, listen: false);
    // _formValidationManager = errorFieldsProvider.getFormValidationManager;
    textController.text =
        widget.viewAbstract.getFieldValue(widget.field).toString();
    textController.addListener(onTextChangeListener);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    super.dispose();
    textController.dispose();
  }

  Widget buildListTile(
      BuildContext context, ViewAbstract view, String searchQuery) {
    debugPrint("AutoCompleteCardItem query=> $searchQuery");
    debugPrint("AutoCompleteCardItem viewAbstract=> $view");
    return ListTile(
      leading: view.getCardLeadingCircleAvatar(context),
      title: Text(view.getCardItemDropdownText(context)),
      subtitle: Text(view.getCardItemDropdownSubtitle(context)),
    );
    return ListTile(
        onTap: () => {},
        onLongPress: () => {},
        title: TextBold(
            text: view.getMainHeaderTextOnly(context),
            regex: searchQuery.trim()),
        subtitle: TextBold(
            text: view.getMainHeaderLabelTextOnly(context),
            regex: searchQuery.trim()),
        leading: view.getCardLeadingCircleAvatar(context));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderTypeAheadCustom<String>(
            controller: textController,
            valueTransformer: (value) {
              return value?.trim();
            },
            name: widget.viewAbstract.getTag(widget.field),
            decoration:
                getDecoration(context, widget.viewAbstract, widget.field),
            maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(widget.field),
            keyboardType: widget.viewAbstract.getTextInputType(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (value) {
              isSuggestionSelected = true;
              ViewAbstract whereViewAbstract = widget.viewAbstract
                  .getListSearchViewByTextInputList(widget.field, value);

              lastSuggestionSelected = whereViewAbstract;

              context
                  .read<EditSubsViewAbstractControllerProvider>()
                  .toggleIsNew(widget.viewAbstract.getFieldNameFromParent ?? "",
                      whereViewAbstract);
              // context
              //     .read<ErrorFieldsProvider>()
              //     .removeError(widget.viewAbstract);

              // textController.text = value.getHeaderTextOnly(context);
            },

            //TODO enabled: viewAbstract.getTextInputIsEnabled(widget.field),

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
            // focusNode: _formValidationManager.getFocusNodeForField(
            //     widget.viewAbstract.getTag(widget.field),
            //     widget.viewAbstract,
            //     widget.field),
            // validator: _formValidationManager.wrapValidator(
            //     widget.viewAbstract.getTag(widget.field),
            //     widget.viewAbstract,
            //     widget.field, (value) {
            //   return widget.viewAbstract
            //       .getTextInputValidator(context, widget.field, value);
            // }),
            suggestionsCallback: (query) {
              if (query.isEmpty) return [];
              if (query.trim() == lastQuery.trim()) return [];
              lastQuery = query;
              return widget.viewAbstract.searchViewAbstractByTextInput(
                  field: widget.field, searchQuery: query);
            }),
        getSpace()
      ],
    );
  }

  void onTextChangeListener() {
    debugPrint(
        "onTextChangeListener EditSubsViewAbstractController ViewAbstract");
    String currentValue = textController.text;
    if (currentValue == lastSuggestionSelected.getMainHeaderTextOnly(context)) {
      debugPrint(
          "onTextChangeListener last text is the same as last suggestion selected returned");
      return;
    }
    if (currentValue.isEmpty) return;

    if (currentValue == widget.viewAbstract.getFieldValue(widget.field)) return;
    widget.viewAbstract =
        onChange(context, widget.viewAbstract, widget.field, currentValue);
  }
}
