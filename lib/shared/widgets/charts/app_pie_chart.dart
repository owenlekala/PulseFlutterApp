import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AppPieChartData {
  final String label;
  final double value;
  final Color color;

  AppPieChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class AppPieChart extends StatelessWidget {
  final List<AppPieChartData> data;
  final String? title;
  final double radius;
  final bool showLabels;
  final bool showLegend;

  const AppPieChart({
    super.key,
    required this.data,
    this.title,
    this.radius = 100,
    this.showLabels = true,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final sections = data.map((item) {
      return PieChartSectionData(
        value: item.value,
        title: showLabels ? item.label : '',
        color: item.color,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimary(brightness),
        ),
      );
    }).toList();

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
          Row(
            children: [
              SizedBox(
                width: radius * 2,
                height: radius * 2,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 2,
                    centerSpaceRadius: radius * 0.4,
                  ),
                ),
              ),
              if (showLegend) ...[
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.label,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '${item.value.toStringAsFixed(1)}%',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

