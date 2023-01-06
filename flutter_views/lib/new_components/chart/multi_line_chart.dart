import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MultiLineChartItem<T, E> extends StatefulWidget {
  List<List<T>> list;
  String title;
  List<String> titles;

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
    _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
    super.initState();
  }

  void zoom(ZoomPanArgs args) {
    args.currentZoomFactor = 0.2;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(

        // title: ChartTitle(alignment: ChartAlignment.near, text: title),
        legend: Legend(
            isVisible: true,
            alignment: ChartAlignment.center,

            // title: LegendTitle(text: "LegendTitle"),
            overflowMode: LegendItemOverflowMode.none),
        // Initialize category axis
        // primaryXAxis: CategoryAxis(),
        onZoomStart: (ZoomPanArgs args) => zoom(args),
        zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.round,
          numberFormat: NumberFormat.compact(),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          ...widget.list
              .map(
                (e) => LineSeries<T, E>(
                    legendIconType: LegendIconType.circle,
                    markerSettings: const MarkerSettings(isVisible: true),
                    // Bind data source
                    legendItemText: widget.titles[widget.list.indexOf(e)],
                    enableTooltip: true,
                    
                    dataSource: e,
                    dataLabelMapper: widget.dataLabelMapper,
                    xValueMapper: (datum, index) => widget.xValueMapper(
                        widget.list.indexOf(e), datum, index),
                    yValueMapper: (datum, index) => widget.yValueMapper(
                        widget.list.indexOf(e), datum, index),
                    // legendItemText: ,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                    )),
              )
              .toList()
        ]);
  }
}
