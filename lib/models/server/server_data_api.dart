import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/product_types.dart';
import 'package:flutter_saffoury_paper/models/products/qualities.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';



class ServerDataApi extends ServerData {
  List<ProductType> product_types = [];
  List<Quality> qualities=[];

  

  List<Grades> grades = [];
  List<CustomsDeclaration> customs_declarations = [];
  

  ServerDataApi() : super();
  @override
  ServerData fromJsonServerData(Map<String, dynamic> json) {
    // TODO: implement fromJsonServerData
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonServerData() {
    // TODO: implement toJsonServerData
    throw UnimplementedError();
  }
}
