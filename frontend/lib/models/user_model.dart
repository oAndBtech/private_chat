class UserModel {
  final int? id;
  final String name;
  final String phone;
  final String? fcmtoken;

  UserModel({this.id, required this.name, required this.phone, this.fcmtoken});

  UserModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? fcmtoken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      fcmtoken: fcmtoken ?? this.fcmtoken,
    );
  }
}
