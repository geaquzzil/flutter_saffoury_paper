import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/text_bold.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

@immutable
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
  late TextEditingController textController;
  List<ViewAbstract> suggestionList = [];
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();
  String lastQuery = "";
  late bool isSuggestionSelected;
  ViewAbstract? lastSuggestionSelected;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    isSuggestionSelected = widget.viewAbstract.isEditing();
    if (isSuggestionSelected) {
      lastSuggestionSelected = widget.viewAbstract;
    }
    // ErrorFieldsProvider errorFieldsProvider =
    //     Provider.of<ErrorFieldsProvider>(context, listen: false);
    // _formValidationManager = errorFieldsProvider.getFormValidationManager;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   textController.text =
        getEditControllerText(widget.viewAbstract.getFieldValue(widget.field));
    // widget.viewAbstract.getFieldValue(widget.field).toString();
    textController.addListener(onTextChangeListener);

    Provider.of<ErrorFieldsProvider>(context, listen: false)
        .addField(widget.viewAbstract, widget.field);

    });
 
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    try {
      textController.dispose();
    } catch (e) {}
    super.dispose();
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
    ErrorFieldsProvider formValidationManager =
        context.read<ErrorFieldsProvider>();

    EditSubsViewAbstractControllerProvider editSubsView =
        context.watch<EditSubsViewAbstractControllerProvider>();

    ViewAbstract watchedViewAbstract = editSubsView.getViewAbstract(
            widget.viewAbstract.getFieldNameFromParent ?? "") ??
        widget.viewAbstract;

    String text = watchedViewAbstract.getFieldValue(widget.field).toString();

    return Column(
      children: [
        FormBuilderTypeAheadCustom<String>(
            controller: textController,
            valueTransformer: (value) {
              return value?.trim();
            },
            name: widget.viewAbstract.getTag(widget.field),
            initialValue:
                widget.viewAbstract.getFieldValue(widget.field).toString(),
            decoration: getDecoration(context, widget.viewAbstract,
                field: widget.field),
            maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(widget.field),
            keyboardType: widget.viewAbstract.getTextInputType(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (value) {
              onSuggestionSelected(value, context);
            },
            loadingBuilder: (context) => CircularProgressIndicator(),
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
            validator: widget.viewAbstract
                .getTextInputValidatorCompose(context, widget.field),
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

  void onSuggestionSelected(String value, BuildContext context) {
    isSuggestionSelected = true;
    ViewAbstract whereViewAbstract = widget.viewAbstract
        .getListSearchViewByTextInputList(widget.field, value);

    lastSuggestionSelected = whereViewAbstract;

    context.read<EditSubsViewAbstractControllerProvider>().toggleIsNew(
        widget.viewAbstract.getFieldNameFromParent ?? "",
        whereViewAbstract,
        widget.field);

    // context.read<ErrorFieldsProvider>().removeError(widget.viewAbstract);

    // textController.text = value.getHeaderTextOnly(context);
  }

  void onTextChangeListener() {
    String currentValue = textController.text;
    context.read<ErrorFieldsProvider>().notify(widget.viewAbstract,
        widget.field, widget.viewAbstract.getTag(widget.field));
    if (currentValue ==
        lastSuggestionSelected?.getMainHeaderTextOnly(context)) {
      return;
    }
    if (currentValue.isEmpty) return;
    if (currentValue == widget.viewAbstract.getFieldValue(widget.field)) return;
    widget.viewAbstract =
        onChange(context, widget.viewAbstract, widget.field, currentValue);
  }
}
