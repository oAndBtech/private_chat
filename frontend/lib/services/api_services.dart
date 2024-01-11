import 'dart:convert';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/room_model.dart';
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

  Future<UserModel?> addUser(UserModel user) async {
    final response = await http.post(Uri.parse("$backendUrl/user"),
        body: jsonEncode({
          "name": user.name,
          "phone": user.phone,
          "fcmtoken": user.fcmtoken
        }));

    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel(
          id: jsonResponse["id"],
          name: jsonResponse["name"],
          phone: jsonResponse["phone"],
          fcmtoken: jsonResponse["fcmtoken"]);
    } else if (response.statusCode == 205) {
      return UserModel(
          id: jsonResponse["id"],
          name: jsonResponse["name"],
          phone: jsonResponse["phone"],
          fcmtoken: jsonResponse["fcmtoken"]);
    } else {
      return null;
    }
  }

  Future<bool> updateUser(UserModel user, int id) async {
    final response = await http.post(Uri.parse("$backendUrl/user/$id"),
        body: jsonEncode({
          "name": user.name,
          "phone": user.phone,
          "fcmtoken": user.fcmtoken
        }));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateFcmToken(String fcmtoken, int id) async {
    final response = await http.post(Uri.parse("$backendUrl/user/$id"),
        body: jsonEncode({"fcmtoken": fcmtoken}));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    final response = await http.delete(Uri.parse("$backendUrl/user/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<RoomModel?> addRoom(RoomModel room) async {
    final response = await http.post(Uri.parse("$backendUrl/room/oandbtech"),
        body: jsonEncode(
            {"id": room.id, "roomid": room.roomId, "roomname": room.roomName}));

    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return RoomModel(
          roomId: jsonResponse["roomid"],
          roomName: jsonResponse["roomname"],
          id: jsonResponse["id"]);
    } else if (response.statusCode == 205) {
      return RoomModel(
          roomId: jsonResponse["roomid"],
          roomName: jsonResponse["roomname"],
          id: jsonResponse["id"]);
    } else {
      return null;
    }
  }

  Future<bool> deleteRoom(String id) async {
    final response = await http.delete(Uri.parse("$backendUrl/room/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<UserModel>?> allUsersInRoom(String id) async {
    final response = await http.get(Uri.parse("$backendUrl/room/$id/users"));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      return jsonResponse
          .map((user) => UserModel(
              id: user["id"],
              name: user["name"],
              phone: user["phone"],
              fcmtoken: user["fcmtoken"]))
          .toList();
    }
    return null;
  }

  Future<List<MessageModel>?> messagesInRoom(String id) async {
    final response = await http.get(Uri.parse("$backendUrl/room/$id/messages"));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);

      return jsonResponse
          .map((message) => MessageModel(
              id: message["id"],
              sender: message["sender"],
              sendername: message["sendername"],
              istext: message["istext"],
              timestamp: message["timestamp"],
              content: base64Decode(message["content"])))
          .toList();
    }
    return null;
  }
}
