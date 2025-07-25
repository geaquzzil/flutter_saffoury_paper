import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import '../interfaces/listable_interface.dart';

class AddFromListPopupIconWidget extends StatelessWidget {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  ViewAbstract viewAbstract;
  void Function(List<ViewAbstract> selectedList) onSelected;
  List<ViewAbstract> _selectedList = [];
  ValueNotifier<List<ViewAbstract<dynamic>>>? onSeletedListItemsChanged;
  AddFromListPopupIconWidget({
    super.key,
    required this.viewAbstract,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      arrowSize: 20,
      menuOnChange: (p0) {
        debugPrint("menuOnChange $p0");
        if (!p0) {
          onSelected(_selectedList);
        }
      },
      arrowColor: Theme.of(context).colorScheme.secondaryContainer,
      menuBuilder: () => getWidget(context),
      pressType: PressType.singleClick,
      controller: _controller,
      child: const Icon(Icons.add),
    );
  }

  Widget getWidget(BuildContext context) => Cards(
    type: CardType.outline,
    child: (_) => ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: IntrinsicWidth(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          height: MediaQuery.of(context).size.height * .85,
          child: SliverApiMixinViewAbstractWidget(
            enableSelection: true,
            toListObject: (viewAbstract as ListableInterface)
                .getListablePickObject()!,
            //TODo
            // onSeletedListItemsChanged: ,
            // onSelected: (sList) {
            //   _selectedList = sList.cast();
            //   // setState(() {
            //   //   selectedList=sList.cast();
            //   // });
            // },
          ),
        ),
      ),
    ),
  );
}
