import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/lists/skeletonizer/widgets.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

class ListCardItemApi extends StatefulWidget {
  ViewAbstract viewAbstract;
  Widget Function(ViewAbstract item)? hasCustomCardBuilderOnResponse;
  Widget? hasCustomLoadingWidget;
  SliverApiWithStaticMixin? state;
  ListCardItemApi(
      {super.key,
      required this.viewAbstract,
      this.state,
      this.hasCustomLoadingWidget,
      this.hasCustomCardBuilderOnResponse});

  @override
  State<ListCardItemApi> createState() => _ListCardItemApiState();
}

class _ListCardItemApiState extends State<ListCardItemApi> {
  ViewAbstract? _viewAbstract;

  @override
  void didUpdateWidget(covariant ListCardItemApi oldWidget) {
    if (_viewAbstract?.iD != widget.viewAbstract.iD) {
      debugPrint("ListCardItemApi update ===> iD: ${widget.viewAbstract.iD}");
      _viewAbstract = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_viewAbstract != null) {
      return getItem();
    }
    if (widget.viewAbstract.getBodyWithoutApi(ServerActions.list)) {
      _viewAbstract = widget.viewAbstract;
      return getItem();
    }

    return FutureBuilder(
        future: widget.viewAbstract
            .viewCallGetFirstFromList(widget.viewAbstract.iD, context: context),
        builder: (c, a) {
          debugPrint("ListCardItemApi futureBuilder ");
          if (a.connectionState == ConnectionState.waiting) {
            if (_viewAbstract == null) {
              return widget.hasCustomLoadingWidget ??
                  SkeletonListTile(
                    hasSubtitle: true,
                    hasLeading: true,
                  );
            }
          }
          if (a.connectionState == ConnectionState.done) {
            _viewAbstract = a.data;
            if (_viewAbstract == null) {
              return Card(
                  child: ListTile(
                title: Text(AppLocalizations.of(context)!.errOperationFailed),
                trailing: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    label: const Icon(Icons.refresh)),
              ));
            } else {
              widget.viewAbstract = _viewAbstract!;
              widget.state?.listProvider.edit(_viewAbstract!);
            }
          }

          return getItem();
        });
  }

  Widget getItem() {
    return widget.hasCustomCardBuilderOnResponse != null
        ? widget.hasCustomCardBuilderOnResponse!.call(_viewAbstract!)
        : ListCardItem(
            state: widget.state,
            object: _viewAbstract!,
          );
  }
}
