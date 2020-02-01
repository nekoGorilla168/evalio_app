import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// FirebaseStorqageを使用するクラス
class FireStorage {
  // 自分のストレージがあるか確認する
  bool checkMyStorage(String userId) {
    bool isMyStorage = false;
    StorageReference ref = FirebaseStorage().ref().child(userId);
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
    StorageReference deleteRef = FirebaseStorage().ref().child(userId);
    // 削除処理実行
    deleteRef.delete().then((value) {
      isSuccess = true;
    }).catchError((error) {
      isSuccess = false;
    });
    return isSuccess;
  }
}
