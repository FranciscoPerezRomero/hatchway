import 'feature.dart';
import 'tech_category.dart';

/// Tipos de proyecto soportados por el backend.
const List<String> kProjectTypes = ['web_app', 'mobile_app', 'api', 'library', 'tool'];

/// Valores posibles del campo "status" (pill cosmética, no es un workflow).
const List<String> kProjectStatuses = ['Live', 'In Development', 'Deprecated', 'Open Source'];

class Project {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Identificación
  String slug;
  int order;
  String projectType;
  bool isPublished;
  bool isFeatured;

  // Hero
  String title;
  String? tagline;
  String? heroImageUrl;
  String? ctaPrimaryLabel;
  String? ctaPrimaryUrl;
  String? ctaSecondaryLabel;
  String? ctaSecondaryUrl;
  String? repositoryUrl;

  // Metadata
  String? role;
  int? year;
  String? status;
  String? client;
  String? duration;
  String? teamSize;

  // Contenido
  String? challengeParagraph1;
  String? challengeParagraph2;
  List<String> keyChallenges;

  // Tech stack y features
  List<TechCategory> techStack;
  List<Feature> features;

  // Métricas
  List<String> metrics;

  // Galería
  String? mainScreenshotUrl;
  List<String> screenshots;

  // Card
  String? cardThumbnailUrl;
  String? cardShortDescription;
  List<String> tags;

  // SEO
  String? seoTitle;
  String? seoDescription;

  Project({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.slug = '',
    this.order = 0,
    this.projectType = 'web_app',
    this.isPublished = false,
    this.isFeatured = false,
    this.title = '',
    this.tagline,
    this.heroImageUrl,
    this.ctaPrimaryLabel,
    this.ctaPrimaryUrl,
    this.ctaSecondaryLabel,
    this.ctaSecondaryUrl,
    this.repositoryUrl,
    this.role,
    this.year,
    this.status,
    this.client,
    this.duration,
    this.teamSize,
    this.challengeParagraph1,
    this.challengeParagraph2,
    List<String>? keyChallenges,
    List<TechCategory>? techStack,
    List<Feature>? features,
    List<String>? metrics,
    this.mainScreenshotUrl,
    List<String>? screenshots,
    this.cardThumbnailUrl,
    this.cardShortDescription,
    List<String>? tags,
    this.seoTitle,
    this.seoDescription,
  })  : keyChallenges = keyChallenges ?? [],
        techStack = techStack ?? [],
        features = features ?? [],
        metrics = metrics ?? [],
        screenshots = screenshots ?? [],
        tags = tags ?? [];

