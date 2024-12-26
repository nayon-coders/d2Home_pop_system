import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:admin_desktop/src/models/models.dart';
import '../constants/storage_keys.dart';

abstract class LocalStorage {
  static SharedPreferences? _preferences;

  LocalStorage._();

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setOtherTranslations(
      {required Map<String, dynamic>? translations,
      required String key}) async {
    SharedPreferences? local = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(translations);
    await local.setString(key, encoded);
  }

  static Future<void> setSystemLanguage(LanguageData? lang) async {
    if (_preferences != null) {
      final String langString = jsonEncode(lang?.toJson());
      await _preferences!.setString(StorageKeys.keySystemLanguage, langString);
    }
  }

  static LanguageData? getSystemLanguage() {
    final lang = _preferences?.getString(StorageKeys.keySystemLanguage);
    if (lang == null) {
      return null;
    }
    final map = jsonDecode(lang);
    if (map == null) {
      return null;
    }
    return LanguageData.fromJson(map);
  }

  static Future<Map<String, dynamic>> getOtherTranslations(
      {required String key}) async {
    SharedPreferences? local = await SharedPreferences.getInstance();

    final String encoded = local.getString(key) ?? '';
    if (encoded.isEmpty) {
      return {};
    }
    final Map<String, dynamic> decoded = jsonDecode(encoded);
    return decoded;
  }

  static LanguageData? getLanguage() {
    final lang = _preferences?.getString(StorageKeys.keyLanguageData);
    if (lang == null) {
      return null;
    }
    final map = jsonDecode(lang);
    if (map == null) {
      return null;
    }
    return LanguageData.fromJson(map);
  }

  static Future<void> setLanguageData(LanguageData? langData) async {
    final String lang = jsonEncode(langData?.toJson());
    setLangLtr(langData?.backward);
    await _preferences?.setString(StorageKeys.keyLanguageData, lang);
  }

  static Future<void> setToken(String? token) async {
    if (_preferences != null) {
      await _preferences!.setString(StorageKeys.keyToken, token ?? '');
    }
  }

  static Future<void> setLangLtr(bool? backward) async {
    if (_preferences != null) {
      await _preferences!.setBool(StorageKeys.keyLangLtr, backward ?? false);
    }
  }

  static bool getLangLtr() =>
      !(_preferences?.getBool(StorageKeys.keyLangLtr) ?? false);

  static String getToken() =>
      _preferences?.getString(StorageKeys.keyToken) ?? '';

  static void deleteToken() => _preferences?.remove(StorageKeys.keyToken);

  static setPinCode(String pinCode) async {
    if (_preferences != null) {
      await _preferences!.setString(StorageKeys.pinCode, pinCode);
    }
  }

  static String getPinCode() =>
      _preferences?.getString(StorageKeys.pinCode) ?? '';

  static void deletePinCode() => _preferences?.remove(StorageKeys.pinCode);

  static Future<void> setSettingsList(List<SettingsData> settings) async {
    if (_preferences != null) {
      final List<String> strings =
          settings.map((setting) => jsonEncode(setting.toJson())).toList();
      await _preferences!
          .setStringList(StorageKeys.keyGlobalSettings, strings);
    }
  }

  static List<SettingsData> getSettingsList() {
    final List<String> settings =
        _preferences?.getStringList(StorageKeys.keyGlobalSettings) ?? [];
    final List<SettingsData> settingsList = settings
        .map(
          (setting) => SettingsData.fromJson(jsonDecode(setting)),
        )
        .toList();
    return settingsList;
  }

  static void deleteSettingsList() =>
      _preferences?.remove(StorageKeys.keyGlobalSettings);

  static Future<void> setActiveLocale(String? locale) async {
    if (_preferences != null) {
      await _preferences!.setString(StorageKeys.keyActiveLocale, locale ?? '');
    }
  }

  // String getActiveLocale() =>
  //     _preferences?.getString(StorageKeys.keyActiveLocale) ?? 'en';

  static void deleteActiveLocale() =>
      _preferences?.remove(StorageKeys.keyActiveLocale);

  static Future<void> setTranslations(
      Map<String, dynamic>? translations) async {
    if (_preferences != null) {
      final String encoded = jsonEncode(translations);
      await _preferences!.setString(StorageKeys.keyTranslations, encoded);
    }
  }

  static Map<String, dynamic> getTranslations() {
    final String encoded =
        _preferences?.getString(StorageKeys.keyTranslations) ?? '';
    if (encoded.isEmpty) {
      return {};
    }
    final Map<String, dynamic> decoded = jsonDecode(encoded);
    return decoded;
  }

  static void deleteTranslations() =>
      _preferences?.remove(StorageKeys.keyTranslations);

  static Future<void> setSelectedCurrency(CurrencyData currency) async {
    if (_preferences != null) {
      final String currencyString = jsonEncode(currency.toJson());
      await _preferences!
          .setString(StorageKeys.keySelectedCurrency, currencyString);
    }
  }

  static CurrencyData getSelectedCurrency() {
    final map = jsonDecode(
        _preferences?.getString(StorageKeys.keySelectedCurrency) ?? '');
    return CurrencyData.fromJson(map);
  }

  static void deleteSelectedCurrency() =>
      _preferences?.remove(StorageKeys.keySelectedCurrency);

  static Future<void> setBags(List<BagData> bags) async {
    if (_preferences != null) {
      final List<String> strings =
          bags.map((bag) => jsonEncode(bag.toJson())).toList();
      await _preferences!.setStringList(StorageKeys.keyBags, strings);
    }
  }

  static List<BagData> getBags() {
    final List<String> bags =
        _preferences?.getStringList(StorageKeys.keyBags) ?? [];
    final List<BagData> localBags = bags
        .map(
          (bag) => BagData.fromJson(jsonDecode(bag)),
        )
        .toList(growable: true);
    return localBags;
  }

  static void deleteCartProducts() =>
      _preferences?.remove(StorageKeys.keyBags);

  static Future<void> setUser(UserData? user) async {
    if (_preferences != null) {
      final String userString = user != null ? jsonEncode(user.toJson()) : '';
      await _preferences!.setString(StorageKeys.keyUser, userString);
    }
  }

  static UserData? getUser() {
    final savedString = _preferences?.getString(StorageKeys.keyUser);
    if (savedString == null) {
      return null;
    }
    final map = jsonDecode(savedString);
    if (map == null) {
      return null;
    }
    return UserData.fromJson(map);
  }

  static void deleteUser() => _preferences?.remove(StorageKeys.keyUser);

  static void clearStore() {
    deletePinCode();
    deleteToken();
    deleteUser();
    deleteCartProducts();
  }
}
