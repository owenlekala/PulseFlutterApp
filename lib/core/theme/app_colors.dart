import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF818CF8);
  
  static const Color primaryContainerLight = Color(0xFFE0E7FF);
  static const Color primaryContainerDark = Color(0xFF312E81);

  // Secondary Colors
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color secondaryDark = Color(0xFF34D399);
  
  static const Color secondaryContainerLight = Color(0xFFD1FAE5);
  static const Color secondaryContainerDark = Color(0xFF064E3B);

  // Error Colors
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);
  
  static const Color errorContainerLight = Color(0xFFFEE2E2);
  static const Color errorContainerDark = Color(0xFF7F1D1D);

  // Warning Colors
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);
  
  static const Color warningContainerLight = Color(0xFFFEF3C7);
  static const Color warningContainerDark = Color(0xFF78350F);

  // Success Colors
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  
  static const Color successContainerLight = Color(0xFFD1FAE5);
  static const Color successContainerDark = Color(0xFF064E3B);

  // Info Colors
  static const Color infoLight = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF60A5FA);
  
  static const Color infoContainerLight = Color(0xFFDBEAFE);
  static const Color infoContainerDark = Color(0xFF1E3A8A);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A);
  
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF1E293B);
  
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color surfaceVariantDark = Color(0xFF334155);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  static const Color textTertiaryLight = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);
  
  static const Color borderVariantLight = Color(0xFFF1F5F9);
  static const Color borderVariantDark = Color(0xFF475569);

  // Divider Colors
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x4D000000);

  // Get colors based on brightness
  static Color getPrimary(Brightness brightness) {
    return brightness == Brightness.light ? primaryLight : primaryDark;
  }

  static Color getBackground(Brightness brightness) {
    return brightness == Brightness.light ? backgroundLight : backgroundDark;
  }

  static Color getSurface(Brightness brightness) {
    return brightness == Brightness.light ? surfaceLight : surfaceDark;
  }

  static Color getTextPrimary(Brightness brightness) {
    return brightness == Brightness.light ? textPrimaryLight : textPrimaryDark;
  }

  static Color getTextSecondary(Brightness brightness) {
    return brightness == Brightness.light ? textSecondaryLight : textSecondaryDark;
  }

  static Color getBorder(Brightness brightness) {
    return brightness == Brightness.light ? borderLight : borderDark;
  }

  static Color getWarning(Brightness brightness) {
    return brightness == Brightness.light ? warningLight : warningDark;
  }

  static Color getError(Brightness brightness) {
    return brightness == Brightness.light ? errorLight : errorDark;
  }

  static Color getSuccess(Brightness brightness) {
    return brightness == Brightness.light ? successLight : successDark;
  }

  static Color getInfo(Brightness brightness) {
    return brightness == Brightness.light ? infoLight : infoDark;
  }
}

