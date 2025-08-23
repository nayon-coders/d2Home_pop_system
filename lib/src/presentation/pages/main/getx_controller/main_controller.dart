import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends GetxController{

  onInit(){
    super.onInit();
    _loadPrefs();
  }

  RxBool isGridView = true.obs;
  RxBool isListView = false.obs;
  RxBool isShowImage = true.obs;


  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
      isGridView.value = prefs.getBool('isGridView') ?? false;
      isListView.value = prefs.getBool('isListView') ?? false;
      isShowImage.value = prefs.getBool('showImage') ?? false;
  }

  Future<void> savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGridView', isGridView.value);
    await prefs.setBool('isListView', isListView.value);
    await prefs.setBool('showImage', isShowImage.value);
    Get.back();
  }



}