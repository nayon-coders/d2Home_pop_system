import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeColorController extends GetxController {
  static ChangeColorController get to => Get.find();


   int pageBackground = 0;
   int productBackground = 1;
   int buttonColor = 2;
   int categoryColor = 3;
   int secondaryColor = 4;


  RxList<String> colorsListString = <String>[
    "Page Background",
    "Product Background",
    "Button Color",
    "Category Color",
    "Text Color"
  ].obs;

  RxList<bool> colorsListBool = <bool>[
    true, false, false, false, false,
  ].obs;

  RxList<Color> selectedColors = <Color>[
    Color(0xffFFE080),
    Color(0xffF57900),
    Color(0xffE65000),
    Color(0xffFFE080),
    Color(0xff000000),
  ].obs;

  final String _colorKeyPrefix = 'custom_color_';

  @override
  void onInit() {
    super.onInit();
    getAllPresets();
    _loadAllColorsFromPrefs();

  }

   setColorAtIndex(int index, Color color) {
    if (index >= 0 && index < selectedColors.length) {
      selectedColors[index] = color;
      _saveColorToPrefs(index, color);
    }
  }

  void _saveColorToPrefs(int index, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_colorKeyPrefix$index', color.value);
    _loadAllColorsFromPrefs();
  }

  Future<void> _loadAllColorsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < colorsListString.length; i++) {
      final savedColorValue = prefs.getInt('$_colorKeyPrefix$i');
      if (savedColorValue != null) {
        selectedColors[i] = Color(savedColorValue);
        print("print color  ${selectedColors[i]}");
      }
    }
  }

  void selectOnlyIndex(int index) {
    for (int i = 0; i < colorsListBool.length; i++) {
      colorsListBool[i] = (i == index);
    }
  }

  final String _presetsKey = 'color_presets';

  /// Save current selectedColors as a new preset
  Future<void> saveCurrentAsPreset(String presetName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingJson = prefs.getString(_presetsKey);
    Map<String, List<int>> presets = {};

    if (existingJson != null) {
      presets = Map<String, dynamic>.from(jsonDecode(existingJson))
          .map((key, value) => MapEntry(key, List<int>.from(value)));
    }

    // Save current selectedColors
    presets[presetName] = selectedColors.map((e) => e.value).toList();
    await prefs.setString(_presetsKey, jsonEncode(presets));
    getAllPresets();
    print("saved");
    Get.snackbar("Saved!", "Your preset color is saved", backgroundColor: Colors.green, colorText: Colors.white);
  }

  /// Load all saved presets
  Future<Map<String, List<Color>>> getAllPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingJson = prefs.getString(_presetsKey);
    Map<String, List<Color>> result = {};

    if (existingJson != null) {
      Map<String, dynamic> presets = jsonDecode(existingJson);
      presets.forEach((key, value) {
        List<Color> colors = List<int>.from(value).map((v) => Color(v)).toList();
        result[key] = colors;
      });
    }

    return result;
  }

  /// Delete a preset
  Future<void> deletePreset(String presetName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingJson = prefs.getString(_presetsKey);
    if (existingJson == null) return;

    Map<String, dynamic> presets = jsonDecode(existingJson);
    presets.remove(presetName);
    getAllPresets();
    await prefs.setString(_presetsKey, jsonEncode(presets));
    Get.snackbar("Delete!", "Delete your preset.", backgroundColor: Colors.red);
  }

  /// Load a preset and apply it to selectedColors
  Future<void> applyPreset(String presetName) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingJson = prefs.getString(_presetsKey);

    if (existingJson == null) return;
    Map<String, dynamic> presets = jsonDecode(existingJson);
    if (!presets.containsKey(presetName)) return;

    List<Color> presetColors = List<int>.from(presets[presetName])
        .map((v) => Color(v))
        .toList();

    for (int i = 0; i < selectedColors.length; i++) {
      if (i < presetColors.length) {
        selectedColors[i] = presetColors[i];
        _saveColorToPrefs(i, presetColors[i]); // Optional: save to prefs
      }
    }
  }


}
