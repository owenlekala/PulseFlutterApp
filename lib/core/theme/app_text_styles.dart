import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display Styles
  static TextStyle displayLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: AppColors.getTextPrimary(brightness),
      height: 1.12,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.getTextPrimary(brightness),
      height: 1.16,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.getTextPrimary(brightness),
      height: 1.22,
    );
  }

  // Headline Styles
  static TextStyle headlineLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.getTextPrimary(brightness),
      height: 1.25,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.getTextPrimary(brightness),
      height: 1.29,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.getTextPrimary(brightness),
      height: 1.33,
    );
  }

  // Title Styles
  static TextStyle titleLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.getTextPrimary(brightness),
      height: 1.27,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: AppColors.getTextPrimary(brightness),
      height: 1.5,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.getTextPrimary(brightness),
      height: 1.43,
    );
  }

  // Body Styles
  static TextStyle bodyLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: AppColors.getTextPrimary(brightness),
      height: 1.5,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.getTextPrimary(brightness),
      height: 1.43,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: AppColors.getTextSecondary(brightness),
      height: 1.33,
    );
  }

  // Label Styles
  static TextStyle labelLarge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.getTextPrimary(brightness),
      height: 1.43,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.getTextPrimary(brightness),
      height: 1.33,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.getTextSecondary(brightness),
      height: 1.45,
    );
  }

  // Custom Styles
  static TextStyle button(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.75,
      color: AppColors.getTextPrimary(brightness),
      height: 1.43,
    );
  }

  static TextStyle caption(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: AppColors.getTextSecondary(brightness),
      height: 1.33,
    );
  }

  static TextStyle overline(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: AppColors.getTextSecondary(brightness),
      height: 1.6,
    );
  }
}

