class Feature {
  String title;
  String description;

  Feature({required this.title, required this.description});

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        title: json['title'] as String,
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
