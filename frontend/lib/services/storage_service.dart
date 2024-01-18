import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import "package:universal_html/html.dart" as html;

class StorageService {
  // GlobalKey _globalKey = GlobalKey();

  Future<String?> uploadImage(File file, String path) async {
    try {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('$path-$fileName.jpg');

      await reference.putFile(file);

      String downloadURL = await reference.getDownloadURL();
      print('Image uploaded. Download URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<String?> uploadImageWeb(Uint8List data, String path) async {
    try {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('$path-$fileName.jpg');

      await reference.putData(data);

      String downloadURL = await reference.getDownloadURL();
      print('Image uploaded. Download URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> saveLocalImage(String roomName, Uint8List byteData) async {
    final result = await ImageGallerySaver.saveImage(
        byteData.buffer.asUint8List(),
        quality: 100,
        name: "oandbtech-chat-$roomName-${DateTime.now().toString()}");

    return result["isSuccess"];
  }

  Future<bool> saveNetworkImage(String url, String roomName) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "oandbtech-chat-$roomName-${DateTime.now().toString()}");
    return result["isSuccess"];
  }

  Future<void> saveImageWeb(Uint8List bytes, String fileName) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName;
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }
}
