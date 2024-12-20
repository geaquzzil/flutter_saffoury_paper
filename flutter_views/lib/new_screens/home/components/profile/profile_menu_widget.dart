import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';

class ProfileMenuWidgetList extends StatelessWidget {
  final List<ActionOnToolbarItem> menuItems;

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
  List<ActionOnToolbarItem> menuItems = [];
  ValueNotifier<ActionOnToolbarItem?>? selectedValue;
  CurrentScreenSize? size;
  ProfileMenuWidget(
      {super.key,
      this.controller,
      this.size,
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
                  } else {
                    item.onPress?.call();
                  }
                },
                child: isLargeScreenFromScreenSize(size)
                    ? getDesktopChild(context, item)
                    : getMobileChild(context, item),
              ),
            )
          ],
        ),
      ),
    );
  }

  void Function()? _onTap(ActionOnToolbarItem item) {
    if (selectedValue != null) {
      selectedValue!.value = item;
    } else {
      item.onPress?.call();
    }
    return null;
  }

  OnHoverWidget getDesktopChild(
      BuildContext context, ActionOnToolbarItem item) {
    return OnHoverWidget(
        scale: true,
        scaleDown: true,
        builder: (isHovered) {
          Widget child = popMenuItem(context, item, selectedValue?.value);

          if (selectedValue != null) {
            return ValueListenableBuilder<ActionOnToolbarItem?>(
              builder: (context, value, _) {
                if (value == null) {
                  child = isHovered
                      ? Card(
                          margin: EdgeInsets.zero,
                          child: child,
                        )
                      : child;
                  return child;
                }
                child = isHovered && value.actionTitle != item.actionTitle
                    ? Card(
                        margin: EdgeInsets.zero,
                        child: child,
                      )
                    : child;
                if (value.actionTitle == item.actionTitle) {
                  return ClippedCard(
                      elevation: 0,
                      // customCardColor:
                      //     Theme.of(context).highlightColor,
                      // .withOpacity(.5),
                      color: Theme.of(context).colorScheme.primary,
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
        });
  }

  Widget popMenuItem(BuildContext context, ActionOnToolbarItem item,
      ActionOnToolbarItem? value) {
    return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          selected: value?.hashCode == item.hashCode,
          leading: Icon(
            item.icon,
            size: 15,
          ),
          title: Container(
            // margin: const EdgeInsets.only(left: 10),
            // padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              item.actionTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        )

        // Row(
        //   children: <Widget>[
        //     Icon(
        //       item.icon,
        //       size: 15,
        //     ),
        //     Expanded(
        //       child: Container(
        //         margin: const EdgeInsets.only(left: 10),
        //         padding: const EdgeInsets.symmetric(vertical: 10),
        //         child: Text(
        //           item.actionTitle,
        //           style: Theme.of(context).textTheme.bodySmall,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
                              item.actionTitle,
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

  Widget getMobileChild(BuildContext context, ActionOnToolbarItem item) {
    return ListTile(
      title: Text(item.actionTitle),
      subtitle: Text("this is a description for ${item.actionTitle}"),
      trailing: Icon(item.icon),
    );
  }
}
