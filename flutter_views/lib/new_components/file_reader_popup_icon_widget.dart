import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import '../new_screens/file_reader/base_file_reader_page.dart';

class FileReaderPopupIconWidget extends StatelessWidget {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  ViewAbstract viewAbstract;
  FileReaderPopupIconWidget({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      arrowSize: 20,
      menuOnChange: (p0) {
        debugPrint("menuOnChange $p0");
        if (!p0) {
          // onSelected(_selectedList);
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
    child: (v) => ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: IntrinsicWidth(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .85,
          child: FileReaderPage(extras: viewAbstract),
        ),
      ),
    ),
  );
}
