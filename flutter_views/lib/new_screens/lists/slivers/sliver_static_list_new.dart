import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';

import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

class SliverApiMixinStaticList extends SliverApiMixinWithStaticStateful {
  List<ViewAbstract> list;
  SliverApiMixinStaticList(
      {super.key,
      required this.list,
      super.isSliver,
      super.scrollDirection,
      super.isGridView = false,
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
    return widget.list[0].getListableKey();
  }

  @override
  Widget? onLoadingHasCustomWidget() {}

  @override
  Widget? onResponseHasCustomWidget() => null;
}
