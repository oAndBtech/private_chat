import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key, required this.bytes}) : super(key: key);

  final List<int> bytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      // height: 350.0, 
      constraints: BoxConstraints(
        maxHeight: 100,
        maxWidth: 100,
        minWidth: 10,
      ),
      
      color: Colors.amber,
      // child: Image.memory(
      //   Uint8List.fromList(bytes),
      //   fit: BoxFit.cover,
      // ),
    );
  }
}
