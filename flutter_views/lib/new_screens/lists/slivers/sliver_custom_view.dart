import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

class SliverApiMixinCustomWidget extends SliverApiMixinWithStaticStateful {
  CustomViewHorizontalListResponse object;
 
  SliverApiMixinCustomWidget({
    super.key,
    required this.object,
    super.onResponseAddCustomWidget,
   
    super.scrollController,
  }) : super(toListObject: object);

  @override
  State<SliverApiMixinCustomWidget> createState() =>
      _SliverApiMixinAutoRestState();
}

class _SliverApiMixinAutoRestState extends State<SliverApiMixinCustomWidget>
    with SliverApiWithStaticMixin {
  @override
  String getListProviderKey() {
    return getToListObjectHorizontalListResponse().getCustomViewKey();
  }

  @override
  Widget? onLoadingHasCustomWidget() => const SliverFillRemaining(
    child: Center(child: CircularProgressIndicator()),
  );

  @override
  Widget? onResponseHasCustomWidget() {
    return null;
  }

  // Widget getWidget() {
  //   CustomViewHorizontalListResponse objcet =
  //       getToListObjectHorizontalListResponse();
  //   switch (objcet.getCustomViewResponseType()) {
  //     case ResponseType.LIST:
  //       return getListWidget(listProvider);

  //     case ResponseType.SINGLE:
  //       return getSingleWidget(listProvider);

  //     case ResponseType.NONE_RESPONSE_TYPE:
  //       return getSingleWidget(listProvider);
  //   }
  // }
}
