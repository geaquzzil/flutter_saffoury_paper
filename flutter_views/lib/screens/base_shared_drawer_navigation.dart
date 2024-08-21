import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:provider/provider.dart';

import '../providers/actions/action_viewabstract_provider.dart';

class BaseSharedActionDrawerNavigation extends StatelessWidget {
  const BaseSharedActionDrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    List<ListToDetailsSecoundPaneHelper?> stack =
        context.watch<ActionViewAbstractProvider>().getStackedActions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.,
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
                separatorBuilder: (context, index) => Center(
                      child: Icon(
                        Icons.arrow_right_outlined,
                      ),
                    ),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                // scrollDirection: Axis.horizontal,
                itemCount: stack.length,
                // scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  debugPrint("generate navigate icon index : $index");
                  dynamic v = stack[index];
                  if (v == null) {
                    return getIconWithText(context, Icons.home, "Home");
                  }
                  ViewAbstract? viewAbstract = v!.viewAbstract;
                  if (viewAbstract == null) {
                    return getIconWithText(context, Icons.home, "Home");
                  } else {
                    return getIconWithText(
                        context,
                        viewAbstract.getMainIconData(),
                        viewAbstract.getMainHeaderLabelTextOnly(context));
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget getIconWithText(BuildContext context, IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: OnHoverWidget(
          scale: false,
          builder: (isHovered) => getB(icon, isHovered, context, title)),
    );
  }

  Widget getB(
      IconData icon, bool isHovered, BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: isHovered
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_right_outlined,
            color: isHovered
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary),
        Text(
          title,
          style: TextStyle(
              color: isHovered
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }
}
