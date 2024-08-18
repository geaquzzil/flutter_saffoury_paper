import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

class ProfileMenuWidgetList extends StatelessWidget {
  final List<ItemModel> menuItems;

  const ProfileMenuWidgetList({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class ProfileMenuWidget extends StatelessWidget {
  CustomPopupMenuController? controller;
  bool showHeader;
  List<ItemModel> menuItems = [];
  ValueNotifier<ItemModel?>? selectedValue;
  void Function(ItemModel? value)? selectedValueVoid;
  ProfileMenuWidget(
      {super.key,
      this.controller,
      this.selectedValueVoid,
      this.showHeader = true,
      this.selectedValue});

  @override
  Widget build(BuildContext context) {
    menuItems = getListOfProfileSettings(context, controller: controller);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showHeader) const ProfileHeaderListTileWidget(),
            if (showHeader) const Divider(),
            ...menuItems.map(
              (item) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (selectedValue != null) {
                    selectedValue!.value = item;
                  } else if (selectedValueVoid != null) {
                    selectedValueVoid?.call(item);
                  } else {
                    item.onPress?.call();
                  }
                },
                child: OnHoverWidget(
                    scale: false,
                    builder: (isHovered) {
                      Widget child = popMenuItem(context, item);

                      if (selectedValue != null) {
                        return ValueListenableBuilder<ItemModel?>(
                          builder: (context, value, _) {
                            if (value == null) {
                              child = isHovered
                                  ? Card(
                                      child: child,
                                    )
                                  : child;
                              return child;
                            }
                            child = isHovered && value.title != item.title
                                ? Card(
                                    child: child,
                                  )
                                : child;
                            if (value.title == item.title) {
                              return ClippedCard(
                                  elevation: 0,
                                  // customCardColor:
                                  //     Theme.of(context).highlightColor,
                                  // .withOpacity(.5),
                                  color: kPrimaryColor,
                                  child: child);
                            } else {
                              return child;
                            }
                          },
                          valueListenable: selectedValue!,
                        );
                      }
                      child = isHovered
                          ? Card(
                              child: child,
                            )
                          : child;
                      return child;
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget popMenuItem(BuildContext context, ItemModel item) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Icon(
            item.icon,
            size: 15,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.bodySmall,
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
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: menuItems
              .map(
                (item) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    debugPrint("onTap tot");
                    controller?.hideMenu();
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 15,
                          color: Colors.black87,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              item.title,
                              style: const TextStyle(
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
    );
  }
}
