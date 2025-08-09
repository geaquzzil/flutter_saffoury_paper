import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';

class TestExpanded extends StatefulWidget {
  const TestExpanded({super.key});

  @override
  State<TestExpanded> createState() => _TestExpandedState();
}
class _TestExpandedState extends State<TestExpanded> {
  int width = 1;
  int length = 1;
  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: length,
      mainAxisCellCount: width,
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            // color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: const BoxDecoration(
            // color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(kDefaultPadding / 8),
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      // color: Colors.orange.withOpacity(0.1),
                      // color: info.color!.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Icon(Icons.file_copy),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_copy),
                    onPressed: () => setState(() {
                      width = width == 4 ? 1 : 4;
                      length = length == 2 ? 1 : 2;
                    }),
                  ),
                ],
              ),
              Text(
                "TITLdfscsdfdsE",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!,
              ),
              Text(
                "Descriptiewwasdsdsasfdsdsfdson",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("32%", style: Theme.of(context).textTheme.bodySmall!),
                  Text(
                    "Since last month",
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
