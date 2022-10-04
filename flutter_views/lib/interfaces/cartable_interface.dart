import 'package:flutter/material.dart';


abstract class CartableMasterObject{
  //todo show other info like customer info
  

}
abstract class CartableDetailItemInterface {
  
  String getCartItemDescription(BuildContext context);
  String getCartItemSubtitle(BuildContext context);
  double getCartItemPrice();
  double getCartItemUnitPrice();
  double getCartItemQuantity();

  void onCartItemAdded(BuildContext context);
  void onCartItemRemoved(BuildContext context);

  bool isEqualsCartItem(CartableDetailItemInterface other);

}
