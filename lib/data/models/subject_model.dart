/// Subject entity matching the Postman `GET /subjects` response shape.
///
/// ```json
/// {
///   "_id": "69d980107c82914570305dbd",
///   "name": "JavaScript",
///   "icon": "https://exam.elevateegy.com/uploads/categories/seeder-javascript.png",
///   "createdAt": "2026-04-10T22:56:16.582Z"
/// }
/// ```
class SubjectModel {
  final String id;
  final String name;
  final String icon; // URL string from API
  final DateTime? createdAt;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
    this.createdAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'icon': icon,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
