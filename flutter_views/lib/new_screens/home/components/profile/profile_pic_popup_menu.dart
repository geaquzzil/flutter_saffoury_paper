import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_list_tile_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}

class ProfilePicturePopupMenu extends StatefulWidget {
  ProfilePicturePopupMenu({Key? key}) : super(key: key);

  @override
  State<ProfilePicturePopupMenu> createState() =>
      _ProfilePicturePopupMenuState();
}

class _ProfilePicturePopupMenuState extends State<ProfilePicturePopupMenu> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  List<ItemModel> menuItems = [
    ItemModel('QussaiAl-Saffoury', Icons.chat_bubble),
    ItemModel('Edit Profile', Icons.account_box_outlined),
    ItemModel('Tasks', Icons.task),
    ItemModel('Chat', Icons.chat_bubble),
    ItemModel('Logout', Icons.logout),
  ];

  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      arrowSize: 20,
      arrowColor: Colors.white,
      menuBuilder: () => popMenuBuilderListTile(),
      pressType: PressType.singleClick,
      verticalMargin: -15,
      controller: _controller,
      child: RoundedIconButtonNetwork(
          size: 25,
          onTap: () {},
          imageUrl: context.read<AuthProvider>().getUserImageUrl),
    );
  }

  Widget popMenuBuilderListTile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [ProfileListTileWidget(), Divider()]..addAll(menuItems
                .map(
                  (item) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print("onTap");
                      _controller.hideMenu();
                    },
                    child: popMenuItem(item),
                  ),
                )
                .toList()),
          ),
        ),
      ),
    );
  }

  Container popMenuItem(ItemModel item) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Icon(
            item.icon,
            size: 15,
            color: Colors.black87,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                item.title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect popMenuBuilder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: menuItems
                .map(
                  (item) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print("onTap");
                      _controller.hideMenu();
                    },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            item.icon,
                            size: 15,
                            color: Colors.black87,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
