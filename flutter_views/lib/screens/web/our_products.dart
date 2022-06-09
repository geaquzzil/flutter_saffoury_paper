import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/screens/action_screens/list_page.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/models/tests/products.dart';

class ProductWebPage extends BaseWebPage {
  const ProductWebPage({Key? key}) : super(key: key);

  @override
  Widget getContentWidget(BuildContext context) {
    return ListPage(view_abstract: Product());
  }
}
