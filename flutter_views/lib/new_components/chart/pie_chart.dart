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
        margin: EdgeInsets.zero,
        title: ChartTitle(
            alignment: ChartAlignment.center,
            text: title,
            textStyle: Theme.of(context).textTheme.titleSmall),
        legend: Legend(
            isVisible: true, overflowMode: LegendItemOverflowMode.scroll),
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
