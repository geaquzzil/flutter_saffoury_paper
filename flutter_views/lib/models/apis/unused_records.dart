import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/buttons/api_button.dart';
import 'package:flutter_view_controller/new_components/cards/card_background_with_title.dart';
import 'package:json_annotation/json_annotation.dart';

//todo let api changed from [ids] to list:[ids]
class UnusedRecords<T extends ViewAbstract> extends VObject<UnusedRecords>
    implements CustomViewHorizontalListResponse<UnusedRecords> {
  List<int> list = [];
  List<T>? listObjects = [];
  @JsonKey(includeFromJson: false, includeToJson: false)
  T? viewAbstract;
  bool? requireObjects;
  UnusedRecords() : super();
  @override
  UnusedRecords getSelfNewInstance() {
    return UnusedRecords();
  }

  UnusedRecords.init(T this.viewAbstract);

  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }

  @override
  String? getCustomAction() => "${viewAbstract!.getTableNameApi()}/not_used";
  @override
  String? getTableNameApi() => null;

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return {};
  }

  @override
  UnusedRecords fromJsonViewAbstract(Map<String, dynamic> json) {
    return UnusedRecords()
      ..listObjects = (json['listObjects'] as List<ViewAbstract<T>>?)
          ?.map((e) => e.fromJsonViewAbstract(e as Map<String, dynamic>))
          .toList()
      ..list = List.from(json['list']);
  }

  @override
  String getCustomViewKey() {
    return "unusedRecord$T";
  }

  @override
  ResponseType getCustomViewResponseType() {
    return ResponseType.SINGLE;
  }

  @override
  void onCustomViewCardClicked(BuildContext context, UnusedRecords istem) {
    debugPrint("onCustomViewCardClicked=> $istem");
  }

  @override
  Widget? getCustomViewListResponseWidget(
      BuildContext context, List<UnusedRecords> item) {
    return null;
  }

  @override
  Widget? getCustomViewSingleResponseWidget(BuildContext context) {
    return CardBackgroundWithTitle(
        title: AppLocalizations.of(context)!.unUsed,
        leading: Icons.info_outline,
        child: getDecription(context, this));
  }

  Widget? getLeading(BuildContext context) {
    return viewAbstract?.getMainIconData() == null
        ? null
        : Icon(viewAbstract!.getMainIconData());
  }

  Widget? getTrailing(BuildContext context) {
    return viewAbstract?.getCardTrailing(context);
  }

  Widget getDecription(BuildContext context, UnusedRecords item) {
    ValueNotifier<List<ViewAbstract>> notifier =
        ValueNotifier<List<ViewAbstract>>([]);
    return ListTile(
      trailing: ApiButton(
        onResult: notifier,
        futureBuilder: Future.delayed(const Duration(milliseconds: 2000)),
        title: AppLocalizations.of(context)!.delete,
        icon: Icons.delete,
        onResultFunction: (onResult) {},
      ),
      title: RichText(
        text: TextSpan(
          text: AppLocalizations.of(context)!.youHave,
          // style: TextStyle(fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text:
                    " ${item.list.length} ${AppLocalizations.of(context)!.unUsed}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            // TextSpan(text: ' world!'),
          ],
        ),
      ),
    );
  }

  Widget getTitle(BuildContext context) {
    return Text(AppLocalizations.of(context)!.unUsed);
  }

  @override
  double? getCustomViewHeight() => 200;

  @override
  Widget? getCustomViewTitleWidget(
      BuildContext context, ValueNotifier valueNotifier) {
    return null;
  }

  @override
  Widget? getCustomViewOnResponse(UnusedRecords<ViewAbstract> response) {
    // TODO: implement getCustomViewOnResponse
    throw UnimplementedError();
  }

  @override
  Widget? getCustomViewOnResponseAddWidget(
      UnusedRecords<ViewAbstract> response) {
    // TODO: implement getCustomViewOnResponseAddWidget
    throw UnimplementedError();
  }
}
