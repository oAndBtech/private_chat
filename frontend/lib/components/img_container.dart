import 'dart:typed_data';
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
            ? Image.network(
                url!,
                fit: BoxFit.cover,
              )
            : Image.memory(
                Uint8List.fromList(bytes!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
