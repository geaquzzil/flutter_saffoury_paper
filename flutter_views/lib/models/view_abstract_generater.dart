import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/screens/action_screens/view_details_page.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import 'view_abstract_api.dart';

abstract class ViewAbstractController<T> extends ViewAbstractApi<T> {
  void onCardTrailingClickedView(BuildContext context) {
    onCardTrailingClicked(context);
  }

  void onCardTrailingClicked(BuildContext context) {
    debugPrint("onCardTrailingClicked");
  }

  void onCardLongClickedView(BuildContext context) {
    onCardClicked(context);
  }

  void onCardLongClicked(BuildContext context) {
    debugPrint("onCardLongClicked");
  }

  void onCardClickedView(BuildContext context) {
    onCardClicked(context);
  }

  void onCardClickedFromSearchResult(BuildContext context) {
    onCardClicked(context);
  }

  void onCardClicked(BuildContext context) {
    debugPrint("Card Clicked");
    if (SizeConfig.isDesktop(context)) {
      context
          .read<ActionViewAbstractProvider>()
          .change(this as ViewAbstract, ServerActions.view);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDetailsPage(
          object: this as ViewAbstract,
        ),
      ),
    );
  }

  void onDrawerLeadingItemClicked(BuildContext context,
      {ViewAbstract? clickedObject}) {
    debugPrint(
        'onDrawerLeadingItemClicked=> ${getMainHeaderTextOnly(context)}');
    if (SizeConfig.isDesktop(context)) {
      context.read<ActionViewAbstractProvider>().change(
          clickedObject ?? (this as ViewAbstract).getSelfNewInstance(),
          ServerActions.edit);
      return;
    }
  }

  void onDrawerItemClicked(BuildContext context) {
    debugPrint('onDrawerItemClicked=> ${getMainHeaderTextOnly(context)}');
    //Navigator.of(context).pop();
    context
        .read<DrawerViewAbstractListProvider>()
        .change(context, this as ViewAbstract);
  }

  ListTile getDrawerListTitle(BuildContext context) {
    return ListTile(
      subtitle: getMainLabelSubtitleText(context),
      leading: getIcon(),
      title: getMainLabelText(context),
      onTap: () => onDrawerItemClicked(context),
    );
  }

  // for adding drawer headers
  //  const DrawerHeader(
  //             decoration: BoxDecoration(
  //               color: Colors.blue,
  //             ),
  //             child: Text('Drawer Header'),
  //           ),
}
