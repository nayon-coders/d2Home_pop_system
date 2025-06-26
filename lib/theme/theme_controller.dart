// theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  static const _prefKey = 'theme_mode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }
  void toggleTheme() {
    print('Toggling theme...');
    if (themeMode.value == ThemeMode.light) {
      print('Switching to Dark');
      themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
      _saveThemeToPrefs('dark');
    } else {
      print('Switching to Light');
      themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
      _saveThemeToPrefs('light');
    }
    update(); // 🔥 Forces GetBuilder to rebuild the app
  }




  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_prefKey) ?? 'light';

    if (themeStr == 'dark') {
      themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  Future<void> _saveThemeToPrefs(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, mode);
  }
}
