import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appchat318/api/firebase_api.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Chat with ChangeNotifier {
  ImagePicker imagePicker;
  File file;

  void sendMessage(String mess, {String fileName = "", String idRoom}) {
    FirebaseFirestore.instance.collection(idRoom).add({
      "message": mess,
      "fileName": fileName,
      "date": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<String> checkIdRoom(String user1, String user2) async {
    String idRoom;
    await FirebaseFirestore.instance
        .collection("$user1-$user2")
        .get()
        .then((doc) async {
      if (doc.size > 0) {
        idRoom = "$user1-$user2";
      } else {
        await FirebaseFirestore.instance
            .collection("$user2-$user1")
            .get()
            .then((doc) {
          if (doc.size > 0) {
            idRoom = "$user2-$user1";
          } else {
            idRoom = "";
          }
        });
      }
    });
    // print("id");
    // print(idRoom);
    return idRoom;
  }

  void createRoomChat(String idRoom) {
    FirebaseFirestore.instance.collection(idRoom).add({
      "message": "Wellcome",
      "fileName": "",
      "date": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> selectFile(String idRoom) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }

    print("-----------------");
    print(file);
    print(result.files.toString());
    uploadFile(idRoom);
  }

  Future uploadFile(String idRoom) async {
    if (file == null) return;

    final fileName = file.path;
    final destination = 'files/$fileName';

    var task = FirebaseApi.uploadFile(destination, file);

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    sendMessage(urlDownload,
        fileName: file
            .toString()
            .replaceAll(
                "/data/user/0/com.example.flutter_appchat318/cache/file_picker/",
                "")
            .replaceAll("File:", "")
            .replaceAll("'", "")
            .trim(),
        idRoom: idRoom);
  }

  Future<void> dowloadItems(String urlDownload, String fileName) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      print("tooo--------");
      print(urlDownload);
      await FlutterDownloader.enqueue(
        url: urlDownload,
        savedDir: externalDir.path,
        openFileFromNotification: true,
        showNotification: true,
        fileName: fileName,
      );
    } else {
      print("Permission deined");
    }
  }
}
