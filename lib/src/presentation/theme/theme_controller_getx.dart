import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeColorController extends GetxController {
  static ChangeColorController get to => Get.find();

  static const _prefKey = 'selected_color';

  final Rx<Color> _selectedColor = Colors.blue.obs;

  Color get selectedColor => _selectedColor.value;

  set selectedColor(Color color) {
    _selectedColor.value = color;
    _saveColorToPrefs(color);
  }

  @override
  void onInit() {
    super.onInit();
    _loadColorFromPrefs();
  }

  Future<void> _saveColorToPrefs(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_prefKey, color.value);
  }

  Future<void> _loadColorFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_prefKey);
    if (colorValue != null) {
      _selectedColor.value = Color(colorValue);
    }
  }
}
