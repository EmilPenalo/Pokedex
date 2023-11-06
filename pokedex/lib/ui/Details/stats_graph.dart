import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/style_variables.dart';

import '../../helpers/text_helper.dart';

class StatsGraph extends StatelessWidget {
  final Map<String, double> statsMap;
  final Color typeColor;
  const StatsGraph({super.key, required this.statsMap, required this.typeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

      // Rotando para barras horizontales
      child: RotatedBox(
        quarterTurns: 1,

        child: BarChart(
            BarChartData(
                maxY: getMaxStatValue(statsMap),
                minY: 0,

                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {

                        // Rotando el texto devuelta a la normalidad
                        return RotatedBox(
                          quarterTurns: -1,
                          child: getBottomTiles(value, meta, statsMap, typeColor),
                        );
                      },
                    ),
                  ),
                ),

                barTouchData: BarTouchData(
                  enabled: false,
                ),

                barGroups: statsMap.entries.map((entry) {
                  String statName = entry.key;
                  double baseStat = entry.value;
                  int statNameXValue = codeStat(statName);

                  return BarChartGroupData(
                    x: statNameXValue,
                    barRods: [
                      BarChartRodData(
                          toY: baseStat,
                          backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: getMaxStatValue(statsMap),
                              color: Colors.grey[200]
                          ),
                          color: typeColor
                      ),
                    ],
                  );
                }).toList()
            )
        ),
      ),
    );
  }

  double getMaxStatValue(Map<String, double> statsMap) {
    double maxValue = statsMap.values.reduce((max, value) => value > max ? value : max);
    if (maxValue < 100) {
      return 100.0;
    }
    return maxValue;
  }

  int codeStat(String statName) {
    if (statName == "hp") {
      return 0;
    } else if (statName == "attack") {
      return 1;
    } else if (statName == "defense") {
      return 2;
    } else if (statName == "special-attack") {
      return 3;
    } else if (statName == "special-defense") {
      return 4;
    } else if (statName == "speed") {
      return 5;
    }

    return -1;
  }

  String decodeStat(int index) {
    if (index == 0) {
      return "hp";
    } else if (index == 1) {
      return "attack";
    } else if (index == 2) {
      return "defense";
    } else if (index == 3) {
      return "special-attack";
    } else if (index == 4) {
      return "special-defense";
    } else if (index == 5) {
      return "speed";
    }

    return "Nan";
  }

  Widget getBottomTiles(double value, TitleMeta meta, Map<String, double> statsMap, Color color) {
    final TextStyle labelStyle = TextStyle(
      color: color,
      fontSize: 16.0,
      fontWeight: FontWeight.w800,
    );

    final int index = value.toInt();
    List<String> labelName = ['HP   ', 'ATK   ', 'DEF   ', 'SATK   ', 'SDEF   ', 'SPD   '];
    final String textContent = labelName[index];
    final String statValueText = formatNumberStat(statsMap[decodeStat(index)]!.toInt());

    final List<TextSpan> textSpans = [
      TextSpan(
        text: textContent,
        style: labelStyle,
      ),
      TextSpan(
        text: statValueText,
        style: softerTextStyle(),
      ),
    ];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RichText(
        text: TextSpan(
          children: textSpans,
        ),
      ),
    );
  }
}
