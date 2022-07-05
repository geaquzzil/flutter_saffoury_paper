import 'package:flutter/material.dart';
import 'package:flutter_view_controller/app_theme.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/light_color.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';

class ShoppingCartPageNew extends StatelessWidget {
  const ShoppingCartPageNew({Key? key}) : super(key: key);

  Widget _cartItems(BuildContext context) {
    return Column(
        children: context
            .watch<CartProvider>()
            .getProducts
            .map((x) => _item(context, x))
            .toList());
  }

  Widget _item(BuildContext context, ViewAbstract model) {
    return SizedBox(
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   left: -20,
                //   bottom: -20,
                //   child: model.getCardLeading(context),
                // )

                // model.getCardLeading(context)
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: model.getHeaderTextOnly(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      const TitleText(
                        text: '\$ ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                      TitleText(
                        text: "${model.getCartItemPrice()}",
                        fontSize: 14,
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x${model.getCartItemQuantity()}',
                      fontSize: 12,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _price(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: '${context.watch<CartProvider>().count} Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: '\$${getPrice()}',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(LightColor.orange),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: AppTheme.fullWidth(context) * .75,
        child: const TitleText(
          text: 'Next',
          color: LightColor.background,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  double getPrice() {
    double price = 0;
    // AppData.cartList.forEach((x) {
    //   price += x.price * x.id;
    // });
    return 9999;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _cartItems(context),
            const Divider(
              thickness: 1,
              height: 70,
            ),
            _price(context),
            const SizedBox(height: 30),
            _submitButton(context),
          ],
        ),
      ),
    ));
  }
}
