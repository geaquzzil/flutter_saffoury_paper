import 'package:flutter/material.dart';

class Category {
  int? id;
  String? name;
  IconData? image;
  bool isSelected;
  Category(
      { this.id,
       this.name,
      this.isSelected = false,
       this.image});
}
