class UserModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? role;
  final String? address;
  final String? image;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.role,
    this.address,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
      address: json['address'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'address': address,
      'image': image,
    };
  }
}