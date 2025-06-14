import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';

// ..baudRate = 9600
//     // ..xonXoff = 1
//     ..parity = 0
//     ..setFlowControl(SerialPortFlowControl.none)
//     ..bits = 8
//     ..stopBits = 1;
@reflector
class BarcodeSetting extends ViewAbstract<BarcodeSetting>
    with ModifiableInterface<BarcodeSetting> {
  String? defualtBarcodePort;

  int? baudRate;
  Parity? parity;
  int? bits;
  int? stopBits;
  List<String>? ports;
  BarcodeSetting(
      {this.baudRate,
      this.bits,
      this.defualtBarcodePort,
      this.parity,
      this.ports,
      this.stopBits});

  @override
  BarcodeSetting fromJsonViewAbstract(Map<String, dynamic> json) {
    return BarcodeSetting.fromMap(json);
  }

  @override
  void onDropdownChanged(BuildContext context, String field, value,
      {GlobalKey<FormBuilderState>? formKey}) {
    if (field == "defualtBarcodePort") {
      defualtBarcodePort = value?.toString();
      notifyOtherControllers(context: context, formKey: formKey);
    }
    super.onDropdownChanged(context, field, value, formKey: formKey);
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "defualtBarcodePort": "",
        "baudRate": 9600,
        "parity": Parity.none,
        "bits": 8,
        "stopBits": 1,
        "ports": [],
      };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "defualtBarcodePort": Icons.usb_rounded,
        "baudRate": Icons.commit_sharp,
        "bits": Icons.commit_sharp,
        "parity": Icons.commit_sharp,
        "stopBits": Icons.commit_sharp,
        "ports": Icons.commit_sharp,
      };
  bool isEmptyPorts() {
    return ports == null || (ports != null && ports?.isEmpty == true);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "defualtBarcodePort":
            isEmptyPorts() ? "No available usb devices" : "COM port number",
        "baudRate": "Bits per second",
        "bits": "Data bits",
        "parity": "Parity",
        "stopBits": "Stop bits",
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) => [
        "defualtBarcodePort",
        "baudRate",
        "bits",
        "parity",
        "stopBits",
      ];
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      //todo translate
      AppLocalizations.of(context)!.barcode;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      //todo translate
      AppLocalizations.of(context)!.barcode;

  @override
  IconData getMainIconData() => Icons.drive_file_rename_outline_rounded;

  @override
  BarcodeSetting getSelfNewInstance() => BarcodeSetting();
  @override
  SortFieldValue? getSortByInitialType() => null;

  @override
  String? getTableNameApi() => null;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  // @override
  // Map<String, List<String>>? getHasControlersAfterInputtMap(
  //     BuildContext context) {
  //   List<String> l = List.from(getMainFields());
  //   // l.removeWhere((o) => o == "defualtBarcodePort");
  //   return {"defualtBarcodePort": l};
  // }
  @override
  bool isFieldEnabled(String field) {
    bool res =
        defualtBarcodePort != null ? true : field == "defualtBarcodePort";
    debugPrint(
        "isFieldEnabled defualtBarcodePort => $defualtBarcodePort field=>$field, res=>$res");
    return res;
  }

  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
      BuildContext context) {
    return {
      "defualtBarcodePort": ports ?? [],
      "baudRate": bitsList,
      "bits": databitsList,
      "stopBits": stopBitsList
    };
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{
      if (baudRate != null) "baundRate": baudRate,
      if (bits != null) "bits": bits,
      if (defualtBarcodePort != null) "defualtBarcodePort": defualtBarcodePort,
      if (parity != null) "parity": _$ParityEnumMap[parity],
      if (stopBits != null) "stopBits": stopBits
    };

    return result;
  }

  factory BarcodeSetting.fromMap(Map<String, dynamic> map) {
    return BarcodeSetting(
        baudRate: map["baudRate"],
        bits: map["bits"],
        defualtBarcodePort: map["defualtBarcodePort"],
        parity: $enumDecodeNullable(_$ParityEnumMap, map['parity']),
        stopBits: map["stopBits"]);
  }

  String toJson() => json.encode(toMap());

  factory BarcodeSetting.fromJson(String source) =>
      BarcodeSetting.fromMap(json.decode(source));

  @override
  String getModifiableMainGroupName(BuildContext context) {
    //todo translate
    return AppLocalizations.of(context)!.systemDefault;
  }

  @override
  IconData getModifibleIconData() => Icons.print;

  @override
  BarcodeSetting getModifibleSettingObject(BuildContext context) {
    BarcodeSetting bs = BarcodeSetting(ports: SerialPort.availablePorts);
    debugPrint("getModifibleSettingObject ports ${bs.ports}");
    return bs;
  }

  @override
  Future<BarcodeSetting> onModifibleSettingLoaded(BarcodeSetting loaded) async {
    await Future.delayed(Duration.zero);
    loaded.ports = SerialPort.availablePorts;
    return loaded;
  }

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);
}

const bitsList = [
  75,
  110,
  134,
  150,
  300,
  600,
  1200,
  1800,
  2400,
  4800,
  7200,
  9600,
  14400,
  19200,
  38400,
  57600,
  115200,
  12800
];
const databitsList = [4, 5, 6, 7, 8];
const stopBitsList = [1, 1.5, 2];
const _$ParityEnumMap = {
  Parity.none: 0,
  Parity.even: 2,
  Parity.mark: 3,
  Parity.odd: 1,
  Parity.space: 4,
};

enum Parity implements ViewAbstractEnum<Parity> {
  even(2),
  mark(3),
  none(0),
  odd(1),
  space(4);

  const Parity(this.value);
  final int value;
  @override
  IconData getMainIconData() {
    return Icons.commit_sharp;
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, Parity field) {
    return Icons.commit_sharp;
  }

  @override
  String getMainLabelText(BuildContext context) {
    //todo translate
    return "Parity";
  }

  @override
  String getFieldLabelString(BuildContext context, Parity field) {
    return field.name.toString().capitalizeFirstLetter();
  }

  @override
  List<Parity> getValues() => values;
}
// Even	2	
// Sets the parity bit so that the count of bits set is an even number.

// Mark	3	
// Leaves the parity bit set to 1.

// None	0	
// No parity check occurs.

// Odd	1	
// Sets the parity bit so that the count of bits set is an odd number.

// Space	4	
// Leaves the parity bit set to 0.
