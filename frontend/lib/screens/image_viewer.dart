// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewer extends ConsumerWidget {
  const ImageViewer({super.key, this.bytes, this.isUrl = true, this.url});
  final bool isUrl;
  final List<int>? bytes;
  final String? url;

  Future<void> downloadImage(String roomName, BuildContext context) async {
    if (kIsWeb) {
      if (isUrl) {
        await launchUrl(Uri.parse(url!), mode: LaunchMode.inAppWebView);
      } else {
        await StorageService().saveImageWeb(bytes as Uint8List,
            "oandbtech-chat-$roomName-${DateTime.now()}.jpg");
      }
      return;
    }

    if (isUrl) {
      bool res = await StorageService().saveNetworkImage(url!, roomName);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(
          child: Text("Image Successfully Saved!"),
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(
          child: Text("Something went wrong!"),
        )));
      }
    } else {
      bool res =
          await StorageService().saveLocalImage(roomName, bytes as Uint8List);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(
          child: Text("Image Successfully Saved!"),
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(
          child: Text("Something went wrong!"),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String roomName = ref.watch(roomProvider)!.roomName ?? 'room';

    return Scaffold(
      backgroundColor: const Color(0xff282C34),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0.0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Color(0xff282C34)),
      ),
      body: SafeArea(
          child: Center(
        child: Hero(
          tag: "img_${url ?? bytes.hashCode}",
          child: Stack(
            children: [
              Container(
                  child: isUrl
                      ? PhotoView(
                          imageProvider: CachedNetworkImageProvider(url!),
                        )
                      : PhotoView(
                          imageProvider:
                              MemoryImage(Uint8List.fromList(bytes!)),
                        )),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      color: Colors.white,
                      iconSize: 36,
                    ),
                    IconButton(
                      onPressed: () async {
                        await downloadImage(roomName, context);
                      },
                      icon: const Icon(Icons.download_rounded),
                      color: Colors.white,
                      iconSize: 36,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
