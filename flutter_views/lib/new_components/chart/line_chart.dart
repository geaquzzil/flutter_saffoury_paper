import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartItem<T, E> extends StatelessWidget {
  List<T> list;
  String? title;
  bool smallView;

  E? Function(T item, int value) xValueMapper;
  num? Function(T item, num num) yValueMapper;
  String? Function(T item, int idx)? dataLabelMapper;

  LineChartItem(
      {super.key,
      this.title,
      required this.list,
      required this.xValueMapper,
      required this.yValueMapper,
      this.smallView = false,
      this.dataLabelMapper});

  @override
  Widget build(BuildContext context) {
    Widget t = SfCartesianChart(
        plotAreaBorderWidth: smallView ? 0 : 0.5,
        title: ChartTitle(alignment: ChartAlignment.near, text: title ?? ''),
        primaryXAxis: E.runtimeType == DateTime.now().runtimeType
            ? DateTimeAxis(isVisible: !smallView)
            : CategoryAxis(
              
                borderWidth: 0,
                rangePadding: ChartRangePadding.auto,
                isVisible: !smallView,
                axisBorderType: AxisBorderType.withoutTopAndBottom),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.compact(),
            borderWidth: 0,
            axisBorderType: AxisBorderType.withoutTopAndBottom,
            zoomPosition: .2,
            rangePadding:
                smallView ? ChartRangePadding.none : ChartRangePadding.auto,
            isVisible: !smallView,
            anchorRangeToVisiblePoints: false),
        // plotAreaBackgroundColor: Colors.red,
        // backgroundColor: Colors.redAccent,
        zoomPanBehavior: ZoomPanBehavior(
            zoomMode: ZoomMode.x,
            maximumZoomLevel: 0.3,
            enablePanning: true,
            enablePinching: true),

        // s

        // trackballBehavior: TrackballBehavior(enable: true),
        tooltipBehavior: smallView ? null : TooltipBehavior(),

        // enableSideBySideSeriesPlacement: true,
        series: <CartesianSeries>[
          // ColumnSeries<T, E>(
          //   // Bind data source

          //   // enableTooltip: true,
          //   dataSource: list,
          //   xValueMapper: xValueMapper,
          //   yValueMapper: yValueMapper,
          //   // legendItemText: ,
          //   // dataLabelSettings: const DataLabelSettings(isVisible: true)
          // ),
          if (E.runtimeType == DateTime.now().runtimeType || smallView)
            LineSeries<T, E>(
                // Bind data source
                markerSettings: MarkerSettings(
                  isVisible: !smallView,
                ),
                enableTooltip: !smallView,
                dataSource: list,
                xValueMapper: xValueMapper,
                yValueMapper: yValueMapper,
                dataLabelMapper: dataLabelMapper,

                // legendItemText: ,

                dataLabelSettings: DataLabelSettings(isVisible: !smallView))
          else
            ColumnSeries<T, E>(
                sortingOrder: SortingOrder.descending,
                // Sorting based on the specified field
                // sortFieldValueMapper: (T data, _) => data.runtimeType,
                dataSource: list,
                markerSettings: MarkerSettings(isVisible: true),
                xValueMapper: xValueMapper,
                yValueMapper: yValueMapper,
                dataLabelMapper: dataLabelMapper,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]);

    if (smallView) {
      return SizedBox(
        height: 60,
        child: t,
      );
    }
    return t;
  }
}
