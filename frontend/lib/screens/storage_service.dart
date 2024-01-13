import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
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
}
