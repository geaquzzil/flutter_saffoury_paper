import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedChartItem<T, E> extends StatelessWidget {
  List<T> list;
  String title;

  E? Function(T item, int value) xValueMapper;
  num? Function(T item, num num) yValueMapper;
  StackedChartItem(
      {super.key,
      required this.title,
      required this.list,
      required this.xValueMapper,
      required this.yValueMapper});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(alignment: ChartAlignment.near, text: title),
        legend:
            const Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        // Initialize category axis
        // primaryXAxis: CategoryAxis(),
        primaryXAxis: T is DateTime ? const DateTimeAxis() : const CategoryAxis(),
        tooltipBehavior: TooltipBehavior(),
        series: <CartesianSeries>[
          LineSeries<T, E>(
              // Bind data source

              enableTooltip: true,
              dataSource: list,
              xValueMapper: xValueMapper,
              yValueMapper: yValueMapper,
              // legendItemText: ,
              dataLabelSettings: const DataLabelSettings(isVisible: true)),
        ]);
  }
}
