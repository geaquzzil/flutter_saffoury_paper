import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:provider/provider.dart';

import '../providers/actions/action_viewabstract_provider.dart';

class BaseSharedActionDrawerNavigation extends StatelessWidget {
  const BaseSharedActionDrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StackList<StackedActions?> stack =
        context.watch<ActionViewAbstractProvider>().getStackedActions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              // scrollDirection: Axis.horizontal,
              itemCount: stack.length + 1,
              // scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                debugPrint("generate navigate icon index : $index");
                if (index == stack.length) {
                  return Icon(Icons.home);
                }
                ViewAbstract? viewAbstract = stack.get(index)!.object;
                if (viewAbstract == null) {
                  return Icon(Icons.home);
                } else {
                  return viewAbstract.getIcon();
                }
              }),
        ),
      ],
    );
  }
}
