 import 'package:private_chat/models/user_model.dart';

class ResponseData {
  final int statusCode;
  final UserModel userModel;

  ResponseData(this.statusCode, this.userModel);
}