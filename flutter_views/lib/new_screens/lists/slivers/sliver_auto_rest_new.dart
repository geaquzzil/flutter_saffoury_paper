import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

//todo i dont know if search is working here
class SliverApiMixinAutoRestWidget extends SliverApiMixinWithStaticStateful {
  AutoRest autoRest;
  SliverApiMixinAutoRestWidget(
      {super.key,
      super.isGridView,
      super.hasCustomCardBuilder,
      super.scrollDirection = Axis.horizontal,
      super.isSliver,
      super.filterData,
      super.searchString,
      required this.autoRest})
      : super(toListObject: autoRest);

  @override
  State<SliverApiMixinAutoRestWidget> createState() =>
      _SliverApiMixinAutoRestState();
}

class _SliverApiMixinAutoRestState extends State<SliverApiMixinAutoRestWidget>
    with SliverApiWithStaticMixin {
  @override
  String getListProviderKey() {
    return getToListObjectCastAutoRest().key;
  }

  @override
  Widget? onLoadingHasCustomWidget() => null;

  @override
  Widget? onResponseHasCustomWidget() => null;
}
