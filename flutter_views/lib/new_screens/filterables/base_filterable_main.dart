import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/headers/rounded_corner.dart';
import 'package:flutter_view_controller/new_screens/filterables/custom_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/filterables/master_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_custom_scroll_widget.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:provider/provider.dart';

class BaseFilterableMainWidget extends StatefulWidget {
  ViewAbstract viewAbstract;
  Map<String, FilterableProviderHelper>? initialData;
  Function(dynamic v)? onDoneClickedPopResults;

  BaseFilterableMainWidget(
      {super.key,
      required this.viewAbstract,
      this.onDoneClickedPopResults,
      this.initialData});

  @override
  State<BaseFilterableMainWidget> createState() =>
      _BaseFilterableMainWidgetState();
}

class _BaseFilterableMainWidgetState extends State<BaseFilterableMainWidget> {
  final ValueNotifier<FilterableData?> _lastData =
      ValueNotifier<FilterableData?>(null);
  Map<String, FilterableProviderHelper>? _initialData;
  late ViewAbstract _viewAbstract;

  @override
  void initState() {
    _viewAbstract = widget.viewAbstract;
    _initialData = widget.initialData;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context
            .read<FilterableProvider>()
            .init(context, _viewAbstract, savedList: _initialData);
      },
    );

    debugPrint("initState initialData = $_initialData");

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BaseFilterableMainWidget oldWidget) {
    if (_viewAbstract != widget.viewAbstract) {
      debugPrint("didUpdateWidget base filter widget");
      _lastData.value = null;
      _viewAbstract = widget.viewAbstract;
    }
    if (_initialData != widget.initialData) {
      _initialData = widget.initialData;
      debugPrint("didUpdateWidget base filter _initialData $_initialData");
      context
          .read<FilterableProvider>()
          .init(context, _viewAbstract, savedList: _initialData);
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Flex(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.horizontal,
        children: [
          getFilterSelector(
            builder: (_, v, __) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: v == 0
                  ? const SizedBox.shrink()
                  : TextButton(
                      child: Text(
                        AppLocalizations.of(context)!
                            .clearFiltters
                            .toUpperCase(),
                        // style:v>0 ? null:Theme.of(context).
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
            ),
          ),
          const Spacer(),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.dismiss.toUpperCase(),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          FilledButton.tonal(
            child: Text(
              AppLocalizations.of(context)!.subment.toUpperCase(),
            ),
            onPressed: () {
              onDonePop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Scaffold(
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _lastData,
          //todo if value is null and we return Container then scaffold not showing
          builder: (context, value, child) => buildFooter(),
        ),
        // backgroundColor: Colors.transparent,
        body: FutureBuilder(
            future: context
                .read<FilterableListApiProvider<FilterableData>>()
                .getServerData(widget.viewAbstract, context: context),
            builder: ((context, snapshot) {
              // debugPrint("Filter data ${snapshot.data}");
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((o) {
                    _lastData.value = snapshot.data;
                  });
                  debugPrint("Filter data");
                  return getSliverCustomScrollViewBody();
                } else {
                  debugPrint("Filter data error");
                  return EmptyWidget.error(
                    context,
                    onSubtitleClicked: () {
                      setState(() {});
                    },
                  );
                }
              }
              debugPrint("Filter data loading");
              return const EmptyWidget.loading();
            })),
      ),
    );
  }

  Widget getSliverCustomScrollViewBody() {
    return RoundedCornerContainer(
      child: SafeArea(
        child: SliverCustomScrollView(
          scrollKey: 'bottomSheet',
          builderAppbar: (fullyCol, fullyExp, tab) {
            return SliverAppBar.medium(
                leading: const CloseButton(),
                // actions: [Container()],
                title: getTitle(context));
          },
          slivers: getControllersSliver(),
        ),
      ),
    );
  }

  // Widget getListFilterableControlers(
  List<Widget> getControllersSliver() {
    Map<ViewAbstract, List<dynamic>> list = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getRequiredFiltter;
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          ViewAbstract viewAbstract = list.keys.elementAt(index);
          List<dynamic> itemsViewAbstract = list[viewAbstract] ?? [];
          debugPrint(
              "getListFilterableControlers is => ${viewAbstract.runtimeType.toString()} count is ${itemsViewAbstract.length}");
          return MasterFilterableController(
              viewAbstract: viewAbstract, list: itemsViewAbstract);
        }, childCount: list.length)),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return CustomFilterableController(
              customFilterableField: widget.viewAbstract
                  .getCustomFilterableFields(context)[index]);
        },
                childCount: widget.viewAbstract
                    .getCustomFilterableFields(context)
                    .length)),
      ),
    ];
  }

  void onDonePop() {
    var result = context.read<FilterableProvider>().getList;
    debugPrint("onDonePop result is => $result");
    widget.onDoneClickedPopResults?.call(result);
    Navigator.of(context).pop(result);
  }

  Row getButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          child: const Text("DONE"),
          onPressed: () {
            onDonePop();
          },
        )
      ],
    );
  }

  // Widget getHeader(
  Text getTitle(BuildContext context) => Text(
      "${AppLocalizations.of(context)!.filter} ${widget.viewAbstract.getMainHeaderLabelTextOnly(context).toLowerCase()}");
}

Widget getFilterSelector(
    {required Widget Function(BuildContext, int, Widget?) builder}) {
  return Selector<FilterableProvider, int>(
    selector: (p0, p1) => p1.getCount(),
    builder: builder,
  );
}
