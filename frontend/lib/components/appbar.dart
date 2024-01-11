import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/models/room_model.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/users_in_room_provider.dart';
import 'package:private_chat/services/api_services.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({super.key});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  //TODO: fetch room name and people count, hardcoded right now

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAllUsers();
    fetchRoom();
  }

  fetchAllUsers() async {
    String roomId = 'abc'; //TODO: hardcoded
    List<UserModel> usrs = await ApiService().allUsersInRoom(roomId) ?? [];
    ref.read(usersInRoomProvider.notifier).addAllUsers(usrs);
  }

  fetchRoom() async {
    String roomId = 'abc'; //TODO: hardcoded
    RoomModel? room = await ApiService().getRoom(roomId);
    if (room != null) {
      ref.read(roomProvider.notifier).addRoom(room);
    }
  }

//TODO: need to work on design
  groupMembersDialog() {
    return AlertDialog(
      title: Center(child: Text("Group Members")),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: generateList(),
      )),
    );
  }
  List<Widget> generateList() {
    List<UserModel> usrs = ref.watch(usersInRoomProvider);
    List<Widget> list = List.generate(
        usrs.length,
        (index) => Column(
              children: [
                Text(usrs[index].name),
                Text(usrs[index].phone),
                Divider()
              ],
            ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    int totalMembers = ref.watch(usersInRoomProvider).length;

    RoomModel? room = ref.watch(roomProvider);
    String roomName = "Group";

    if (room != null) {
      setState(() {
        roomName = room.roomName ?? "Group";
      });
    }

    return Container(
      height: 62,
      width: double.infinity,
      color: const Color(0xff000000).withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.arrow_back,
              size: 28,
              color: Color(0xffFFFFFF),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: ((context) => groupMembersDialog()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                      text: TextSpan(
                          text: roomName,
                          style: GoogleFonts.montserrat(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                              color: const Color(0xffFFFFFF)))),
                  RichText(
                      text: TextSpan(
                    text: '$totalMembers people are in the room',
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffBABABA)),
                  ))
                ],
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.more_vert_rounded,
              size: 28,
              color: Color(0xffFFFFFF),
            )
          ],
        ),
      ),
    );
  }
}
