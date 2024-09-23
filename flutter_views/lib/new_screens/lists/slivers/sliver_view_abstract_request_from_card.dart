import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';

import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

class SliverApiMixinViewAbstractCardApiWidget
    extends SliverApiMixinWithStaticStateful {
  /// [toListObject] could be String [tableName] or [ViewAbstract]
  SliverApiMixinViewAbstractCardApiWidget(
      {super.key,
      super.scrollDirection,
      super.scrollController,
      super.isSliver,
      super.isGridView = false,
      super.hasCustomCardBuilder,
      super.hasCustomSeperater,
      super.isCardRequestApi=true,
      super.enableSelection,
      required super.toListObject,
      super.searchString});

  @override
  State<SliverApiMixinViewAbstractCardApiWidget> createState() =>
      SliverApiMixinAutoRestState();
}

class SliverApiMixinAutoRestState
    extends State<SliverApiMixinViewAbstractCardApiWidget>
    with SliverApiWithStaticMixin {
  @override
  String getListProviderKey() {
    return "qrCode";
  }

  @override
  Widget? onLoadingHasCustomWidget() => null;

  @override
  Widget? onResponseHasCustomWidget() => null;
}
