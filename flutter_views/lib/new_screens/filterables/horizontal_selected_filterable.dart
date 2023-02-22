import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/web/components/web_button.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../home/components/ext_provider.dart';

class HorizontalFilterableSelectedList extends StatelessWidget {
  ValueNotifier<Map<String, FilterableProviderHelper>?>? onFilterable;
  HorizontalFilterableSelectedList({super.key, this.onFilterable});

  @override
  Widget build(BuildContext context) {
    List<FilterableProviderHelper> finalList = getAllSelectedFilters(context,
        customFilters: onFilterable?.value ?? {});
    
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
                //todo
                Map<String, FilterableProviderHelper>? map =
                    onFilterable!.value;
                if (map != null) {
                  onFilterable!.value = FilterableProvider.removeStatic(
                      map, item.field,
                      value: item.values[0],
                      mainValueName: item.mainValuesName[0]);
                }

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
      if (onFilterable != null) {
        if (onFilterable!.value == null) return SizedBox();
        if (onFilterable!.value!.isEmpty) return SizedBox();
      }
      return WebButton(
        primary: false,
        title: "CLEAR FILTERS",
        onPressed: () {
          if (onFilterable != null) {
            onFilterable!.value = null;
          } else {
            context.read<FilterableProvider>().clearAll();
            notifyFilterableListApiIsCleared(context);
          }
        },
      );
    }
    return TextButton(
        onPressed: () {
          context.read<FilterableProvider>().clearAll();
          notifyFilterableListApiIsCleared(context);
        },
        child: Text(AppLocalizations.of(context)!.clearFiltters));
  }
}
