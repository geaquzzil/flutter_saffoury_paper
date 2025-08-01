import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/edit_controllers_utils.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';

class DropdownCustomListWithFormListener extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  GlobalKey<FormBuilderState>? formKey;
  Function(dynamic selectedObj) onSelected;
  DropdownCustomListWithFormListener(
      {super.key,
      required this.viewAbstract,
      required this.field,
      this.formKey,
      required this.onSelected});

  @override
  State<DropdownCustomListWithFormListener> createState() =>
      _DropdownCustomListWithFormListenerState();
}

class _DropdownCustomListWithFormListenerState
    extends State<DropdownCustomListWithFormListener> {
  late List<dynamic> list;
  late String _field;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _field = widget.field;
    //todo check if postFram is doing some errors to fileImport or export
    // postFram((c) {
    //   list = widget.viewAbstract
    //       .getTextInputIsAutoCompleteCustomListMap(context)[_field]!;
    // });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DropdownCustomListWithFormListener oldWidget) {
    list = [
      null,
      ...widget.viewAbstract
          .getTextInputIsAutoCompleteCustomListMap(context)[_field]!
    ];
    super.didUpdateWidget(oldWidget);
  }

  void postFram(Function c) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      c.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    list = [
      null,
      ...widget.viewAbstract
          .getTextInputIsAutoCompleteCustomListMap(context)[_field]!
    ];
    debugPrint("DropdownCustomListWithFormListener list $list");
    return wrapController(
      context: context,
      icon: widget.viewAbstract.getTextInputIconData(_field),
      title: widget.viewAbstract.getTextInputLabel(context, _field) ?? "-",
      FormBuilderDropdown<dynamic>(
        autofocus: false,
        isExpanded: true,
        menuMaxHeight: 400, //TODO set dynamic
        // focusColor: Colors.transparent,

        // style: const TextStyle(fontSize: 10),
        // selectedItemBuilder: (context) =>
        //     list.map((o) => Text(o.toString())).toList(),
        // isDense: true,
        // itemHeight: ,

        // ,
        borderRadius: BorderRadius.circular(kBorderRadius),
        onSaved: (newValue) {
          widget.viewAbstract.setFieldValue(_field, newValue);
          debugPrint('FormBuilderDropdown onSave=   $newValue');
        },

        // dropdownColor: Colors.orange,
        // iconSize: 15,
        // selectedItemBuilder: (context) => [const Text("das")],

        // autovalidateMode: AutovalidateMode.onUserInteraction,
        // itemHeight: 48,

        onChanged: (obj) {
          widget.viewAbstract
              .onDropdownChanged(context, _field, obj, formKey: widget.formKey);
          widget.viewAbstract.setFieldValue(_field, obj);
          debugPrint(
              'getControllerDropdownCustomList onChanged= field= $_field value=   $obj');
          widget.onSelected(obj);
        },
        onReset: () {
          debugPrint("getControllerDropdownCustomList onReset");
          debugPrint(
              "getControllerDropdownCustomList onReset list ${widget.viewAbstract.getTextInputIsAutoCompleteCustomListMap(context)[_field]!}");
          setState(() {
            list = widget.viewAbstract
                .getTextInputIsAutoCompleteCustomListMap(context)[_field]!;
            //on reset list then updated initialValue not set this funcion to set the initalValue is selected
          });
        },
        validator:
            widget.viewAbstract.getTextInputValidatorCompose(context, _field),
        name: widget.viewAbstract.getTag(_field),
        // initialValue: list.firstWhereOrNull((p0) =>
        //     widget.viewAbstract.getFieldValue(_field, context: context) ==
        //     p0),
        initialValue:
            widget.viewAbstract.getFieldValue(_field, context: context),
// decoration: getDecorationIconLabel(
//             context,
//             label: widget.viewAbstract.getFieldLabel(context, _field),
//             // icon: widget.viewAbstract.getFieldIconDataNullAccepted(_field)
//           ),
        // decoration: const InputDecoration.collapsed(hintText: ""),

        items: list
            .map((item) => DropdownMenuItem<dynamic>(
                  value: item,
                  child: buildItem(item, context),
                ))
            .toList(),
      ),

      // children: [
      //   Expanded(
      //       child:
      //           Text(widget.viewAbstract.getFieldLabel(context, _field))),
      //   Expanded(
      //     flex: 3,
      //     child: FormBuilderDropdown<dynamic>(
      //       // iconSize: 15,
      //       // selectedItemBuilder: (context) => [const Text("das")],

      //       autovalidateMode: AutovalidateMode.onUserInteraction,
      //       // itemHeight: 48,

      //       onChanged: (obj) {
      //         widget.viewAbstract.onDropdownChanged(context, _field, obj,
      //             formKey: widget.formKey);
      //         widget.viewAbstract.setFieldValue(_field, obj);
      //         debugPrint(
      //             'getControllerDropdownCustomList onChanged= field= $_field value=   $obj');
      //         widget.onSelected(obj);
      //       },
      //       onReset: () {
      //         debugPrint("getControllerDropdownCustomList onReset");
      //         debugPrint(
      //             "getControllerDropdownCustomList onReset list ${widget.viewAbstract.getTextInputIsAutoCompleteCustomListMap(context)[_field]!}");
      //         setState(() {
      //           list = widget.viewAbstract
      //               .getTextInputIsAutoCompleteCustomListMap(
      //                   context)[_field]!;
      //           //on reset list then updated initialValue not set this funcion to set the initalValue is selected
      //         });
      //       },
      //       validator: widget.viewAbstract
      //           .getTextInputValidatorCompose(context, _field),
      //       name: widget.viewAbstract.getTag(_field),
      //       // initialValue: list.firstWhereOrNull((p0) =>
      //       //     widget.viewAbstract.getFieldValue(_field, context: context) ==
      //       //     p0),
      //       initialValue:
      //           widget.viewAbstract.getFieldValue(_field, context: context),

      //       decoration: const InputDecoration.collapsed(hintText: ""),
      //       items: list
      //           .map((item) => DropdownMenuItem<dynamic>(
      //                 value: item,
      //                 child: Row(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   children: [
      //                     Icon(
      //                       widget.viewAbstract.getFieldIconData(_field),
      //                       size: 15,
      //                     ),
      //                     const SizedBox(
      //                       width: kDefaultPadding / 2,
      //                     ),
      //                     Text(
      //                       item == null
      //                           ? "${AppLocalizations.of(context)!.enter} ${widget.viewAbstract.getFieldLabel(context, _field)}"
      //                           : item.toString(),
      //                       style: Theme.of(context).textTheme.bodySmall,
      //                     )
      //                   ],

      //                   // contentPadding: EdgeInsets.zero,
      //                   // leading: const Icon(
      //                   //   Icons.print,
      //                   //   // size: 15,
      //                   // ),
      //                   // title: Text(
      //                   //   item == null
      //                   //       ? "${AppLocalizations.of(context)!.enter} ${widget.viewAbstract.getFieldLabel(context, _field)}"
      //                   //       : item.toString(),
      //                   //   style: Theme.of(context).textTheme.bodySmall,
      //                   // ),
      //                 ),
      //               ))
      //           .toList(),
      //     ),
      //   ),
      // ],
    );
  }

  //TODO this is a fix for overflow text on dropbox
  Widget buildItem(item, BuildContext context) {
    // return FittedBox(
    //   fit: BoxFit.contain,
    //   child: Text(
    //     item == null
    //         ? "${AppLocalizations.of(context)!.enter} ${widget.viewAbstract.getFieldLabel(context, _field)} das dasdasdas"
    //         : item.toString(),
    //     style: Theme.of(context).textTheme.bodySmall,
    //     overflow: TextOverflow.ellipsis,
    //   ),
    // );
    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Icon(
            widget.viewAbstract.getFieldIconData(_field),
            size: getIconSizeOnSub(context),
          ),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              item == null
                  ? "${AppLocalizations.of(context)!.enter} ${widget.viewAbstract.getFieldLabel(context, _field)}"
                  : item.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],

        // contentPadding: EdgeInsets.zero,
        // leading: const Icon(
        //   Icons.print,
        //   // size: 15,
        // ),
        // title: Text(
        //   item == null
        //       ? "${AppLocalizations.of(context)!.enter} ${widget.viewAbstract.getFieldLabel(context, _field)}"
        //       : item.toString(),
        //   style: Theme.of(context).textTheme.bodySmall,
        // ),
      ),
    );
  }
}
