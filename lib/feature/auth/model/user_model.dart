class UserModel {
  final String? id;
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? phone;
  final String? password;
  final String? confirm_password;
  final String? avatar;

  // Constructor
  const UserModel({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.phone,
    this.password,
    this.confirm_password,
    this.avatar,
  });

  // Factory constructor: from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      confirm_password: json['confirm_password'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
      'password': password,
      'confirm_password': confirm_password,
      'avatar': avatar,
    };
  }
}