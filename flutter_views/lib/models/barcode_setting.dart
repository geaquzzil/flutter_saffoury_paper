import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

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
  int? parity;
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
      defualtBarcodePort = value.toString();
    }
    super.onDropdownChanged(context, field, value, formKey: formKey);
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "defualtBarcodePort": "",
        "baudRate": 9600,
        "parity": 0,
        "bits": 8,
        "stopBits": 1,
        "ports": [],
      };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "defualtBarcodePort": Icons.list,
        "baudRate": Icons.list,
        "bits": Icons.list,
        "parity": Icons.list,
        "stopBits": Icons.list,
        "ports": Icons.list,
      };
  bool isEmptyPorts() {
    return ports == null || (ports != null && ports?.isEmpty == true);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "ports":
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
        "ports",
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

  @override
  Map<String, List<String>>? getHasControlersAfterInputtMap(
      BuildContext context) {
    List<String> l = List.from(getMainFields());
    l.removeWhere((o) => o == "ports");
    return {"ports": l};
  }

  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
      BuildContext context) {
    return {"ports": ports ?? []};
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
      if (parity != null) "parity": parity,
      if (stopBits != null) "stopBits": stopBits
    };

    return result;
  }

  factory BarcodeSetting.fromMap(Map<String, dynamic> map) {
    return BarcodeSetting(
        baudRate: map["baudRate"],
        bits: map["bits"],
        defualtBarcodePort: map["defualtBarcodePort"],
        parity: map["parity"],
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
    return BarcodeSetting(ports: SerialPort.availablePorts);
  }

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);
}
