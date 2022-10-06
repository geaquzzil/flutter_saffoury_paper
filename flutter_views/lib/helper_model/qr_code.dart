import 'dart:convert';
import 'dart:io';


class QRCodeID {
  int iD;
  String action;
  int? quantity;
  QRCodeID({required this.iD, required this.action, this.quantity});
  String getQrCode() {
    Map<String, dynamic> map = {
      "iD": iD,
      "action": action,
      if (quantity != null) "quantity": quantity
    };
    var myString = map.toString();
    final enCodedJson = utf8.encode(map.toString());
    final gZipJson = gzip.encode(enCodedJson);
    return base64.encode(gZipJson);
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
