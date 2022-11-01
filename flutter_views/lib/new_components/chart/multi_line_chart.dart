import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MultiLineChartItem<T, E> extends StatelessWidget {
  List<List<T>> list;
  String title;

  E? Function(int idx, T item, int value) xValueMapper;
  num? Function(int idx, T item, num num) yValueMapper;
  MultiLineChartItem(
      {Key? key,
      required this.title,
      required this.list,
      required this.xValueMapper,
      required this.yValueMapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        // title: ChartTitle(alignment: ChartAlignment.near, text: title),
        // legend:
        //     Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        // Initialize category axis
        // primaryXAxis: CategoryAxis(),
        primaryXAxis: DateTimeAxis(),
        tooltipBehavior: TooltipBehavior(),
        series: <ChartSeries>[
          ...list
              .map(
                (e) => ColumnSeries<T, E>(
                    // Bind data source

                    enableTooltip: true,
                    dataSource: e,
                    xValueMapper: (datum, index) =>
                        xValueMapper(list.indexOf(e), datum, index),
                    yValueMapper: (datum, index) =>
                        yValueMapper(list.indexOf(e), datum, index),
                    // legendItemText: ,
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true)),
              )
              .toList()
        ]);
  }
}
