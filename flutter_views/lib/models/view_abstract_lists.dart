import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/components/edit_text_form.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

abstract class ViewAbstractLists<T> extends ViewAbstractInputAndValidater<T> {
  MenuItemBuild getMenuItemPrint(BuildContext context) {
    return MenuItemBuild(
      'Print',
      Icons.print,
      '/print',
    );
  }

  MenuItemBuild getMenuItemEdit(BuildContext context) {
    return MenuItemBuild(
      'Edit',
      Icons.edit,
      'edit',
    );
  }

  MenuItemBuild getMenuItemView(BuildContext context) {
    return MenuItemBuild(
      'View',
      Icons.view_agenda,
      '',
    );
  }

  MenuItemBuild getMenuItemShare(BuildContext context) {
    return MenuItemBuild(
      'Share',
      Icons.share,
      'share',
    );
  }

  List<Widget>? getPopupActionsList(BuildContext context) => null;
  List<MenuItemBuild>? getPopupMenuActionsList(BuildContext context) {
    return [
      getMenuItemPrint(context),
      getMenuItemEdit(context),
      getMenuItemView(context),
      getMenuItemShare(context),
    ];
  }

  Widget getPopupMenuActionListWidget(BuildContext context) {
    //TODO for divider use PopupMenuDivider()
    return PopupMenuButton<MenuItemBuild>(
      onSelected: (MenuItemBuild result) {
        onPopupMenuActionSelected(context, result);
      },
      itemBuilder: (BuildContext context) =>
          getPopupMenuActionsList(context)?.map(buildMenuItem).toList() ?? [],
    );
  }

  PopupMenuItem<MenuItemBuild> buildMenuItem(MenuItemBuild e) => PopupMenuItem(
        value: e,
        child: Row(
          children: [
            Icon(
              e.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(e.title),
          ],
        ),
      );

  void onPopupMenuActionSelected(BuildContext context, MenuItemBuild result) {
    if (result.icon == Icons.print) {
    } else if (result.icon == Icons.edit) {
      context.read<ActionViewAbstractProvider>().change(this as ViewAbstract);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditTextField(),
        ),
      );
    }
  }
}
