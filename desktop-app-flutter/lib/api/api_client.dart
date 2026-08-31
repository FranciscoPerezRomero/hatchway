import 'package:dio/dio.dart';

/// URL base de la API — se pasa en build/run con
/// --dart-define=API_URL=https://api.plicdreft.com (igual que VITE_API_URL
/// en la versión Electron). Sin valor por defecto en producción para evitar
/// apuntar accidentalmente a un dominio equivocado; en dev cae a localhost.
const String _apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://localhost:8000',
);

Dio buildDio() {
  return Dio(
    BaseOptions(
      baseUrl: _apiUrl,
      connectTimeout: const Duration(seconds: 15),
      // Los uploads de imágenes reales pueden tardar más que el resto de
      // llamadas — límite generoso para no confundir un upload lento con
      // un error de red.
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}
