import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/base_action_page.dart';
import 'package:flutter_view_controller/new_screens/lists/list_sliver_gride.dart';
import 'package:palette_generator/palette_generator.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MasterToListPage extends StatefulWidget {
  ViewAbstract master;
  ViewAbstract detail;
  PaletteGenerator? color;

  MasterToListPage(
      {super.key, required this.master, required this.detail, this.color});

  @override
  State<MasterToListPage> createState() => _MasterToListPageState();
}

class _MasterToListPageState extends State<MasterToListPage> {
  Widget? firstPane;
  Widget? endPane;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          actions: [
            IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.heart_broken)),
            )
          ],
        ),
        // backgroundColor: widget.color?.darkVibrantColor?.color,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: null,
        body: getBody());
  }

  Widget getBody() {
    return Column(
      children: [
        SizedBox(height: 200, child: widget.detail.getBlurringImage(context)),
        const SizedBox(height: kDefaultPadding * 1.5),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(defaultPadding,
                defaultPadding * 2, defaultPadding, defaultPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12 * 3),
                topRight: Radius.circular(12 * 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.master.getMainHeaderLabelTextOnly(context),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Text(
                      "\$" + widget.master.getMainHeaderLabelTextOnly(context),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(
                    "A Henley shirt is a collarless pullover shirt, by a round neckline and a placket about 3 to 5 inches (8 to 13 cm) long and usually having 2–5 buttons.",
                  ),
                ),
                Text(
                  "Colors",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: defaultPadding / 2),
                // Row(
                //   children: const [
                //     ColorDot(
                //       color: Color(0xFFBEE8EA),
                //       isActive: false,
                //     ),
                //     ColorDot(
                //       color: Color(0xFF141B4A),
                //       isActive: true,
                //     ),
                //     ColorDot(
                //       color: Color(0xFFF4E5C3),
                //       isActive: false,
                //     ),
                //   ],
                // ),
                const SizedBox(height: defaultPadding * 2),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: primaryColor, shape: const StadiumBorder()),
                      child: const Text("Add to Cart"),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
