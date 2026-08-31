import 'package:flutter/foundation.dart';
import '../api/project_api.dart';
import '../models/project.dart';

/// Mirror del store de Zustand (projectStore.ts): misma forma,
/// mismos métodos, mismo comportamiento (incluida la actualización local
/// de imagen sin refetch tras un upload exitoso).
class ProjectStore extends ChangeNotifier {
  final ProjectApi _api;
  ProjectStore(this._api);

  List<Project> projects = [];
  bool loading = false;
  String? error;

  Future<void> fetchProjects() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      projects = await _api.getProjects();
    } catch (_) {
      error = 'Error al cargar proyectos';
    }
    loading = false;
    notifyListeners();
  }

  Future<Project?> createProject(Map<String, dynamic> data) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final created = await _api.createProject(data);
      projects = [...projects, created];
      loading = false;
      notifyListeners();
      return created;
    } catch (_) {
      error = 'Error al crear proyecto';
      loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> updateProject(int id, Map<String, dynamic> data) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final updated = await _api.updateProject(id, data);
      projects = [for (final p in projects) p.id == id ? updated : p];
    } catch (_) {
      error = 'Error al actualizar proyecto';
    }
    loading = false;
    notifyListeners();
  }

  Future<void> deleteProject(int id) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await _api.deleteProject(id);
      projects = projects.where((p) => p.id != id).toList();
    } catch (_) {
      error = 'Error al eliminar proyecto';
    }
    loading = false;
    notifyListeners();
  }

  /// Patch local de la URL de imagen tras un upload exitoso — sin refetch,
  /// igual que setImage() en el store original.
  void setImage(int id, String field, String url) {
    projects = [
      for (final p in projects)
        if (p.id == id) _withImage(p, field, url) else p,
    ];
    notifyListeners();
  }

  Project _withImage(Project p, String field, String url) {
    final copy = p.deepCopy();
    if (field == 'hero_image_url') {
      copy.heroImageUrl = url;
    } else if (field == 'card_thumbnail_url') {
      copy.cardThumbnailUrl = url;
    }
    return copy;
  }
}
