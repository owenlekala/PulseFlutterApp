import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color fieldBackground;
  final Color fieldBackgroundDisabled;
  final Color fieldBorderActive;
  final Color uploadIdleSurface;
  final Color uploadSuccessSurface;
  final Color uploadWarningSurface;
  final Color uploadErrorSurface;
  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color sheetBackground;
  final Color chipNeutralBackground;
  final Color chipNeutralForeground;
  final Color chipSuccessBackground;
  final Color chipSuccessForeground;
  final Color chipWarningBackground;
  final Color chipWarningForeground;
  final Color chipErrorBackground;
  final Color chipErrorForeground;
  final Color dragHoverSurface;
  final Color tabBarBackground;
  final Color tabBarIndicator;
  final Color tabBarForeground;
  final Color avatarEditBackground;
  final Color avatarEditForeground;

  const AppSemanticColors({
    required this.fieldBackground,
    required this.fieldBackgroundDisabled,
    required this.fieldBorderActive,
    required this.uploadIdleSurface,
    required this.uploadSuccessSurface,
    required this.uploadWarningSurface,
    required this.uploadErrorSurface,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.sheetBackground,
    required this.chipNeutralBackground,
    required this.chipNeutralForeground,
    required this.chipSuccessBackground,
    required this.chipSuccessForeground,
    required this.chipWarningBackground,
    required this.chipWarningForeground,
    required this.chipErrorBackground,
    required this.chipErrorForeground,
    required this.dragHoverSurface,
    required this.tabBarBackground,
    required this.tabBarIndicator,
    required this.tabBarForeground,
    required this.avatarEditBackground,
    required this.avatarEditForeground,
  });

  @override
  AppSemanticColors copyWith({
    Color? fieldBackground,
    Color? fieldBackgroundDisabled,
    Color? fieldBorderActive,
    Color? uploadIdleSurface,
    Color? uploadSuccessSurface,
    Color? uploadWarningSurface,
    Color? uploadErrorSurface,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? sheetBackground,
    Color? chipNeutralBackground,
    Color? chipNeutralForeground,
    Color? chipSuccessBackground,
    Color? chipSuccessForeground,
    Color? chipWarningBackground,
    Color? chipWarningForeground,
    Color? chipErrorBackground,
    Color? chipErrorForeground,
    Color? dragHoverSurface,
    Color? tabBarBackground,
    Color? tabBarIndicator,
    Color? tabBarForeground,
    Color? avatarEditBackground,
    Color? avatarEditForeground,
  }) {
    return AppSemanticColors(
      fieldBackground: fieldBackground ?? this.fieldBackground,
      fieldBackgroundDisabled:
          fieldBackgroundDisabled ?? this.fieldBackgroundDisabled,
      fieldBorderActive: fieldBorderActive ?? this.fieldBorderActive,
      uploadIdleSurface: uploadIdleSurface ?? this.uploadIdleSurface,
      uploadSuccessSurface: uploadSuccessSurface ?? this.uploadSuccessSurface,
      uploadWarningSurface: uploadWarningSurface ?? this.uploadWarningSurface,
      uploadErrorSurface: uploadErrorSurface ?? this.uploadErrorSurface,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      sheetBackground: sheetBackground ?? this.sheetBackground,
      chipNeutralBackground:
          chipNeutralBackground ?? this.chipNeutralBackground,
      chipNeutralForeground:
          chipNeutralForeground ?? this.chipNeutralForeground,
      chipSuccessBackground:
          chipSuccessBackground ?? this.chipSuccessBackground,
      chipSuccessForeground:
          chipSuccessForeground ?? this.chipSuccessForeground,
      chipWarningBackground:
          chipWarningBackground ?? this.chipWarningBackground,
      chipWarningForeground:
          chipWarningForeground ?? this.chipWarningForeground,
      chipErrorBackground: chipErrorBackground ?? this.chipErrorBackground,
      chipErrorForeground: chipErrorForeground ?? this.chipErrorForeground,
      dragHoverSurface: dragHoverSurface ?? this.dragHoverSurface,
      tabBarBackground: tabBarBackground ?? this.tabBarBackground,
      tabBarIndicator: tabBarIndicator ?? this.tabBarIndicator,
      tabBarForeground: tabBarForeground ?? this.tabBarForeground,
      avatarEditBackground: avatarEditBackground ?? this.avatarEditBackground,
      avatarEditForeground: avatarEditForeground ?? this.avatarEditForeground,
    );
  }

  @override
  AppSemanticColors lerp(
    covariant ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) {
      return this;
    }

    return AppSemanticColors(
      fieldBackground: Color.lerp(fieldBackground, other.fieldBackground, t)!,
      fieldBackgroundDisabled: Color.lerp(
        fieldBackgroundDisabled,
        other.fieldBackgroundDisabled,
        t,
      )!,
      fieldBorderActive: Color.lerp(
        fieldBorderActive,
        other.fieldBorderActive,
        t,
      )!,
      uploadIdleSurface: Color.lerp(
        uploadIdleSurface,
        other.uploadIdleSurface,
        t,
      )!,
      uploadSuccessSurface: Color.lerp(
        uploadSuccessSurface,
        other.uploadSuccessSurface,
        t,
      )!,
      uploadWarningSurface: Color.lerp(
        uploadWarningSurface,
        other.uploadWarningSurface,
        t,
      )!,
      uploadErrorSurface: Color.lerp(
        uploadErrorSurface,
        other.uploadErrorSurface,
        t,
      )!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight: Color.lerp(
        skeletonHighlight,
        other.skeletonHighlight,
        t,
      )!,
      sheetBackground: Color.lerp(sheetBackground, other.sheetBackground, t)!,
      chipNeutralBackground: Color.lerp(
        chipNeutralBackground,
        other.chipNeutralBackground,
        t,
      )!,
      chipNeutralForeground: Color.lerp(
        chipNeutralForeground,
        other.chipNeutralForeground,
        t,
      )!,
      chipSuccessBackground: Color.lerp(
        chipSuccessBackground,
        other.chipSuccessBackground,
        t,
      )!,
      chipSuccessForeground: Color.lerp(
        chipSuccessForeground,
        other.chipSuccessForeground,
        t,
      )!,
      chipWarningBackground: Color.lerp(
        chipWarningBackground,
        other.chipWarningBackground,
        t,
      )!,
      chipWarningForeground: Color.lerp(
        chipWarningForeground,
        other.chipWarningForeground,
        t,
      )!,
      chipErrorBackground: Color.lerp(
        chipErrorBackground,
        other.chipErrorBackground,
        t,
      )!,
      chipErrorForeground: Color.lerp(
        chipErrorForeground,
        other.chipErrorForeground,
        t,
      )!,
      dragHoverSurface: Color.lerp(
        dragHoverSurface,
        other.dragHoverSurface,
        t,
      )!,
      tabBarBackground: Color.lerp(
        tabBarBackground,
        other.tabBarBackground,
        t,
      )!,
      tabBarIndicator: Color.lerp(tabBarIndicator, other.tabBarIndicator, t)!,
      tabBarForeground: Color.lerp(
        tabBarForeground,
        other.tabBarForeground,
        t,
      )!,
      avatarEditBackground: Color.lerp(
        avatarEditBackground,
        other.avatarEditBackground,
        t,
      )!,
      avatarEditForeground: Color.lerp(
        avatarEditForeground,
        other.avatarEditForeground,
        t,
      )!,
    );
  }
}

