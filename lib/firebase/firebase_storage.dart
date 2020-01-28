import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// FirebaseStorqageを使用するクラス
class FireStorage {
  Future<String> uploadImage(File file, String userId) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String subDirectoryName = userId;
    final StorageReference ref =
        FirebaseStorage().ref().child(subDirectoryName).child('${timestamp}');

    final StorageUploadTask uploadTask = ref.putFile(
        file,
        StorageMetadata(
          contentType: 'image/jpeg',
        ));
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    } else {
      return 'something goes wrong';
    }
  }
}
