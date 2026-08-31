import 'package:dio/dio.dart';
import '../models/project.dart';

class ProjectApi {
  final Dio _dio;
  ProjectApi(this._dio);

  Future<List<Project>> getProjects() async {
    final res = await _dio.get('/api/projects');
    return (res.data as List)
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(Map<String, dynamic> data) async {
    final res = await _dio.post('/api/projects', data: data);
    return Project.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Project> updateProject(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/api/projects/$id', data: data);
    return Project.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteProject(int id) async {
    await _dio.delete('/api/projects/$id');
  }

  /// field: 'hero' -> hero_image_url, 'card' -> card_thumbnail_url.
  /// Se llama DESPUÉS de crear/actualizar el proyecto (requiere id existente).
  Future<String> uploadProjectImage(int id, String filePath, String field) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.post(
      '/api/projects/$id/images',
      queryParameters: {'field': field},
      data: form,
    );
    return res.data['url'] as String;
  }

  /// Endpoint genérico usado para main_screenshot_url / screenshots,
  /// llamado ANTES de crear/actualizar el proyecto.
  Future<String> uploadGeneric(String filePath) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.post('/api/upload', data: form);
    return res.data['url'] as String;
  }
}
