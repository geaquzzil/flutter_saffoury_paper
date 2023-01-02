import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/products/products_types.dart';

class ListItemProductTypeCategory extends StatelessWidget {
  ProductType productType;
  ListItemProductTypeCategory({super.key, required this.productType});

  @override
  Widget build(BuildContext context) {
    String? imgUrl = productType.getImageUrl(context);
    return Container(
        width: 150,
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            image: imgUrl == null
                ? null
                : DecorationImage(
                    image: CachedNetworkImageProvider(imgUrl!),
                    fit: BoxFit.cover),
            color: imgUrl == null ? Colors.lightBlueAccent.shade400 : null,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Super\nSaving",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "20 Items",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            )));
  }
}
