import 'package:flutter/material.dart';

/// Paleta "brutalism tech": negro real + rojo neón como acento primario,
/// un arcoíris neón contenido para semántica de status, bloques con
/// bordes duros y vidrio esmerilado para paneles flotantes.
class AppColors {
  AppColors._();

  // Fondos
  static const bgBlack = Color(0xFF050506);
  static const bgPanel = Color(0xFF0D0D10);
  static const surfaceBlock = Color(0xFF131316);
  static const surfaceBlockAlt = Color(0xFF1A1A1E);

  // Bordes / estructura brutalista
  static const borderWhite = Color(0xFFF2F2F2);
  static const borderDim = Color(0xFF2A2A2E);

  // Texto
  static const textPrimary = Color(0xFFF5F5F7);
  static const textSecondary = Color(0xFFA8A8B3);
  static const textMuted = Color(0xFF6B6B75);

  // Acento primario
  static const neonRed = Color(0xFFFF1744);
  static const neonRedDim = Color(0xFFB3002E);

  // Acentos secundarios (status / semántica)
  static const neonGreen = Color(0xFF39FF14);
  static const neonCyan = Color(0xFF00F5FF);
  static const neonAmber = Color(0xFFFFB800);
  static const neonMagenta = Color(0xFFFF2ED1);

  static const danger = neonRed;

  /// (borde, texto) de la pill de status — cada estado con su propio neón,
  /// fondo translúcido del mismo color + texto sólido.
  static (Color border, Color fg) statusPillColors(String? status) {
    switch (status) {
      case 'Live':
        return (neonGreen, neonGreen);
      case 'In Development':
        return (neonCyan, neonCyan);
      case 'Deprecated':
        return (neonAmber, neonAmber);
      case 'Open Source':
        return (neonMagenta, neonMagenta);
      default:
        return (borderDim, textMuted);
    }
  }

  static (Color border, Color fg) publishedPillColors(bool isPublished) {
    return isPublished ? (neonGreen, neonGreen) : (borderDim, textMuted);
  }

  /// Sombra dura tipo "sticker" — sin blur, con offset. La firma visual
  /// brutalista de bloques y botones.
  static List<BoxShadow> hardShadow({Color color = neonRed, double offset = 4}) => [
        BoxShadow(color: color, offset: Offset(offset, offset), blurRadius: 0),
      ];

  /// Resplandor neón — con blur, usado en hover/focus y acentos glass.
  static List<BoxShadow> neonGlow(Color color, {double blur = 18, double spread = -2}) => [
        BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: blur, spreadRadius: spread),
      ];
}
