import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracora/app/core/error_handler.dart';

class SettingsController extends GetxController {
  //TODO: Implement SettingsController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> exportDatabase() async {
    String dbName = "db.db";
    final path = await getDatabasesPath();
    final dbPath = join(path, "db.db");
    final tmpDir = await getTemporaryDirectory();
    var tmpPath = tmpDir.path;
    var name = await showFileNameBottomSheet();
    if ((name ?? '').trim().isEmpty) {
      return;
    }
    tmpPath = join(tmpPath, "$name.db");
    var f = File(tmpPath).writeAsBytesSync(File(dbPath).readAsBytesSync());

    await Share.shareXFiles([XFile(tmpPath)], text: 'hello');

    // Share.shareXFiles([XFile(dbPath)], subject: "Here is my database backup.");
  }

  importDatabase() async {
    try {
      var r = await FilePicker.platform.pickFiles();
      if ((r?.paths ?? []).isEmpty) return;
      if (r!.paths.first == null) return;

      var f = File(r.paths.first!);
      var data = f.readAsBytesSync();
      var dir = await getDatabasesPath();
      var path = join(dir, "db.db");
      File(path).writeAsBytesSync(data);
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future<String?> showFileNameBottomSheet() async {
    TextEditingController fileNameController = TextEditingController();

    return await showModalBottomSheet<String>(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "enter_filename".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                autofocus: true,
                controller: fileNameController,
                decoration: InputDecoration(
                  hintText: "${"enter_file_name".tr}...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, fileNameController.text.trim());
                },
                child: Text("save".tr),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
