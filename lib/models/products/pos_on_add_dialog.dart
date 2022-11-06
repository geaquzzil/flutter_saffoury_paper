import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/new_components/editables/editable_widget.dart';

class POSOnAddWidget extends StatefulWidget {
  Product product;
  POSOnAddWidget({Key? key, required this.product}) : super(key: key);

  @override
  State<POSOnAddWidget> createState() => _POSOnAddWidgetState();
}

class _POSOnAddWidgetState extends State<POSOnAddWidget> {
  Product? validated;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        scrollable: true,
        title: widget.product.getMainHeaderText(context),
        content: SingleChildScrollView(child: TextField()),
        actions: <Widget>[
          ElevatedButton(
            child: Text('CANCEL'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              if (validated == null) return;
              // debugPrint("textEdit ${_textFieldController.text}");
              // context.read<CartProvider>().onCartItemAdded(
              //     context,
              //     -1,
              //     widget.object as CartableProductItemInterface,
              //     double.tryParse(_textFieldController.text ?? "0"));
              setState(() {
                // codeDialog = valueText;
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
