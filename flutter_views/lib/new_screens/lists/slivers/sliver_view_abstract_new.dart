import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

class SliverApiMixinViewAbstractWidget
    extends SliverApiMixinWithStaticStateful {
  /// [toListObject] could be String [tableName] or [ViewAbstract]
  SliverApiMixinViewAbstractWidget({
    super.key,
    super.scrollController,
    super.scrollDirection,
    super.hasCustomWidgetOnResponseBuilder,
    super.isSliver,
    super.requiresFullFetsh,
    super.enableSelection,
    super.enableSelectionInInitialMood,
    super.onSeletedListItemsChanged,
    super.onClickForCard,
    super.onFinishCalling,
    super.isSelectForCard,
    super.header,
    super.state,
    super.hideOnEmpty,
    // super.
    super.cardType = CardItemType.list,
    super.hasCustomCardItemBuilder,
    super.customRequestOption,
    super.hasCustomSeperater,
    super.onResponseAddCustomWidget,
    required super.toListObject,
    super.copyWithRequestOption,
    super.filterData,
    super.valueListProviderNotifier,
    super.searchString,
  });

  @override
  State<SliverApiMixinViewAbstractWidget> createState() =>
      _SliverApiMixinAutoRestState();
}

class _SliverApiMixinAutoRestState
    extends State<SliverApiMixinViewAbstractWidget>
    with SliverApiWithStaticMixin {
  @override
  String getListProviderKey() {
    String key = (widget.toListObject as ViewAbstract).getListableKey(
      type: getToListObjectType(),
    );
    key =
        key +
        (getSearchString ?? "") +
        (getFilterData.toString()) +
        (getCopyWithCustomRequestOptions?.getKey() ?? "");
    (getCustomRequestOptions?.getKey() ?? "");
    // debugPrint("SliverApiWithStaticMixin===> getListProviderKey $key");
    return key;
  }

  @override
  Widget? onLoadingHasCustomWidget() => null;

  @override
  Widget? onResponseHasCustomWidget() => null;
}
