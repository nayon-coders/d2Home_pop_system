import 'package:admin_desktop/src/presentation/pages/printer_manage/controller/printer_controller.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app_widget.dart';
import 'src/core/di/dependency_manager.dart';
import 'src/core/utils/utils.dart';
import 'dart:io' show Platform;

late  SharedPreferences sharedPreferences;
void main() async {
  setUpDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  if(Platform.isAndroid || Platform.isIOS){
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Get.put(PrinterController());
  // if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
  //   doWhenWindowReady(() {
  //     const initialSize = Size(1280, 720);
  //     const minSize = Size(1024, 576);
  //     const maxSize = Size(1280, 720);
  //     appWindow.maxSize = maxSize;
  //     appWindow.minSize = minSize;
  //     appWindow.size = initialSize; //default size
  //     appWindow.show();
  //   });
  // }

  await LocalStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  runApp(const ProviderScope(child: GetMaterialApp(debugShowCheckedModeBanner: false, home: AppWidget())));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}