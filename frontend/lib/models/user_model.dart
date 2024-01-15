class UserModel {
  final int? id;
  final String name;
  final String phone;
  final String? fcmtoken;
  final String? webfcmtoken;
  final bool? notif;

  UserModel(
      {this.id,
      required this.name,
      required this.phone,
      this.fcmtoken,
      this.webfcmtoken,
      this.notif});

  UserModel copyWith(
      {int? id,
      String? name,
      String? phone,
      String? fcmtoken,
      String? webfcmtoken,
      bool? notif}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      fcmtoken: fcmtoken ?? this.fcmtoken,
      webfcmtoken: webfcmtoken ?? this.webfcmtoken,
      notif: notif ?? this.notif,
    );
  }
}
