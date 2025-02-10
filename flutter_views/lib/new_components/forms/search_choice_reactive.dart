// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:search_choices/search_choices.dart';

typedef ColorPickerBuilder<T> = Widget Function(
  void Function() pickColor,
  Color? color,
);

/// A builder that builds a widget responsible to decide when to show
/// the picker dialog.
///
/// It has a property to access the [FormControl]
/// that is bound to [ReactiveColorPicker].
///
/// The [formControlName] is required to bind this [ReactiveColorPicker]
/// to a [FormControl].
///
/// ## Example:
///
/// ```dart
/// ReactiveBlocColorPicker(
///   formControlName: 'birthday',
/// )
/// ```
class ReactiveSearchChoice<T> extends ReactiveFormField<T, ViewAbstract> {
  final ViewAbstract viewAbstractApi;
  final PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  final double? padding;

  /// Creates a [ReactiveSearchChoice] that wraps the function [search_choices].
  ///
  /// Can optionally provide a [formControl] to bind this widget to a control.
  ///
  /// Can optionally provide a [formControlName] to bind this ReactiveFormField
  /// to a [FormControl].
  ///
  /// Must provide one of the arguments [formControl] or a [formControlName],
  /// but not both at the same time.
  ReactiveSearchChoice({
    required BuildContext context,
    super.key,
    super.formControlName,
    super.formControl,
    super.validationMessages,
    this.padding,
    required this.viewAbstractApi,

    ////////////////////////////////////////////////////////////////////////////
    InputDecoration? decoration,
    bool enableAlpha = true,
    TextStyle? labelTextStyle,
    double colorPickerWidth = 300.0,
    double pickerAreaHeightPercent = 1.0,
    BorderRadius pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    double disabledOpacity = 0.5,
    TextEditingController? hexInputController,
  }) : super(
          builder: (field) {
            final _formKey = GlobalKey<FormState>();
            final textEditingController = TextEditingController();

            addItemDialog(BuildContext context) async {
              return await showDialog(
                context: context,
                builder: (BuildContext alertContext) {
                  Widget dialogWidget = AlertDialog(
                    title: const Text("Add an item"),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            controller: textEditingController,
                            validator: (value) {
                              return ((value?.length ?? 0) < 6
                                  ? "must be at least 6 characters long"
                                  : null);
                            },
                            autofocus: true,
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                Navigator.pop(
                                    alertContext, textEditingController.text);
                              }
                            },
                            child: const Text("Ok"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(alertContext, null);
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    ),
                  );

                  return (dialogWidget);
                },
              );
            }

            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return SearchChoices.single(
              showDialogFn: (
                BuildContext context,
                Widget Function({String searchTerms}) menuWidget,
                String searchTerms,
              ) async {
                await showDialog(
                    // barrierColor: Colors.pinkAccent,
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext dialogContext) {
                      return Center(
                        child: Container(
                            constraints:
                                BoxConstraints(minWidth: 400, maxWidth: 800),
                            child: (menuWidget(searchTerms: searchTerms))),
                      );
                    });
              },

              closeButton: (String? value, BuildContext closeContext,
                  Function updateParent) {
                return false
                    ? "Close"
                    : TextButton(
                        onPressed: () {
                          addItemDialog(context).then((v) async {
                            debugPrint("addItemDialog $v");
                            if (v != null) {
                              // field.didChange(viewAbstractApi.getNewInstance(
                              //     values:
                              //         viewAbstractApi.getCopyWithTextField(v)));
                              updateParent(viewAbstractApi.getNewInstance(
                                  values: viewAbstractApi
                                      .getCopyWithFormTextField(v)));
                              Navigator.pop(closeContext);
                            } else {
                              updateParent(null);
                            }

                            // if (v != null) {
                            //   field.didChange(v == null
                            //       ? null
                            //       : viewAbstractApi.getNewInstance(
                            //           searchByAutoCompleteTextInput: v));
                            // }
                            // if (value != null) {
                            //   updateParent(viewAbstractApi.getNewInstance(
                            //       searchByAutoCompleteTextInput: value));
                            // } else {
                            //   updateParent(null);
                            // }
                          });
                        },
                        child: const Text("Add and select item"),
                      );
              },
              // icon: Icon(Icons.search),
              // selectedAggregateWidgetFn: (_) => Text("sa"),
              value: field.value,
              hint: 'this is a hint',
              searchHint: "Search capitals",
              // dialogBox: false,
              // fieldDecoration: effectiveDecoration,
              onChanged: (value) => field.didChange(value),
              dropDownDialogPadding: EdgeInsets.symmetric(horizontal: 100),
              searchDelay: 200,

