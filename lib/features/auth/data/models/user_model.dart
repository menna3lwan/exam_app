/// User model matching the exact Postman API response shape.
///
/// ```json
/// {
///   "_id": "6a607e92d2ea07268fb2e659",
///   "username": "testuser123",
///   "firstName": "Test",
///   "lastName": "User",
///   "email": "test@test.com",
///   "phone": "01012345678",
///   "role": "user",
///   "isVerified": false,
///   "createdAt": "2026-07-22T08:25:54.498Z"
/// }
/// ```
class UserModel {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final bool isVerified;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.isVerified,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
