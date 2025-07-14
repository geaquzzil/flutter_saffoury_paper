import 'package:flutter/material.dart';
import 'package:flutter_view_controller/helper_model/category.dart';
import 'package:flutter_view_controller/helper_model/product.dart';

class AppData {
  static List<Product> productList = [
    Product(
        id: 1,
        name: 'Nike Air Max 200',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/shooe_tilt_1.png',
        category: "Trending Now"),
    Product(
        id: 2,
        name: 'Nike Air Max 97',
        price: 220.00,
        isliked: false,
        image: 'assets/shoe_tilt_2.png',
        category: "Trending Now"),
  ];
  static List<Product> cartList = [
    Product(
        id: 1,
        name: 'Nike Air Max 200',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/small_tilt_shoe_1.png',
        category: "Trending Now"),
    Product(
        id: 2,
        name: 'Nike Air Max 97',
        price: 190.00,
        isliked: false,
        image: 'assets/small_tilt_shoe_2.png',
        category: "Trending Now"),
    Product(
        id: 1,
        name: 'Nike Air Max 92607',
        price: 220.00,
        isliked: false,
        image: 'assets/small_tilt_shoe_3.png',
        category: "Trending Now"),
    Product(
        id: 2,
        name: 'Nike Air Max 200',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/small_tilt_shoe_1.png',
        category: "Trending Now"),
    // Product(
    //     id:1,
    //     name: 'Nike Air Max 97',
    //     price: 190.00,
    //     isliked: false,
    //     image: 'assets/small_tilt_shoe_2.png',
    //     category: "Trending Now"),
  ];
  static List<Category> categoryList = [
    Category(),
    Category(
        id: 1, name: "Sneakers", image: Icons.access_alarms, isSelected: true),
    Category(id: 2, name: "Jacket", image:  Icons.ac_unit),
    Category(id: 3, name: "Watch", image:  Icons.dns_sharp),
    Category(id: 4, name: "Watch", image: Icons.dangerous),
  ];
  static List<String> showThumbnailList = [
    "assets/shoe_thumb_5.png",
    "assets/shoe_thumb_1.png",
    "assets/shoe_thumb_4.png",
    "assets/shoe_thumb_3.png",
  ];
  static String description =
      "Clean lines, versatile and timeless—the people shoe returns with the Nike Air Max 90. Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, it lets you walk among the pantheon of Air. ßNothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey.";
}
