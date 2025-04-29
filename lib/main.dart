import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app_widget.dart';
import 'src/core/di/dependency_manager.dart';
import 'src/core/utils/utils.dart';
import 'dart:io' show Platform;

void main() async {
  setUpDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid || Platform.isIOS){
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
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
  runApp(const ProviderScope(child: AppWidget()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}