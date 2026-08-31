import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Pareja tipográfica: Inter (sans, cuerpo/títulos) + JetBrains Mono
/// (labels, tabs, acentos "// comentario") — evolución del mono genérico
/// del navegador que usaba la versión web hacia un mono real de dev-tool.
class AppTypography {
  AppTypography._();

  static TextStyle sans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textPrimary,
    double? height,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      );

  static TextStyle mono({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textSecondary,
    double? letterSpacing,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// Poster/propaganda-style display face — usado en títulos grandes
  /// (referencia: cartel Star Wars rebelde).
  static TextStyle display({
    double fontSize = 28,
    Color color = AppColors.textPrimary,
  }) =>
      GoogleFonts.archivoBlack(fontSize: fontSize, color: color);

  static TextStyle sectionTitle() => mono(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.neonRed,
        letterSpacing: 1.5,
      );

  static TextStyle label() => mono(
        fontSize: 11,
        color: AppColors.textSecondary,
      );
}
