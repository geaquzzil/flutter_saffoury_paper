import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../home/components/ext_provider.dart';

class HorizontalFilterableSelectedList extends StatelessWidget {
  Map<String, FilterableProviderHelper> onFilterable;

  Function(Map<String, FilterableProviderHelper>? onFilter)?
      onFilterableChanged;
  HorizontalFilterableSelectedList(
      {super.key, required this.onFilterable, this.onFilterableChanged});

  @override
  Widget build(BuildContext context) {
    List<FilterableProviderHelper> finalList =
        getAllSelectedFiltersRead(context);

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50, child: _buildList(finalList)),
          _clearAllText(context)
        ],
      ),
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
            label: Text("${item.mainFieldName} :${item.mainValuesName[0]}"),
            onDeleted: () {
              debugPrint(
                  "onFilterable before  ${onFilterable.entries.length} $onFilterable");
              onFilterable = FilterableProvider.removeStatic(
                  onFilterable, item.field,
                  value: item.values[0], mainValueName: item.mainValuesName[0]);
              debugPrint(
                  "onFilterable after  ${onFilterable.entries.length} $onFilterable");
              onFilterableChanged
                  ?.call(onFilterable.isEmpty ? null : onFilterable);
              return;
            },
          );
        }
      },
      // ),
    );
  }

  Widget _clearAllText(BuildContext context) {
    if (onFilterable.isEmpty) {
      return const SizedBox();
    }

    return TextButton(
        onPressed: () {
          onFilterableChanged?.call(null);
        },
        child: Text(AppLocalizations.of(context)!.clearFiltters));
  }
}
