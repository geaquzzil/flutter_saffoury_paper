import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';

class POSOnAddWidget extends StatefulWidget {
  Product product;

  POSOnAddWidget({super.key, required this.product});

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
        content: const SingleChildScrollView(child: TextField()),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('CANCEL'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          ElevatedButton(
            child: const Text('OK'),
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
