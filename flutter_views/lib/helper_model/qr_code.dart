import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class QRCodeID {
  late int iD;
  late String action;

  int? quantity;
  String? extra;
  QRCodeID({required this.iD, required this.action, this.quantity, this.extra});
  String getQrCode() {
    Map<String, dynamic> map = {
      "iD": iD,
      "action": action,
      if (extra != null) "extra": extra,
      if (quantity != null) "quantity": quantity
    };
    final enCodedJson = utf8.encode(jsonEncode(map));
    final gZipJson = gzip.encode(enCodedJson);
    return base64.encode(gZipJson);
  }

  QRCodeID.init(String scaned) {
    final decodeBase64Json = base64.decode(scaned);
    final decodegZipJson = gzip.decode(decodeBase64Json);
    final originalJson = utf8.decode(decodegZipJson);
    Map<String, dynamic> map = jsonDecode(originalJson);
    iD = map["iD"];
    action = map["action"];
    quantity = map["quantity"];
    extra = map["extra"];
  }

  @override
  String toString() {
    return "{iD:$iD,action:$action,quantity:$quantity,extra:$extra}";
  }
}


// class QRCodeID{
//     public  $iD=-1;
//     public  $action='';
//     public  $quantity=0;

//     public function getQrCode($tableName,$obj){
//         $this->action=$tableName;
//         $this->iD=$obj["iD"];
//         return json_encode($this,JSON_UNESCAPED_UNICODE);
//     }
//     public function getQrCodeWithQuantity($tableName,$obj,$quantity){
//         $this->action=$tableName;
//         $this->iD=$obj["iD"];
//         $this->quantity=$quantity;
//         return json_encode($this,JSON_UNESCAPED_UNICODE);
//     }
//     public function getQrCodeCompress($tableName,$obj){
//         return base64_encode(gzcompress(getQrCode($tableName,$obj)));
//     }

// }
