import 'package:flutter_test/flutter_test.dart';
import 'package:hatchway_desktop/models/project.dart';

void main() {
  final sample = {
    'id': 4,
    'slug': 'landing-page-muebleria-rada',
    'order': 2,
    'project_type': 'web_app',
    'is_published': true,
    'is_featured': false,
    'title': 'Landing page Muebleria Rada',
    'tagline': 'Landing page de contacto para muebleria Rada',
    'hero_image_url': null,
    'cta_primary_label': 'live_demo() ->',
    'cta_primary_url': 'https://rada-landing-propuesta-cliente.vercel.app/',
    'cta_secondary_label': '',
    'cta_secondary_url': '',
    'repository_url': '',
    'role': 'Fulls-Stack Developer',
    'year': 2026,
    'status': 'Live',
    'client': 'Mueblería Rada',
    'duration': '1 semana',
    'team_size': 'Solo',
    'challenge_paragraph_1': 'Contexto del reto',
    'challenge_paragraph_2': 'Solución adoptada',
    'key_challenges': ['Respetar identidad visual'],
    'tech_stack': [
      {
        'category': 'Frontend',
        'technologies': ['React', 'Tailwind', 'Vite'],
      },
    ],
    'features': [
      {'title': 'Botón de whatsapp', 'description': 'Contacto directo'},
    ],
    'metrics': <String>[],
    'main_screenshot_url': '',
    'screenshots': <String>[],
    'card_thumbnail_url': null,
    'card_short_description': '',
    'tags': <String>[],
    'seo_title': '',
    'seo_description': 'Landing page de contacto',
    'created_at': '2026-08-30T02:19:40.698063',
    'updated_at': '2026-08-30T02:42:16.384580',
  };

  test('fromJson mapea todos los campos snake_case correctamente', () {
    final project = Project.fromJson(sample);
    expect(project.id, 4);
    expect(project.slug, 'landing-page-muebleria-rada');
    expect(project.isPublished, true);
    expect(project.ctaPrimaryUrl, 'https://rada-landing-propuesta-cliente.vercel.app/');
    expect(project.techStack.single.category, 'Frontend');
    expect(project.techStack.single.technologies, ['React', 'Tailwind', 'Vite']);
    expect(project.features.single.title, 'Botón de whatsapp');
    expect(project.keyChallenges, ['Respetar identidad visual']);
    expect(project.createdAt, isNotNull);
  });

  test('toCreateJson excluye id/created_at/updated_at y preserva el resto', () {
    final project = Project.fromJson(sample);
    final payload = project.toCreateJson();

    expect(payload.containsKey('id'), isFalse);
    expect(payload.containsKey('created_at'), isFalse);
    expect(payload.containsKey('updated_at'), isFalse);

    expect(payload['slug'], 'landing-page-muebleria-rada');
    expect(payload['project_type'], 'web_app');
    expect(payload['tech_stack'], [
      {
        'category': 'Frontend',
        'technologies': ['React', 'Tailwind', 'Vite'],
      },
    ]);
    expect(payload['features'], [
      {'title': 'Botón de whatsapp', 'description': 'Contacto directo'},
    ]);
  });

  test('listas vacías por defecto cuando el JSON no las incluye', () {
    final minimal = Project.fromJson({'slug': 'x', 'title': 'X'});
    expect(minimal.keyChallenges, isEmpty);
    expect(minimal.techStack, isEmpty);
    expect(minimal.features, isEmpty);
    expect(minimal.order, 0);
    expect(minimal.projectType, 'web_app');
    expect(minimal.isPublished, false);
  });
}
