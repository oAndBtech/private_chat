import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/user_model.dart';

final usersInRoomProvider = StateNotifierProvider<UserRoomNotifier, List<UserModel>>((ref) => UserRoomNotifier());

class UserRoomNotifier extends StateNotifier<List<UserModel>>{
  UserRoomNotifier(): super([]);

  void addUser(UserModel usr) {
    state = [...state, usr];
  }

  void addAllUsers(List<UserModel> usrs) {
    state = [...state, ...usrs];
  }

  void deleteUsers(UserModel usr) {
    state = state.where((element) => element != usr).toList();
  }

  void deleteAllUsers() {
    state = [];
  }
  
}
