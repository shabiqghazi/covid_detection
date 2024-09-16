class UserModel {
  final String? name,
      email,
      phone,
      address,
      birthDate,
      geoPoint,
      gender,
      role,
      createdAt;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.birthDate,
    this.geoPoint,
    this.gender,
    this.role,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'birthDate': birthDate,
      'geoPoint': geoPoint,
      'gender': gender,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      birthDate: json['birthDate'] as String,
      geoPoint: json['geoPoint'] as String,
      gender: json['gender'] as String,
      role: json['role'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
