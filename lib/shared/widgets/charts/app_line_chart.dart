import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AppLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final String? title;
  final Color? lineColor;
  final Color? fillColor;
  final bool showGrid;
  final bool showPoints;
  final double? minY;
  final double? maxY;
  final String? leftTitle;
  final String? bottomTitle;

  const AppLineChart({
    super.key,
    required this.spots,
    this.title,
    this.lineColor,
    this.fillColor,
    this.showGrid = true,
    this.showPoints = true,
    this.minY,
    this.maxY,
    this.leftTitle,
    this.bottomTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primaryColor = lineColor ?? AppColors.getPrimary(brightness);
    final fillGradientColor = fillColor ?? primaryColor.withValues(alpha: 0.3);

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
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: showGrid,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
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
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: showPoints,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: primaryColor,
                          strokeWidth: 2,
                          strokeColor: AppColors.getBackground(brightness),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: fillGradientColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

