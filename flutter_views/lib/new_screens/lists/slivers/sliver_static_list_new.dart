import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

///The nested ListView.builder is set to have shrinkWrap: true and
///physics: NeverScrollableScrollPhysics() to ensure that it doesn't scroll independently within each card but still scrolls as a whole list.
class SliverApiMixinStaticList extends SliverApiMixinWithStaticStateful {
  List<ViewAbstract> list;
  String? listKey;
  SliverApiMixinStaticList(
      {super.key,
      required this.list,
      super.scrollController,
      super.isSliver,
      super.scrollDirection,
      super.isGridView = false,
      this.listKey,
      super.enableSelection = false,
      super.hasCustomCardBuilder,
      super.hasCustomSeperater})
      : super(toListObject: list);

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
