import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../home/components/ext_provider.dart';

class HorizontalFilterableSelectedList extends StatelessWidget {
  Map<String, FilterableProviderHelper>? onFilterable;

  Function(Map<String, FilterableProviderHelper>? onFilter)?
      onFilterableChanged;
  HorizontalFilterableSelectedList(
      {super.key, this.onFilterable, this.onFilterableChanged});

  @override
  Widget build(BuildContext context) {
    List<FilterableProviderHelper> finalList =
        getAllSelectedFiltersRead(context);

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
            
            label: Text("${item.mainFieldName} :${item.mainValuesName[0]}"),

            // avatar:Text(item.field),
            onDeleted: () {
              if (onFilterable != null) {
                onFilterable = FilterableProvider.removeStatic(
                    onFilterable!, item.field,
                    value: item.values[0],
                    mainValueName: item.mainValuesName[0]);
                onFilterableChanged?.call(onFilterable!);
                return;
              }
              removeFilterableSelectedStringValue(
                  context, item.field, item.values[0], item.mainValuesName[0]);
              notifyListApi(context);
            },
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
    if (kIsWeb) {
      if (onFilterable == null) {
        return const SizedBox();
      } else if (onFilterable?.isEmpty ?? false) {
        return const SizedBox();
      } else {
        return TextButton(
          child: const Text("CLEAR FILTERS"),
          onPressed: () {
            onFilterableChanged?.call(null);
          },
        );
      }
    }
    return TextButton(
        onPressed: () {
          context.read<FilterableProvider>().clearAll();
          notifyFilterableListApiIsCleared(context);
        },
        child: Text(AppLocalizations.of(context)!.clearFiltters));
  }
}
