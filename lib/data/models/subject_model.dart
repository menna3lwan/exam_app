/// Subject entity matching the Postman `GET /subjects` response shape.
class SubjectModel {
  final String id;
  final String name;
  final String icon;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'icon': icon,
      };
}
