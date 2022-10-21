import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CirculeChartItem<T, E> extends StatelessWidget {
  List<T> list;
  String title;

  E? Function(T item, int value) xValueMapper;
  num? Function(T item, num num) yValueMapper;
  CirculeChartItem(
      {Key? key,
      required this.title,
      required this.list,
      required this.xValueMapper,
      required this.yValueMapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        title: ChartTitle(alignment: ChartAlignment.near, text: title),
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        // Initialize category axis
        // primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(),
        series: <CircularSeries>[
          DoughnutSeries<T, E>(
              // Bind data source
              enableTooltip: true,
              dataSource: list,
              xValueMapper: xValueMapper,
              yValueMapper: yValueMapper,
              dataLabelSettings: const DataLabelSettings(isVisible: true)),
        ]);
  }
}
