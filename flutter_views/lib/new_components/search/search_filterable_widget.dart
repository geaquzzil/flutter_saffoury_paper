import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/page_large_screens_provider.dart';

class SearchFilterableWidget extends StatelessWidget {
  const SearchFilterableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Text(
              context
                  .watch<LargeScreenPageProvider>()
                  .getCurrentPageTitle(context),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}
