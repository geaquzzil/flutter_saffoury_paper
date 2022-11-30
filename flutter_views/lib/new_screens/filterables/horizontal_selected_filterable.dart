import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

class HorizontalFilterableSelectedList extends StatelessWidget {
  const HorizontalFilterableSelectedList({super.key});

  @override
  Widget build(BuildContext context) {
   var list =
        context.watch<FilterableProvider>().getList.values.toList();

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(width: kDefaultPadding,),
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (isLoading && index == data.length) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.loading),
                const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )),
              ],
            ),
          ));
        }
        return widget.listItembuilder == null
            ? ListCardItemHorizontal(object: data[index])
            : widget.listItembuilder!(data[index]);
        // return data[index].getCardView(context);
      },
      // ),
    );
  }
}
