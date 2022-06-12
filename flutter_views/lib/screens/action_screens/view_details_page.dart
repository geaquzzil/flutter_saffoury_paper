import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_view_controller/components/cart_button.dart';
import 'package:flutter_view_controller/components/normal_card_view.dart';
import 'package:flutter_view_controller/components/primary_button.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/providers/cart_provider.dart';
import 'package:flutter_view_controller/screens/action_screens/base_actions_page.dart';
import 'package:flutter_view_controller/screens/components/product_images.dart';
import 'package:provider/provider.dart';

import '../../components/main_body.dart';
import '../../models/view_abstract.dart';
import '../../size_config.dart';

import 'package:flutter_view_controller/constants.dart';

class ViewDetailsPage<T extends ViewAbstract> extends BaseActionPage {
  ViewDetailsPage({
    Key? key,
    required T object,
  }) : super(key: key, object: object);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: kPrimaryColor,
  //     appBar: AppBar(
  //       title: Row(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: kDefaultPadding,
  //             ),
  //             child: RoundedIconButton(
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //               icon: 'assets/icons/arrow.svg',
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         InkWell(
  //           onTap: () {},
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
  //             child: SvgPicture.asset(
  //               'assets/icons/cart.svg',
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //     extendBody: true,
  // }

  // Widget getBody(BuildContext context) {
  //   List<String> fields = getFields();
  //   return SizedBox(
  //     width: double.infinity,
  //     height: double.infinity,
  //     child: Column(
  //       children: [
  //         Expanded(
  //             child: Hero(
  //                 tag: object, child: object.getCardLeadingImage(context))),
  //         Expanded(child: getViewLoop(fields)),
  //       ],
  //     ),
  //   );
  // }

  ListView getViewLoop(List<String> fields) {
    return ListView.builder(
        itemCount: fields.length,
        itemBuilder: (BuildContext context, int index) {
          String label = fields[index];
          print("builder ${label}");
          dynamic fieldValue = object.getFieldValue(label);
          if (fieldValue == null) {
            return NormalCardView(
                title: label, description: "null", icon: Icons.abc);
          } else if (fieldValue is ViewAbstract) {
            return NormalCardView(
                title: "",
                description: "",
                icon: Icons.abc,
                object: fieldValue);
          } else {
            return NormalCardView(
                title: object.getFieldLabel(label, context),
                description: fieldValue,
                icon: object.getIconDataField(label, context));
          }
        });
  }

  SizedBox _body(BuildContext context) {
    List<String> fields = getFields();
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
              child: Hero(
                  tag: object, child: object.getCardLeadingImage(context))),
          Expanded(
            child: MainBody(
              padding: const EdgeInsets.only(
                left: 50,
                top: 43,
                right: 37,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          object.getHeaderTextOnly(context),
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CartButton(
                          onTap: () {},
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Photos',
                      style: TextStyle(
                        color: kTextLightColor,
                        fontSize: 22.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ProductImages(product: object),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "product.modelNo",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 2,
                      allowHalfRating: false,
                      itemCount: 5,
                      ignoreGestures:
                          true, // this disables the change star rating
                      itemSize: 20,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: kPrimaryColor,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "product.description",
                      style: TextStyle(
                        color: kTextLightColor,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: getViewLoop(fields),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  List<Widget>? getAppBarActionsView(BuildContext context) {
    return [
      InkWell(
        onTap: () {},
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: RoundedIconButton(onTap: () => null, icon: Icons.print)),
      )
    ];
  }

  @override
  Widget? getBodyActionView(BuildContext context) {
    List<String> fields = getFields();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          String label = fields[index];
          print("builder ${label}");
          dynamic fieldValue = object.getFieldValue(label);
          if (fieldValue == null) {
            return NormalCardView(
                title: label, description: "null", icon: Icons.abc);
          } else if (fieldValue is ViewAbstract) {
            return NormalCardView(
                title: "",
                description: "",
                icon: Icons.abc,
                object: fieldValue);
          } else {
            return NormalCardView(
                title: object.getFieldLabel(label, context),
                description: fieldValue,
                icon: object.getIconDataField(label, context));
          }
        },
        childCount: fields.length,
      ),
    );
  }

  @override
  Widget? getBottomNavigationBar(BuildContext context) {
    // TODO: implement getBottomNavigationBar
    return Container(
      padding: const EdgeInsets.only(
        left: 50,
        right: 37,
        bottom: 30,
      ),
      child: PrimaryButton(
        onTap: () {
          context.read<CartProvider>().addProduct(object);
        },
        text: "Buy Now",
      ),
    );
  }
}
