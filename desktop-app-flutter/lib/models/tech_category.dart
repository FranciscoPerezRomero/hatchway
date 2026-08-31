class TechCategory {
  String category;
  List<String> technologies;

  TechCategory({required this.category, required this.technologies});

  factory TechCategory.fromJson(Map<String, dynamic> json) => TechCategory(
        category: json['category'] as String,
        technologies: (json['technologies'] as List).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'technologies': technologies,
      };
}
