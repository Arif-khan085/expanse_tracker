class UserModel {
  String? email;
  String? password;
  String? confirmPassword;
  String? id;

  UserModel({this.email, this.password, this.confirmPassword, this.id});

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      id: json['id'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'id': id,
    };
  }

  // CopyWith
  UserModel copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? id,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      id: id ?? this.id,
    );
  }
}
