import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/file_size.dart';

const List<String> kImageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'avif'];

/// Abre el selector nativo de imagen, valida el límite de tamaño y
/// devuelve el path elegido (o null si se canceló / se rechazó por tamaño).
/// Reutilizado por ImagePickerField y por el botón "Agregar screenshot".
Future<String?> pickImageFile(BuildContext context) async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: kImageExtensions,
    allowMultiple: false,
  );
  if (result == null || result.files.isEmpty) return null;
  final file = result.files.single;
  if (exceedsUploadLimit(file.size)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La imagen supera el límite de 20MB.')),
      );
    }
    return null;
  }
  return file.path;
}

/// Selector de imagen reutilizable: bloque de borde duro, o preview con
/// botones "Cambiar"/quitar — equivalente al ImagePicker interno de
/// ProjectForm.tsx, ahora respaldado por un file_picker nativo en vez del
/// diálogo IPC de Electron.
class ImagePickerField extends StatefulWidget {
  final String labelText;
  final String? localFilePath;
  final String? existingUrl;
  final ValueChanged<String?> onFilePicked;
  final VoidCallback onCleared;

  const ImagePickerField({
    super.key,
    required this.labelText,
    required this.onFilePicked,
    required this.onCleared,
    this.localFilePath,
    this.existingUrl,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  bool _hovering = false;

  Future<void> _pick(BuildContext context) async {
    final path = await pickImageFile(context);
    if (path != null) widget.onFilePicked(path);
  }

  @override
  Widget build(BuildContext context) {
    final hasPreview = widget.localFilePath != null || (widget.existingUrl != null && widget.existingUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText, style: AppTypography.label()),
        const SizedBox(height: AppSpacing.xs),
        if (hasPreview)
          Container(
            decoration: BoxDecoration(border: Border.all(color: AppColors.borderDim, width: 1.5)),
            child: Stack(
              children: [
                SizedBox(
                  height: 128,
                  width: double.infinity,
                  child: widget.localFilePath != null
                      ? Image.file(File(widget.localFilePath!), fit: BoxFit.cover)
                      : Image.network(widget.existingUrl!, fit: BoxFit.cover),
                ),
                Positioned(top: 8, right: 8, child: _squareIconButton(Icons.close, widget.onCleared)),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _pick(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        border: Border.all(color: AppColors.borderWhite, width: 1),
                      ),
                      child: Text('CAMBIAR', style: AppTypography.mono(fontSize: 10, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          MouseRegion(
            onEnter: (_) => setState(() => _hovering = true),
            onExit: (_) => setState(() => _hovering = false),
            child: InkWell(
              onTap: () => _pick(context),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _hovering ? AppColors.neonRed.withValues(alpha: 0.06) : Colors.transparent,
                  border: Border.all(color: _hovering ? AppColors.neonRed : AppColors.borderDim, width: 1.5),
                  boxShadow: _hovering ? AppColors.neonGlow(AppColors.neonRed, blur: 14, spread: -4) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, color: _hovering ? AppColors.neonRed : AppColors.textMuted, size: 26),
                    const SizedBox(height: AppSpacing.sm),
                    Text('SELECCIONAR IMAGEN', style: AppTypography.mono(fontSize: 11, color: _hovering ? AppColors.neonRed : AppColors.textMuted)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _squareIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.8), border: Border.all(color: AppColors.borderWhite, width: 1)),
        child: Icon(icon, size: 13, color: Colors.white),
      ),
    );
  }
}
