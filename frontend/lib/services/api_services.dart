import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:private_chat/models/add_user_response.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/room_model.dart';
import 'package:private_chat/models/user_model.dart';

class ApiService {
  String backendUrl = dotenv.env["backendIp"]!;

  String formatTimestamp(String timestampString) {
    DateTime timestamp = DateTime.parse(timestampString).toLocal();
    DateTime currentDate = DateTime.now();
    if (timestamp.year == currentDate.year &&
        timestamp.month == currentDate.month &&
        timestamp.day == currentDate.day) {
      return DateFormat('hh:mm a').format(timestamp);
    } else {
      return DateFormat('hh:mm a, dd-MM-yyyy').format(timestamp);
    }
  }

  Future<UserModel?> getUser(int id) async {
    try {
      final response = await http.get(Uri.parse("$backendUrl/user/$id"));

      if (response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);

        return UserModel(
            id: jsonResponse["id"],
            name: jsonResponse["name"],
            phone: jsonResponse["phone"],
            notif: jsonResponse["notif"],
            fcmtoken: jsonResponse["fcmtoken"]);
      }
      print(response.body);
      return null;
    } catch (e) {
      print("Error in getUser: $e");
      return null;
    }
  }

  Future<ResponseData?> addUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/user"),
        body: jsonEncode({
          "name": user.name,
          "phone": user.phone,
          "fcmtoken": user.fcmtoken,
          "webfcmtoken": user.webfcmtoken
        }),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode < 300 || response.statusCode == 409) {
        if (jsonResponse["id"] != null &&
            jsonResponse["name"] != null &&
            jsonResponse["phone"] != null) {
          final userModel = UserModel(
              id: jsonResponse["id"],
              name: jsonResponse["name"],
              phone: jsonResponse["phone"],
              fcmtoken: jsonResponse["fcmtoken"],
              notif: jsonResponse["notif"],
              webfcmtoken: jsonResponse["webfcmtoken"]);
          return ResponseData(response.statusCode, userModel);
        } else {
          print("Invalid response data");
          return null;
        }
      } else {
        print("Error in addUser: Status Code ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error in addUser: $e");
      return null;
    }
  }

  Future<bool> updateUser(UserModel user, int id) async {
    try {
      final response = await http.post(Uri.parse("$backendUrl/user/$id"),
          body: jsonEncode({"name": user.name, "fcmtoken": user.fcmtoken}));

      return response.statusCode < 300;
    } catch (e) {
      print("Error in updateUser: $e");
      return false;
    }
  }

  Future<bool> updateFcmToken(String fcmtoken, int id) async {
    try {
      final response = await http.post(Uri.parse("$backendUrl/user/$id"),
          body: jsonEncode({"fcmtoken": fcmtoken}));

      return response.statusCode < 300;
    } catch (e) {
      print("Error in updateFcmToken: $e");
      return false;
    }
  }

  Future<bool> updateWebFcmToken(String webfcmtoken, int id) async {
    try {
      final response = await http.post(Uri.parse("$backendUrl/user/$id"),
          body: jsonEncode({"webfcmtoken": webfcmtoken}));

      return response.statusCode < 300;
    } catch (e) {
      print("Error in updateWebFcmToken: $e");
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse("$backendUrl/user/$id"));

      return response.statusCode < 300;
    } catch (e) {
      print("Error in deleteUser: $e");
      return false;
    }
  }

  Future<RoomModel?> addRoom(RoomModel room) async {
    try {
      final response = await http.post(Uri.parse("$backendUrl/room/oandbtech"),
          body: jsonEncode({"roomid": room.roomId, "roomname": room.roomName}));

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode < 300 || response.statusCode == 409) {
        return RoomModel(
            roomId: jsonResponse["roomid"],
            roomName: jsonResponse["roomname"],
            id: jsonResponse["id"]);
      } else {
        return null;
      }
    } catch (e) {
      print("Error in addRoom: $e");
      return null;
    }
  }

  Future<bool> deleteRoom(String id) async {
    try {
      final response = await http.delete(Uri.parse("$backendUrl/room/$id"));

      return response.statusCode < 300;
    } catch (e) {
      print("Error in deleteRoom: $e");
      return false;
    }
  }

  Future<RoomModel?> getRoom(String id) async {
    try {
      final response = await http.get(Uri.parse("$backendUrl/room/$id"));

      if (response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);

        return RoomModel(
            roomId: jsonResponse["roomid"],
            roomName: jsonResponse["roomname"] ?? "",
            id: jsonResponse["id"]);
      } else {
        print("FAILED to get room details");
        return null;
      }
    } catch (e) {
      print("Error in getRoom: $e");
      return null;
    }
  }

  Future<List<UserModel>?> allUsersInRoom(String id) async {
    try {
      final response = await http.get(Uri.parse("$backendUrl/room/$id/users"));

      if (response.statusCode < 300) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse
            .map((user) => UserModel(
                id: user["id"],
                name: user["name"],
                phone: user["phone"],
                fcmtoken: user["fcmtoken"]))
            .toList();
      }
      return null;
    } catch (e) {
      print("Error in allUsersInRoom: $e");
      return null;
    }
  }

  Future<List<MessageModel>?> messagesInRoom(String id) async {
    try {
      final response =
          await http.get(Uri.parse("$backendUrl/room/$id/messages"));

      if (response.statusCode < 300) {
        List<dynamic> jsonResponse = jsonDecode(response.body);

        return jsonResponse
            .map((message) => MessageModel(
                replyto: message["replyto"],
                uniqueid: message["uniqueid"] ?? '',
                id: message["id"],
                sender: message["sender"],
                sendername: message["sendername"],
                istext: message["istext"],
                timestamp: formatTimestamp(
                    message["timestamp"] ?? DateTime.now().toString()),
                content: base64Decode(message["content"])))
            .toList();
      }
      return null;
    } catch (e) {
      print("Error in messagesInRoom: $e");
      return null;
    }
  }

  Future<bool> updateNotificationStatus(int id, bool value) async {
    try {
      final response = await http.post(Uri.parse("$backendUrl/user/$id/notif"),
          body: jsonEncode({"notif": value}));

      if (response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("ERROR in updateNotificationStatus : $e");
      return false;
    }
  }

  Future<bool> exitRoom(int userId, String roomId) async {
    try {
      final response = await http.delete(
          Uri.parse("$backendUrl/room?roomId=$roomId&userId=$userId"),
          headers: {"Access-Control-Allow-Origin": "*"});

      if (response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("ERROR in exitRoom : $e");
      return false;
    }
  }
}
