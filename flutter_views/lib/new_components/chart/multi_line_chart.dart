import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MultiLineChartItem<T, E> extends StatefulWidget {
  List<List<T>> list;
  String title;
  List<ViewAbstract> titles;
  bool legendVisibility;

  E? Function(int idx, T item, int value) xValueMapper;
  num? Function(int idx, T item, num num) yValueMapper;
  String? Function(T item, int idx)? dataLabelMapper;
  MultiLineChartItem(
      {Key? key,
      required this.title,
      required this.list,
      required this.titles,
      required this.xValueMapper,
      required this.yValueMapper,
      this.legendVisibility = false,
      this.dataLabelMapper})
      : super(key: key);

  @override
  State<MultiLineChartItem<T, E>> createState() =>
      _MultiLineChartItemState<T, E>();
}

class _MultiLineChartItemState<T, E> extends State<MultiLineChartItem<T, E>> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        enableDoubleTapZooming: true,
        enableMouseWheelZooming: true);
    super.initState();
  }

  void zoom(ZoomPanArgs args) {
    args.currentZoomFactor = 0.2;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        legend: Legend(
            isVisible: widget.legendVisibility,
            alignment: ChartAlignment.center,
            overflowMode: LegendItemOverflowMode.scroll),
        onZoomStart: (ZoomPanArgs args) => zoom(args),
        zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: DateTimeAxis(
          // autoScrollingDelta: 7,
          autoScrollingDeltaType: DateTimeIntervalType.months,
          // plotOffset: 20,
          maximumLabels: 3,
          rangePadding: ChartRangePadding.additional,
          autoScrollingMode: AutoScrollingMode.start,
          // labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          // initialVisibleMinimum: 2,
          // isInversed: true,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          // labelPosition: ChartDataLabelPosition.inside,
          // tickPosition: TickPosition.inside
        ),
        primaryYAxis: NumericAxis(
          // zoomPosition: 0.9,
          // rangePadding:ChartRangePadding.auto,
          autoScrollingMode: AutoScrollingMode.start,
          // labelPosition: ChartDataLabelPosition.inside,
          // tickPosition: TickPosition.inside,
          rangePadding: ChartRangePadding.auto,
          enableAutoIntervalOnZooming: true,
          anchorRangeToVisiblePoints: false,

          numberFormat: NumberFormat.compact(),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        // builder: E is! GrowthRate
        //     ? null
        //     : (_, __, ___, i, ii) {
        //         GrowthRate growthRate = _;
        //         debugPrint("TooltipBehavior 1 is $_");
        //         debugPrint("TooltipBehavior 2 is $__");
        //         debugPrint("TooltipBehavior 3 is $___");
        //         debugPrint("TooltipBehavior 4 is $i");
        //         debugPrint("TooltipBehavior 5 is $ii");
        //         String label =
        //             widget.titles[ii].getMainHeaderLabelTextOnly(context);
        //         String date = DateFormat.MMM().format(DateTime(
        //             growthRate.year!,
        //             growthRate.month!,
        //             growthRate.day ?? 1));

        //         String value =
        //             widget.dataLabelMapper?.call(growthRate as T, i) ??
        //                 growthRate.total.toCurrencyFormat();

        //         return Card(
        //             color: Colors.black,
        //             child: Text("$label\n$date - $value"));
        //       }),
        series: <ChartSeries>[
          ...widget.list.map(
            (e) => LineSeries<T, E>(
                name: widget.titles[widget.list.indexOf(e)]
                    .getMainHeaderLabelTextOnly(context),
                color: widget.titles[widget.list.indexOf(e)].getMainColor(),
                legendIconType: LegendIconType.circle,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                ),

                // Bind data source
                legendItemText: widget.titles[widget.list.indexOf(e)]
                    .getMainHeaderTextOnly(context),
                enableTooltip: true,
                dataSource: e,
                dataLabelMapper: widget.dataLabelMapper,
                xValueMapper: (datum, index) =>
                    widget.xValueMapper(widget.list.indexOf(e), datum, index),
                yValueMapper: (datum, index) =>
                    widget.yValueMapper(widget.list.indexOf(e), datum, index),
                // legendItemText: ,
                dataLabelSettings: DataLabelSettings(
                  overflowMode: OverflowMode.trim,

                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color:
                          widget.titles[widget.list.indexOf(e)].getMainColor()),
                  // color: ,
                  isVisible: false,
                )),
          )
        ]);
  }
}
