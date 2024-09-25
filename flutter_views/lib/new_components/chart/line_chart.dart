import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartItem<T, E> extends StatelessWidget {
  final List<T> list;
  String? title;
  bool smallView;
  Color? color;

  E? Function(T item, int value) xValueMapper;
  num? Function(T item, num num) yValueMapper;
  String? Function(T item, int idx)? dataLabelMapper;

  LineChartItem(
      {super.key,
      this.title,
      this.color,
      required this.list,
      required this.xValueMapper,
      required this.yValueMapper,
      this.smallView = false,
      this.dataLabelMapper});

  @override
  Widget build(BuildContext context) {
    Widget t = SfCartesianChart(
        plotAreaBorderWidth: smallView ? 0 : 0.5,
        title: const ChartTitle(alignment: ChartAlignment.near, text: ''),
        primaryXAxis: E.runtimeType == DateTime.now().runtimeType
            ? DateTimeAxis(isVisible: !smallView)
            : CategoryAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                borderWidth: 0,
                rangePadding: ChartRangePadding.auto,
                isVisible: !smallView,
                axisBorderType: AxisBorderType.withoutTopAndBottom),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.compact(),
            borderWidth: 0,
            axisBorderType: AxisBorderType.withoutTopAndBottom,
            initialZoomPosition: .2,
            rangePadding: smallView
                ? ChartRangePadding.additional
                : ChartRangePadding.additional,
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
        tooltipBehavior: TooltipBehavior(
          elevation: 2,
          enable: true,
          duration: 200,
        ),

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
            SplineSeries<T, E>(
                name: title,
                color: color ?? Theme.of(context).colorScheme.primary,
                legendIconType: LegendIconType.triangle,
                // Bind data source
                markerSettings: MarkerSettings(
                  isVisible: !smallView,
                ),
                enableTooltip: true,
                splineType: SplineType.cardinal,
                // cardinalSplineTension: 0.5,
                dataSource: list,
                xValueMapper: xValueMapper,
                yValueMapper: yValueMapper,
                dataLabelMapper: dataLabelMapper,

                // legendItemText: ,

                dataLabelSettings: DataLabelSettings(
                    showZeroValue: false,

                    // showCumulativeValues: ,
                    labelAlignment: ChartDataLabelAlignment.top,
                    isVisible: !smallView,
                    overflowMode: OverflowMode.trim))
          else
            ColumnSeries<T, E>(
                name: title,
                color: color ?? Theme.of(context).colorScheme.primary,
                sortingOrder: SortingOrder.descending,
                // Sorting based on the specified field
                // sortFieldValueMapper: (T data, _) => data.runtimeType,
                dataSource: list,
                markerSettings: const MarkerSettings(isVisible: false),
                xValueMapper: xValueMapper,
                yValueMapper: yValueMapper,
                dataLabelMapper: dataLabelMapper,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ))
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
