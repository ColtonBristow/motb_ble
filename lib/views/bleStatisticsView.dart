import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motb_ble/models/ble_model.dart';
import 'package:motb_ble/views/bleSearchView.dart';

class BleStatisticsView extends ConsumerWidget {
  const BleStatisticsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<double, double> firstMonthHealthMap = {};
    final Map<double, double> secondMonthHealthMap = {};

    List<Color> secondMapColor = [
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).cardColor,
    ];
    List<Color> firstMapColor = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).cardColor,
    ];

    final Map<String, BLE> bleList = ref.watch(bleListProvider.state).state;

    List<LineChartBarData> getLineBarsData() {
      final List<LineChartBarData> bardata = [];
      for (var i = 0; i < bleList.length; i++) {
        bardata.add(
          LineChartBarData(
            isCurved: true,
            colors: [Theme.of(context).colorScheme.secondary],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: secondMapColor.map((color) => color.withOpacity(0.3)).toList(),
            ),
            spots: bleList.entries
                .map(
                  (e) => FlSpot(i.toDouble(), e.value.distance),
                )
                .toList(),
          ),
        );
      }
      return bardata;
    }

    bleList.forEach(
      (key, value) {},
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 200,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(reservedSize: 0),
                  bottomTitles: SideTitles(reservedSize: 0),
                  show: false,
                ),
                gridData: FlGridData(
                  show: false,
                  drawHorizontalLine: false,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(
                      color: Colors.transparent,
                      width: 4,
                    ),
                    left: BorderSide(
                      color: Colors.transparent,
                    ),
                    right: BorderSide(
                      color: Colors.transparent,
                    ),
                    top: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                lineBarsData: getLineBarsData(),
                minX: 0,
                maxX: 20,
                maxY: 20,
                minY: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
