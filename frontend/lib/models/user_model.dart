class UserModel {
  final int? id;
  final String name;
  final String phone;
  final String? fcmtoken;
  final String? webfcmtoken;

  UserModel({this.id, required this.name, required this.phone, this.fcmtoken,this.webfcmtoken});

  UserModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? fcmtoken,
    final String? webfcmtoken
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      fcmtoken: fcmtoken ?? this.fcmtoken,
      webfcmtoken: webfcmtoken ?? this.webfcmtoken
    );
  }
}
