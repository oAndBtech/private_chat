import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/user_model.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, UserModel?>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void addUser(UserModel user) {
    state = state?.copyWith(
        id: user.id,
        name: user.name,
        phone: user.phone,
        fcmtoken: user.fcmtoken);
  }

  void updateName(String newName) {
    state = state?.copyWith(name: newName);
  }

  void updateFcmtoken(String newFcmtoken) {
    state = state?.copyWith(fcmtoken: newFcmtoken);
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
