import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SearchField extends StatelessWidget {
  SearchField({this.onSearch, Key? key}) : super(key: key);

  final controller = TextEditingController();
  final Function(String value)? onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.search),
          title: TextField(
            controller: controller,
            // decoration: InputDecoration(
            //   filled: true,
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide.none,
            //   ),
            //   prefixIcon: const Icon(EvaIcons.search),
            //   hintText: "search..",
            //   isDense: true,
            //   fillColor: Theme.of(context).cardColor,
            // ),
            decoration: const InputDecoration(
                hintText: 'Search', border: InputBorder.none),
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              if (onSearch != null) onSearch!(controller.text);
            },
            textInputAction: TextInputAction.search,
            style: TextStyle(color: kFontColorPallets[1]),
          ),
        ),
      ),
    );
  }
}

// return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         child: ListTile(
//           leading: const Icon(Icons.search),
//           title: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//                 hintText: 'Search', border: InputBorder.none),
//             onChanged: onSearchTextChanged,
//           ),t
//           trailing: getTrailingWidget(),
//         ),
//       ),
//     );