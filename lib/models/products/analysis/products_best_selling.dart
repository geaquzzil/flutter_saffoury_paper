import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
@Deprecated("its the same as most_popular")
class ProductsBestSelling extends Product {
  ProductsBestSelling() : super();
  @override
  String? getTableNameApi() {
    return null;
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return null;
  }

  @override
  List<String>? getCustomAction() {
    return ["products", "bestSelling"];
  }
}
