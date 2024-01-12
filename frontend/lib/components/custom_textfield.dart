import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/providers/message_provider.dart';

class CustomTextfield extends ConsumerStatefulWidget {
  const CustomTextfield({
    super.key,
    required this.messageController,
  });
  final TextEditingController messageController;

  @override
  ConsumerState<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends ConsumerState<CustomTextfield> {
  List<XFile> selectedFiles = [];

  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage(ImageSource source) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      List<MessageModel> msgs = [];
      for (XFile element in pickedFiles) {
        List<int> imageBytes = await element.readAsBytes();
        MessageModel msg =
            MessageModel(istext: false, content: imageBytes, sender: 1);
        msgs.add(msg);
      }

      ref.read(messageProvider.notifier).addAllMessages(msgs);

      setState(() {
        selectedFiles = pickedFiles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.8,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff000000).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
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
              maxLines: 6,
            ),
          ),
        ],
      ),
    );
  }
}
