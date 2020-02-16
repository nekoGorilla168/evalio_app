import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// FirebaseStorqageを使用するクラス
class FireStorage {
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://evalio-app-project.appspot.com/');

  // 自分のストレージがあるか確認する
  bool checkMyStorage(String userId) {
    bool isMyStorage = false;
    StorageReference ref = storage.ref().child('$userId/');
    if (ref != null) {
      isMyStorage = true;
    }
    return isMyStorage;
  }

  // ファイルをアップロードするメソッド
  Future<Map<String, String>> uploadImage(File file, String userId) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String imageName = timestamp.toString() + userId;
    String subDirectoryName = userId;
    final StorageReference ref =
        storage.ref().child(subDirectoryName).child(imageName);

    final StorageUploadTask uploadTask = ref.putFile(
        file,
        StorageMetadata(
          contentType: 'image/jpeg',
        ));
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    if (snapshot.error == null) {
      return <String, String>{
        'url': await snapshot.ref.getDownloadURL(),
        'name': imageName,
      };
    } else {}
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

  // 削除するメソッド
  Future<bool> deleteImageFolder(String userId, String imageName) async {
    bool isSuccess = false;
    storage.ref().child('$userId/').child(imageName).delete().then((success) {
      isSuccess = true;
    }).catchError((error) {});
    return isSuccess;
  }
}
