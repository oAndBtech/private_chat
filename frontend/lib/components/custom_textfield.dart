import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:private_chat/components/members_element.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/message_provider.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/providers/users_in_room_provider.dart';
import 'package:private_chat/services/storage_service.dart';
import 'package:private_chat/services/api_services.dart';
import 'package:private_chat/services/socket_services.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:web_socket_client/web_socket_client.dart';

class CustomTextfield extends ConsumerStatefulWidget {
  const CustomTextfield(
      {super.key, required this.messageController, this.socket});
  final RichTextController messageController;
  final WebSocket? socket;

  @override
  ConsumerState<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends ConsumerState<CustomTextfield> {
  List<XFile> selectedFiles = [];
  FocusNode textFieldFocusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage(ImageSource source) async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 32);
    if (pickedFiles.isNotEmpty) {
      uploadImages(pickedFiles, 'images');
    }
  }

  Future<void> uploadImages(List<XFile> files, String storagePath) async {
    String roomId = ref.watch(roomIdProvider) ?? '-1';
    int userId = ref.watch(userIdProvider);

    await Future.wait(files.map((XFile element) async {
      List<int> imageBytes = await element.readAsBytes();
      MessageModel msg = MessageModel(
          istext: false,
          content: imageBytes,
          sender: userId,
          isOffline: true,
          timestamp: ApiService().formatTimestamp(DateTime.now().toString()));
      ref.read(messageProvider.notifier).addMessage(msg);
      String? img;
      if (kIsWeb) {
        img = await StorageService().uploadImageWeb(
            imageBytes as Uint8List, '$storagePath/$roomId/$userId');
      } else {
        img = await StorageService()
            .uploadImage(File(element.path), '$storagePath/$roomId/$userId');
      }

      if (img != null) {
        SocketService().sendMessage(img, widget.socket, false);
      }
    }));

    setState(() {
      selectedFiles = files;
    });
  }

  bool showPersonTags = false;
  String personTagText(UserModel user) {
    return "${user.name}(${user.phone}) ";
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<UserModel> usrs = ref.watch(usersInRoomProvider);
    return Container(
      width: width * 0.8,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff000000).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FocusScope(
        node: FocusScopeNode(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPersonTags)
              Container(
                constraints:
                    BoxConstraints(maxHeight: usrs.length >= 2 ? 120 : 80),
                padding: const EdgeInsets.fromLTRB(36, 16, 0, 16),
                child: ListView.builder(
                  itemCount: usrs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        String str = personTagText(usrs[index]);
                        widget.messageController.text =
                            widget.messageController.text + str;
                        setState(() {
                          showPersonTags = false;
                        });
                        textFieldFocusNode.requestFocus();
                      },
                      child: MemberElement(
                          name: usrs[index].name, number: usrs[index].phone),
                    );
                  },
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2,
                    bottom: 5,
                  ),
                  child: InkWell(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(36),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    focusNode: textFieldFocusNode,
                    controller: widget.messageController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      focusColor: const Color(0xffFFFFFF),
                    ),
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.2,
                      color: const Color(0xffFFFFFF),
                    ),
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (value) {
                      if (value.endsWith(" @") ||
                          value == "@" ||
                          value.endsWith("\n@")) {
                        setState(() {
                          showPersonTags = true;
                        });
                      } else {
                        setState(() {
                          showPersonTags = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
