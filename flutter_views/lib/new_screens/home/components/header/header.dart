import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/search/search_api.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/home/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/screens/components/search_bar.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:endless/endless.dart';

class HeaderMain extends StatefulWidget {
  const HeaderMain({
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderMain> createState() => _HeaderMainState();
}

class _HeaderMainState extends State<HeaderMain> {
  @override
  Widget build(BuildContext context) {
    ViewAbstract viewAbstract =
        context.read<DrawerViewAbstractProvider>().getObject;

    // return ProfileMenu(icon: "", text: "dsa", press: () {});
    // return  SearchWidgetApi();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundedIconButton(
                  onTap: () {},
                  icon: Icons.notifications,
                ),
                const SizedBox(
                  width: kDefaultPadding / 2,
                ),
                ProfilePicturePopupMenu(),
              ],
            )));
  }
}
