import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AppBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final String? title;
  final Color? barColor;
  final bool showGrid;
  final double? maxY;
  final String? leftTitle;
  final String? bottomTitle;
  final List<String>? bottomLabels;

  const AppBarChart({
    super.key,
    required this.barGroups,
    this.title,
    this.barColor,
    this.showGrid = true,
    this.maxY,
    this.leftTitle,
    this.bottomTitle,
    this.bottomLabels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primaryColor = barColor ?? AppColors.getPrimary(brightness);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: FlGridData(
                  show: showGrid,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.getBorder(brightness),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (bottomLabels != null &&
                            value.toInt() < bottomLabels!.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              bottomLabels![value.toInt()],
                              style: TextStyle(
                                color: AppColors.getTextSecondary(brightness),
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: AppColors.getTextSecondary(brightness),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                    axisNameWidget: bottomTitle != null
                        ? Text(
                            bottomTitle!,
                            style: TextStyle(
                              color: AppColors.getTextSecondary(brightness),
                              fontSize: 12,
                            ),
                          )
                        : null,
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.getTextSecondary(brightness),
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                    axisNameWidget: leftTitle != null
                        ? Text(
                            leftTitle!,
                            style: TextStyle(
                              color: AppColors.getTextSecondary(brightness),
                              fontSize: 12,
                            ),
                          )
                        : null,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.getBorder(brightness),
                  ),
                ),
                barGroups: barGroups,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => primaryColor,
                    tooltipRoundedRadius: 8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

