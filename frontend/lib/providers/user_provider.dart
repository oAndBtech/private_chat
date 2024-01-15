import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/user_model.dart';

final userIdProvider = StateProvider<int>((ref) => -1);
final notificationProvider = StateProvider<bool>((ref) => true);
final userProvider =
    StateProvider<UserModel?>((ref) => null);

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void addUser(UserModel user) {
    state = state?.copyWith(
        id: user.id,
        name: user.name,
        phone: user.phone,
        fcmtoken: user.fcmtoken,
        webfcmtoken: user.webfcmtoken);
  }

  void updateName(String newName) {
    state = state?.copyWith(name: newName);
  }

  void updateFcmtoken(String newFcmtoken) {
    state = state?.copyWith(fcmtoken: newFcmtoken);
  }

  void updateWebFcmtoken(String newWebFcmtoken) {
    state = state?.copyWith(webfcmtoken: newWebFcmtoken);
  }

  void updatePhone(String newPhone) {
    state = state?.copyWith(phone: newPhone);
  }

  void updateId(int newId) {
    state = state?.copyWith(id: newId);
  }

  void clearState() {
    state = null;
  }
}
