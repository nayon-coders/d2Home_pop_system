import 'package:admin_desktop/src/presentation/pages/main/getx_controller/bag_controller.dart';
import 'package:admin_desktop/src/presentation/pages/printer_manage/controller/printer_controller.dart';
import 'package:admin_desktop/src/presentation/theme/theme_controller_getx.dart';
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
import 'package:permission_handler/permission_handler.dart';

import 'src/presentation/pages/main/widgets/order_calculate/calculator_controller.dart';

late  SharedPreferences sharedPreferences;


Future<void> requestBluetoothPermission() async {
  if (Platform.isAndroid && await Permission.bluetoothConnect.isDenied) {
    await Permission.bluetoothConnect.request();
  }
}
void main() async {
  setUpDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  requestBluetoothPermission();
  if(Platform.isAndroid || Platform.isIOS){

    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Get.put(ChangeColorController());
  Get.put(PrinterController());
  Get.put(BagController());
  Get.put(PaymentCalculatorController());

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
  runApp(const ProviderScope(child:AppWidget()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
