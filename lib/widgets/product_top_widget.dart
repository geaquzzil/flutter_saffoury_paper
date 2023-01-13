import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';
import 'package:flutter_view_controller/screens/base_shared_header_rating.dart';

class ProductTopWidget extends StatelessWidget {
  final Product product;
  const ProductTopWidget({super.key, required this.product});

  ///weight per on sheet
  ///prie per on sheet
  ///total qantity
  ///total sheet
  ///total price
  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? descriptionStyle = Theme.of(context).textTheme.caption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ProductHeaderToggle(product: product),
        ListTile(
          title: Text(
            "About",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            "dsadasdkasjdlk;jaskldjalskjdklasjdaskljlawskjlaskjsdklajsladkjlaskasdjsakjdasjdjkhaskjdhjkashdjksahjkashjkashjkasdhjkashdjksahsdjkahjkasdhkj",
            // style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        getRow(context, [
          TitleAndDescription(
              title: "Grade", description: "GT A - dsasdsasdds"),
          TitleAndDescription(title: "Size", description: "800 x 700 (mm)")
        ]),
        getRow(context, [
          TitleAndDescription(
              title: "weight per on sheet", description: "125 g"),
          TitleAndDescription(
              title: "prie per on sheet", description: "1200 SYP")
        ]),
        Text(r"oneSheet price : $2312.4"),
        SizedBox(height: kDefaultPadding),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: ListTile(
                  title: Text("totla quantity"),
                  subtitle: Text(
                    r"322.00 kg",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )),
            Expanded(
                flex: 1,
                child: ListTile(
                  title: Text("totla price"),
                  subtitle: Text(
                    r"$227.22 / $0.2 ",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )),
            Expanded(
              child: OutlinedButton(
                child: Text("Add to Card"),
                onPressed: () {},
              ),
            )
          ],
        )
        // BottomWidgetOnViewIfCartable(
        //   viewAbstract: product,
        // )
      ],
    );
  }

  Widget getRow(BuildContext context, List<TitleAndDescription> tile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: tile
          .map((e) => Expanded(
                child: ListTile(
                  title:
                      Text(e.title, style: Theme.of(context).textTheme.caption),
                  subtitle: Text(
                    e.description,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: e.icon == null ? null : Icon(e.icon),
                ),
              ))
          .toList(),
    );
  }
}

class ProductHeaderToggle extends StatelessWidget {
  const ProductHeaderToggle({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(height: 200, child: Card()),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          product.products_types!.name ?? "",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          product.products_types!.comments ?? "",
                          // style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      BaseSharedDetailsRating(
                        viewAbstract: product,
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.email)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.share))
                        ],
                      )
                      // Spacer(),
                      // ElevatedButton(
                      //   child: Text("Add to Card"),
                      //   onPressed: () {},
                      // )
                    ],
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}

class TitleAndDescription {
  String title;
  String description;
  IconData? icon;
  TitleAndDescription(
      {required this.title, required this.description, this.icon});
}
