import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/components/members_element.dart';
import 'package:private_chat/models/room_model.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/users_in_room_provider.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({super.key});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  groupMembersDialog() {
    return AlertDialog(
      backgroundColor: const Color(0xff111216),
      title: Text(
        "Group Members",
        style: GoogleFonts.montserrat(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: const Color(0xffFFFFFF)),
      ),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 12, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: generateList(),
        ),
      ),
    );
  }

  List<Widget> generateList() {
    List<UserModel> usrs = ref.watch(usersInRoomProvider);
    List<Widget> list = List.generate(
        usrs.length,
        (index) =>
            MemberElement(name: usrs[index].name, number: usrs[index].phone));
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
      color: const Color(0xff111216),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            backgroundColor: const Color(0xff111216),
                            title: Text(
                              'Are you sure you want to exit?',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xffFFFFFF)),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff000000)))),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                  255, 50, 153, 101))),
                                  onPressed: () {
                                    exit(0);
                                  },
                                  child: Text('Exit',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff000000))))
                            ],
                          )));
                },
                child: const Icon(
                  FontAwesomeIcons.xmark,
                  size: 28,
                  color: Color(0xffFFFFFF),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
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
