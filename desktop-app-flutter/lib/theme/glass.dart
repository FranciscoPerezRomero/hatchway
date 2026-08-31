import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Superficie de vidrio esmerilado reutilizable: blur de fondo + panel
/// semitransparente + borde neón sutil. Usado para el panel deslizante
/// del formulario y otros overlays flotantes.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color tint;
  final Color borderColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassSurface({
    super.key,
    required this.child,
    this.blurSigma = 24,
    this.tint = const Color(0xCC0D0D10),
    this.borderColor = AppColors.borderDim,
    this.borderRadius = BorderRadius.zero,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