  factory Project.fromJson(Map<String, dynamic> j) => Project(
        id: j['id'] as int?,
        createdAt: j['created_at'] != null ? DateTime.tryParse(j['created_at'] as String) : null,
        updatedAt: j['updated_at'] != null ? DateTime.tryParse(j['updated_at'] as String) : null,
        slug: j['slug'] as String? ?? '',
        order: j['order'] as int? ?? 0,
        projectType: j['project_type'] as String? ?? 'web_app',
        isPublished: j['is_published'] as bool? ?? false,
        isFeatured: j['is_featured'] as bool? ?? false,
        title: j['title'] as String? ?? '',
        tagline: j['tagline'] as String?,
        heroImageUrl: j['hero_image_url'] as String?,
        ctaPrimaryLabel: j['cta_primary_label'] as String?,
        ctaPrimaryUrl: j['cta_primary_url'] as String?,
        ctaSecondaryLabel: j['cta_secondary_label'] as String?,
        ctaSecondaryUrl: j['cta_secondary_url'] as String?,
        repositoryUrl: j['repository_url'] as String?,
        role: j['role'] as String?,
        year: j['year'] as int?,
        status: j['status'] as String?,
        client: j['client'] as String?,
        duration: j['duration'] as String?,
        teamSize: j['team_size'] as String?,
        challengeParagraph1: j['challenge_paragraph_1'] as String?,
        challengeParagraph2: j['challenge_paragraph_2'] as String?,
        keyChallenges: (j['key_challenges'] as List? ?? []).cast<String>(),
        techStack: ((j['tech_stack'] as List?) ?? [])
            .map((e) => TechCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
        features: ((j['features'] as List?) ?? [])
            .map((e) => Feature.fromJson(e as Map<String, dynamic>))
            .toList(),
        metrics: (j['metrics'] as List? ?? []).cast<String>(),
        mainScreenshotUrl: j['main_screenshot_url'] as String?,
        screenshots: (j['screenshots'] as List? ?? []).cast<String>(),
        cardThumbnailUrl: j['card_thumbnail_url'] as String?,
        cardShortDescription: j['card_short_description'] as String?,
        tags: (j['tags'] as List? ?? []).cast<String>(),
        seoTitle: j['seo_title'] as String?,
        seoDescription: j['seo_description'] as String?,
      );

  /// Payload usado tanto para POST /api/projects como PUT /api/projects/{id}
  /// — excluye id/created_at/updated_at, igual que ProjectCreate en el backend.
  Map<String, dynamic> toCreateJson() => {
        'slug': slug,
        'order': order,
        'project_type': projectType,
        'is_published': isPublished,
        'is_featured': isFeatured,
        'title': title,
        'tagline': tagline,
        'hero_image_url': heroImageUrl,
        'cta_primary_label': ctaPrimaryLabel,
        'cta_primary_url': ctaPrimaryUrl,
        'cta_secondary_label': ctaSecondaryLabel,
        'cta_secondary_url': ctaSecondaryUrl,
        'repository_url': repositoryUrl,
        'role': role,
        'year': year,
        'status': status,
        'client': client,
        'duration': duration,
        'team_size': teamSize,
        'challenge_paragraph_1': challengeParagraph1,
        'challenge_paragraph_2': challengeParagraph2,
        'key_challenges': keyChallenges,
        'tech_stack': techStack.map((t) => t.toJson()).toList(),
        'features': features.map((f) => f.toJson()).toList(),
        'metrics': metrics,
        'main_screenshot_url': mainScreenshotUrl,
        'screenshots': screenshots,
        'card_thumbnail_url': cardThumbnailUrl,
        'card_short_description': cardShortDescription,
        'tags': tags,
        'seo_title': seoTitle,
        'seo_description': seoDescription,
      };

  /// Copia profunda — usada para inicializar el borrador del formulario de
  /// edición sin mutar el proyecto que vive en la lista del store.
  Project deepCopy() => Project(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        slug: slug,
        order: order,
        projectType: projectType,
        isPublished: isPublished,
        isFeatured: isFeatured,
        title: title,
        tagline: tagline,
        heroImageUrl: heroImageUrl,
        ctaPrimaryLabel: ctaPrimaryLabel,
        ctaPrimaryUrl: ctaPrimaryUrl,
        ctaSecondaryLabel: ctaSecondaryLabel,
        ctaSecondaryUrl: ctaSecondaryUrl,
        repositoryUrl: repositoryUrl,
        role: role,
        year: year,
        status: status,
        client: client,
        duration: duration,
        teamSize: teamSize,
        challengeParagraph1: challengeParagraph1,
        challengeParagraph2: challengeParagraph2,
        keyChallenges: [...keyChallenges],
        techStack: techStack.map((t) => TechCategory(category: t.category, technologies: [...t.technologies])).toList(),
        features: features.map((f) => Feature(title: f.title, description: f.description)).toList(),
        metrics: [...metrics],
        mainScreenshotUrl: mainScreenshotUrl,
        screenshots: [...screenshots],
        cardThumbnailUrl: cardThumbnailUrl,
        cardShortDescription: cardShortDescription,
        tags: [...tags],
        seoTitle: seoTitle,
        seoDescription: seoDescription,
      );
}
