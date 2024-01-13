import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key, this.bytes, this.isUrl = true, this.url})
      : super(key: key);
  final bool isUrl;
  final List<int>? bytes;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(
        maxHeight: 400,
        maxWidth: 350,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: isUrl
            ? CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            :
            Image.memory(
                Uint8List.fromList(bytes!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
