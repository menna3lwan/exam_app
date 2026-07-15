/// Subject entity matching the Postman `GET /subjects` response shape.
///
/// Fields confirmed from the `POST /subjects` (admin) endpoint which
/// accepts `name` (text) and `icon` (file upload). The GET response
/// likely mirrors these plus `_id` and timestamps.
class SubjectModel {
  final String id;
  final String name;
  final String icon; // URL from server; mapped to local asset in mock data

  const SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
  });
}
