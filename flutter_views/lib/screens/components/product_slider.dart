import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/card_body.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';

class ProductSlider extends StatelessWidget {
  const ProductSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.getScreenPropotionHeight(300.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CardBody(
            width: SizeConfig.getScreenPropotionWidth(200.0),
            height: SizeConfig.getScreenPropotionHeight(300.0),
            index: index,
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProductDetailsScreen(
              //       product: demoProducts[index],
              //     ),
              //   ),
              // );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 19,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "demoProducts[index].name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "demoProducts[index].modelNo",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Center(
                  child: Hero(
                    tag: "demoProducts[index].id",
                    child: Image.asset(
                      "",
                      width: SizeConfig.getScreenPropotionWidth(100),
                      height: SizeConfig.getScreenPropotionHeight(170),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Expanded(
                //   child: ProductCardBottom(
                //     : demoProducts[index],
                //   ),
                // )
              ],
            ),
          );
        },
        itemCount: 3,
      ),
    );
  }
}
