import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

///The nested ListView.builder is set to have shrinkWrap: true and
///physics: NeverScrollableScrollPhysics() to ensure that it doesn't scroll independently within each card but still scrolls as a whole list.
class SliverApiMixinStaticList<T extends ViewAbstract> extends SliverApiMixinWithStaticStateful<T> {
  List<T> list;
  String? listKey;
  SliverApiMixinStaticList({
    super.key,
    required this.list,
    super.scrollController,
    super.isSliver,
    super.scrollDirection,
    super.hasCustomCardItemBuilder,
    super.hasCustomSeperater,
    super.hasCustomWidgetOnResponseBuilder,
    super.cardType = CardItemType.list,
    super.state,
    this.listKey,
    super.enableSelection = false,
  }) : super(toListObject: list);

  @override
  State<SliverApiMixinStaticList> createState() =>
      _SliverApiMixinStaticListState();
}

class _SliverApiMixinStaticListState extends State<SliverApiMixinStaticList>
    with SliverApiWithStaticMixin {
  @override
  String getListProviderKey() {
    return widget.listKey ?? widget.list[0].getListableKey();
  }

  @override
  Widget? onLoadingHasCustomWidget() {
    return null;
  }

  @override
  Widget? onResponseHasCustomWidget() => null;
}
