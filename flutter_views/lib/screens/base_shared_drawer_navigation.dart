import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:provider/provider.dart';

import '../providers/actions/action_viewabstract_provider.dart';

class BaseSharedActionDrawerNavigation extends StatelessWidget {
  const BaseSharedActionDrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<StackedActions?> stack =
        context.watch<ActionViewAbstractProvider>().getStackedActions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisSize: MainAxisSize.,
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              // scrollDirection: Axis.horizontal,
              itemCount: stack.length,
              // scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                debugPrint("generate navigate icon index : $index");
                dynamic v = stack[index];
                if (v == null) {
                  return getIconWithText(
                      Icons.home, "Home" + (stack.length == 1 ? "" : " >"));
                }
                ViewAbstract? viewAbstract = v!.object;
                if (viewAbstract == null) {
                  return getIconWithText(Icons.home, "Home");
                } else {
                  return getIconWithText(
                      viewAbstract.getMainIconData(),
                      viewAbstract.getMainHeaderLabelTextOnly(context) +
                          (index == stack.length ? "" : ">"));
                }
              }),
        ),
      ],
    );
  }

  Widget getIconWithText(IconData icon, String title) {
    return InkWell(
      onTap: () {
        
      },
      child: OnHoverWidget(
          scale: false,
          builder: (isHovered) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: isHovered ? Colors.orange : Colors.grey),
                  Text(
                    title,
                    style: TextStyle(
                      color: isHovered ? Colors.orange : Colors.grey,
                    ),
                  ),
                ],
              )),
    );
  }
}
