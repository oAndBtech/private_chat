import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, this.bytes, this.isUrl = true, this.url});
  final bool isUrl;
  final List<int>? bytes;
  final String? url;

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                    child: isUrl
                ? CachedNetworkImage(
                    imageUrl: url!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                : Image.memory(
                    Uint8List.fromList(bytes!),
                    fit: BoxFit.cover,
                  ),
                  ),
            ),
          )),
    );
  }
}
