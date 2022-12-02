import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../home/components/ext_provider.dart';

class HorizontalFilterableSelectedList extends StatelessWidget {
  const HorizontalFilterableSelectedList({super.key});

  @override
  Widget build(BuildContext context) {
    var list = context.watch<FilterableProvider>().getList.values.toList();
    var listSelectd = list
        .map((master) => master.values
            .map((e) => FilterableProviderHelper(
                field: master.field,
                fieldNameApi: master.fieldNameApi,
                values: [e],
                mainFieldName: master.mainFieldName,
                mainValuesName: [
                  master.mainValuesName[master.values.indexOf(e)]
                ]))
            .toList())
        .toList();
    List<FilterableProviderHelper> finalList = [];
    for (var element in listSelectd) {
      for (var element in element) {
        finalList.add(element);
      }
    }

    debugPrint("listSelected = $listSelectd");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50, child: _buildList(finalList)),
        _clearAllText(context)
      ],
    );
  }

  ListView _buildList(List<FilterableProviderHelper> finalList) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        width: kDefaultPadding / 2,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: finalList.length,
      itemBuilder: (context, index) {
        var item = finalList[index];
        {
          return Chip(
            // selected: true,
            label: Text(
                item.mainFieldName + " :" + item.mainValuesName[0].toString()),

            // avatar:Text(item.field),
            onDeleted: () => removeFilterableSelectedStringValue(
                context, item.field, item.values[0], item.mainValuesName[0]),
            // onSelected: (v) {
            //   if (v) {
            //     addFilterableSelected(context, item);
            //   } else {
            //     removeFilterableSelected(context, item);
            //   }
            // }
          );
        }
      },
      // ),
    );
  }

  Widget _clearAllText(BuildContext context) {
    return TextButton(
        onPressed: () {
          context.read<FilterableProvider>().clearAll();
        },
        child: Text(AppLocalizations.of(context)!.clearFiltters));
  }
}
