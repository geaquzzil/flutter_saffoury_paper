import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

class SliverApiMixinViewAbstractWidget
    extends SliverApiMixinWithStaticStateful {
  /// [toListObject] could be String [tableName] or [ViewAbstract]
  SliverApiMixinViewAbstractWidget(
      {super.key,
      super.scrollController,
      super.scrollDirection,
      super.hasCustomWidgetBuilder,
      super.isSliver,
      super.requiresFullFetsh,
      super.isGridView = false,
      super.hasCustomCardBuilder,
      super.hasCustomSeperater,
      super.enableSelection,
      required super.toListObject,
      super.filterData,
      super.valueListProviderNotifier,
      super.searchString});

  @override
  State<SliverApiMixinViewAbstractWidget> createState() =>
      _SliverApiMixinAutoRestState();
}

class _SliverApiMixinAutoRestState
    extends State<SliverApiMixinViewAbstractWidget>
    with SliverApiWithStaticMixin {
  @override
  String getListProviderKey() {
    String key = (widget.toListObject as ViewAbstract).getListableKey();
    key = key + (getSearchString ?? "") + (getFilterData.toString());
    debugPrint("SliverApiWithStaticMixin===> getListProviderKey $key");
    return key;
  }

  @override
  Widget? onLoadingHasCustomWidget() => null;

  @override
  Widget? onResponseHasCustomWidget() => null;
}
