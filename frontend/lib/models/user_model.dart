class UserModel {
  final int? id;
  final String name;
  final String phone;
  final String? fcmtoken;

  UserModel({this.id, required this.name, required this.phone, this.fcmtoken});
}
