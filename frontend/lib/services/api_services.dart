import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:private_chat/models/user_model.dart';

class ApiService {
  String backendUrl = "${dotenv.env['backendIp']!}:${dotenv.env['port']!}";

  Future<UserModel?> getUser(int id) async {
    final response = await http.get(Uri.parse("$backendUrl/user/$id"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return UserModel(
          id: jsonResponse["id"],
          name: jsonResponse["name"],
          phone: jsonResponse["phone"],
          fcmtoken: jsonResponse["fcmtoken"]);
    }
    print(response.body);
    return null;
  }
}
