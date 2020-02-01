import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// FirebaseStorqageを使用するクラス
class FireStorage {
  // 自分のストレージがあるか確認する
  bool checkMyStorage(String userId) {
    bool isMyStorage = false;
    StorageReference ref = FirebaseStorage().ref().child('$userId/');
    if (ref != null) {
      isMyStorage = true;
    }
    return isMyStorage;
  }

  // ファイルをアップロードするメソッド
  Future<String> uploadImage(File file, String userId) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String subDirectoryName = userId;
    final StorageReference ref =
        FirebaseStorage().ref().child(subDirectoryName).child('$timestamp');

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

  // ファイルを削除するメソッド
  // ignore: missing_return
  Future<bool> deleteImage(String userId) async {
    bool isSuccess = false;
    StorageReference deleteRef = await FirebaseStorage.instance.getReferenceFromUrl(
        'https://firebasestorage.googleapis.com/v0/b/evalio-app-project.appspot.com/o/3M0XiM0wJ7WzfwtqcPHpAXSG5J92%2F1580391137520?alt=media&token=6dc5f64b-3d9e-4fbb-8611-8cd5f9684d0a');
    // 削除処理実行
    if (deleteRef != null) deleteRef.delete();

    return isSuccess;
  }
}
