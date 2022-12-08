import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/screens/view/view_view_main_page.dart';

import '../../screens/on_hover_button.dart';
import '../interfaces/listable_interface.dart';
import '../new_screens/file_reader/base_file_reader_page.dart';
import '../new_screens/lists/list_api_selected_searchable_widget.dart';

class FileReaderPopupIconWidget extends StatelessWidget {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  ViewAbstract viewAbstract;
  FileReaderPopupIconWidget({
    super.key,
    required this.viewAbstract,
  });

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
        child: const Icon(Icons.add));
  }

  Widget getWidget(BuildContext context) => OutlinedCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: IntrinsicWidth(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * .3,
                height: MediaQuery.of(context).size.height * .85,
                child: FileReaderPage(
                  viewAbstract: viewAbstract,
                )),
          ),
        ),
      );
}