              onClear: () => field.didChange(null),

              // onChanged: kIsWeb
              //     ? null
              //     : (value) {
              //         setState(() {
              //           selectedValueSingleDialogPagedFuture = value;
              //         });
              //       },
              isExpanded: true,
              // itemsPerPage: 10,
              // currentPage: currentPage,
              selectedValueWidgetFn: (item) {
                return (Center(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        margin: const EdgeInsets.all(1),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text((item as ViewAbstract)
                              .getMainHeaderTextOnly(context)),
                        ))));
              },
              searchInputDecoration: effectiveDecoration,
              futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc,
                  List<Tuple2<String, String>>? filters, int? pageNb) async {
                // String filtersString = "";
                // int i = 1;
                // filters?.forEach((element) {
                //   filtersString +=
                //       "&filter$i=${element.item1},${element.item2}";
                //   i++;
                // });
                // Response response = await get(Uri.parse(
                //         "https://searchchoices.jod.li/exampleList.php?page=${pageNb ?? 1},10${orderBy == null ? "" : "&order=$orderBy,${orderAsc ?? true ? "asc" : "desc"}"}${(keyword == null || keyword.isEmpty) ? "" : "&filter=capital,cs,$keyword"}$filtersString"))
                //     .timeout(const Duration(
                //   seconds: 10,
                // ));
                // if (response.statusCode != 200) {
                //   throw Exception("failed to get data from internet");
                // }
                // dynamic data = jsonDecode(response.body);

                List<ViewAbstract> list =
                    await (viewAbstractApi.search(5, 0, keyword ?? "",
                        context: context,
                        cache: true,
                        onResponse: OnResponseCallback(
                          onServerResponse: (response) {},
                          onServerNoMoreItems: () {},
                          onServerFailureResponse: (message) {},
                          onClientFailure: (o) {
                            //TODO translate
                            throw Exception("failed to get data from internet");
                          },
                        )) as Future<List<ViewAbstract>>);

                List<DropdownMenuItem> results = list
                    .map<DropdownMenuItem>((item) => DropdownMenuItem(
                          value: item,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 1,
                              ),
                            ),
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(item.getMainHeaderTextOnly(context)),
                            ),
                          ),
                        ))
                    .toList();
                return (Tuple2<List<DropdownMenuItem>, int>(
                    results, results.length));
              },
            );
            // return InputDecorator(
            //   decoration: effectiveDecoration.copyWith(
            //     errorText: field.errorText,
            //     enabled: field.control.enabled,
            //   ),
            //   child: IgnorePointer(
            //     ignoring: !field.control.enabled,
            //     child: Opacity(
            //       opacity: field.control.enabled ? 1 : 0.5,
            //       child:
            //           ListTile(

            //             trailing: Wrap(
            //               children: [
            //                 IconButton(
            //                   color: iconColor,
            //                   icon: const Icon(Icons.edit),
            //                   onPressed: () => pickColor(),
            //                   splashRadius: 0.01,
            //                 ),
            //                 if (field.value != null)
            //                   IconButton(
            //                     color: iconColor,
            //                     icon: const Icon(Icons.clear),
            //                     onPressed: () => field.didChange(null),
            //                     splashRadius: 0.01,
            //                   ),
            //               ],
            //             ),
            //             onTap: pickColor,
            //           ),
            //     ),
            //   ),
            // );
            // return InputDecorator(
            //   decoration: effectiveDecoration.copyWith(
            //     errorText: field.errorText,
            //     enabled: field.control.enabled,
            //   ),
            //   child: IgnorePointer(
            //     ignoring: !field.control.enabled,
            //     child: Opacity(
            //       opacity: field.control.enabled ? 1 : 0.5,
            //       child: colorPickerBuilder?.call(
            //             () => pickColor(),
            //             value,
            //           ) ??
            //           ListTile(
            //             tileColor: value,
            //             trailing: Wrap(
            //               children: [
            //                 IconButton(
            //                   color: iconColor,
            //                   icon: const Icon(Icons.edit),
            //                   onPressed: () => pickColor(),
            //                   splashRadius: 0.01,
            //                 ),
            //                 if (field.value != null)
            //                   IconButton(
            //                     color: iconColor,
            //                     icon: const Icon(Icons.clear),
            //                     onPressed: () => field.didChange(null),
            //                     splashRadius: 0.01,
            //                   ),
            //               ],
            //             ),
            //             onTap: pickColor,
            //           ),
            //     ),
            //   ),
            // );
          },
        );
}