extension AppThemeSemanticColorsX on ThemeData {
  AppSemanticColors get appColors =>
      extension<AppSemanticColors>() ??
      const AppSemanticColors(
        fieldBackground: Color(0xFFF5F5F5),
        fieldBackgroundDisabled: Color(0xFFEAEAEA),
        fieldBorderActive: Color(0xFF2563EB),
        uploadIdleSurface: Color(0xFFF8FAFC),
        uploadSuccessSurface: Color(0xFFD1FAE5),
        uploadWarningSurface: Color(0xFFFEF3C7),
        uploadErrorSurface: Color(0xFFFEE2E2),
        skeletonBase: Color(0xFFE2E8F0),
        skeletonHighlight: Color(0xFFF8FAFC),
        sheetBackground: Colors.white,
        chipNeutralBackground: Color(0xFFE2E8F0),
        chipNeutralForeground: Color(0xFF334155),
        chipSuccessBackground: Color(0xFF10B981),
        chipSuccessForeground: Colors.white,
        chipWarningBackground: Color(0xFFF59E0B),
        chipWarningForeground: Colors.white,
        chipErrorBackground: Color(0xFFEF4444),
        chipErrorForeground: Colors.white,
        dragHoverSurface: Color(0xFFDBEAFE),
        tabBarBackground: Color(0xFFF1F5F9),
        tabBarIndicator: Colors.white,
        tabBarForeground: Color(0xFF0F172A),
        avatarEditBackground: Color(0xFF2563EB),
        avatarEditForeground: Colors.white,
      );
}
