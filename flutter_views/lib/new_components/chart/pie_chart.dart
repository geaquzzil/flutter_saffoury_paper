import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CirculeChartItem<T, E> extends StatelessWidget {
  List<T> list;
  String title;

  E? Function(T item, int value) xValueMapper;
  num? Function(T item, num num) yValueMapper;
  String? Function(T item, int idx)? dataLabelMapper;
  CirculeChartItem(
      {Key? key,
      required this.title,
      required this.list,
      required this.xValueMapper,
      this.dataLabelMapper,
      required this.yValueMapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        margin: EdgeInsets.zero,
        title: ChartTitle(

            // alignment: ChartAlignment.center,
            text: title,
            textStyle: Theme.of(context).textTheme.titleSmall),
        legend: Legend(
          isResponsive: true,
          // legendItemBuilder: (s, d, d2, i) =>
          //     Text("s $s dynamic $d dynamic2  $d2  index $i"),
          isVisible: false,
          overflowMode: LegendItemOverflowMode.none,
        ),
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
              dataLabelMapper: dataLabelMapper,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
              )),
        ]);
  }
}
