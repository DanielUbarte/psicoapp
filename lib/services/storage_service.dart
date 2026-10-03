import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:psicoapp/models/user.dart';
import 'package:psicoapp/models/emotion_entry.dart';
import 'package:psicoapp/utils/constants.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // --- USER & AUTH PERSISTENCE ---

  Future<bool> saveActiveUser(UserModel user) async {
    return await _prefs!.setString(AppConstants.keyUserSession, user.toJson());
  }

  UserModel? getActiveUser() {
    final String? userJson = _prefs!.getString(AppConstants.keyUserSession);
    if (userJson == null || userJson.isEmpty) return null;
    try {
      return UserModel.fromJson(userJson);
    } catch (_) {
      return null;
    }
  }

  Future<bool> clearActiveUser() async {
    return await _prefs!.remove(AppConstants.keyUserSession);
  }

  Future<List<UserModel>> getUsersList() async {
    final String? usersJson = _prefs!.getString(AppConstants.keyUsersList);
    if (usersJson == null || usersJson.isEmpty) return [];
    try {
      final List<dynamic> decoded = json.decode(usersJson);
      return decoded.map((item) => UserModel.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveUserToList(UserModel user) async {
    final users = await getUsersList();
    // remove duplicate if existing
    users.removeWhere((u) => u.email.toLowerCase() == user.email.toLowerCase());
    users.add(user);
    final String jsonString =
        json.encode(users.map((u) => u.toMap()).toList());
    return await _prefs!.setString(AppConstants.keyUsersList, jsonString);
  }

  // --- EMOTION & JOURNAL ENTRIES ---

  Future<bool> saveEmotionEntry(EmotionEntry entry) async {
    final entries = await getEmotionEntries(entry.userId);
    entries.insert(0, entry); // latest first
    final jsonString = json.encode(entries.map((e) => e.toMap()).toList());
    return await _prefs!.setString(
        '${AppConstants.keyEmotionEntries}_${entry.userId}', jsonString);
  }

  Future<List<EmotionEntry>> getEmotionEntries(String userId) async {
    final String? jsonStr =
        _prefs!.getString('${AppConstants.keyEmotionEntries}_$userId');
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonStr);
      return decoded.map((item) => EmotionEntry.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> deleteEmotionEntry(String userId, String entryId) async {
    final entries = await getEmotionEntries(userId);
    entries.removeWhere((e) => e.id == entryId);
    final jsonString = json.encode(entries.map((e) => e.toMap()).toList());
    return await _prefs!.setString(
        '${AppConstants.keyEmotionEntries}_$userId', jsonString);
  }

  // --- CHALLENGES PROGRESS ---

  Future<bool> saveChallengeProgress(
      String userId, String challengeId, List<Map<String, dynamic>> progressData) async {
    final String jsonStr = json.encode(progressData);
    return await _prefs!
        .setString('${AppConstants.keyChallengeProgress}_${userId}_$challengeId', jsonStr);
  }

  Future<List<dynamic>?> getChallengeProgress(
      String userId, String challengeId) async {
    final String? jsonStr = _prefs!
        .getString('${AppConstants.keyChallengeProgress}_${userId}_$challengeId');
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return json.decode(jsonStr);
    } catch (_) {
      return null;
    }
  }

  // --- DELETE ALL USER DATA ---

  Future<bool> deleteUserData(String userId) async {
    await _prefs!.remove('${AppConstants.keyEmotionEntries}_$userId');
    await _prefs!.remove('${AppConstants.keyChallengeProgress}_${userId}_autoestima_7d');
    final users = await getUsersList();
    users.removeWhere((u) => u.id == userId);
    await _prefs!.setString(
        AppConstants.keyUsersList, json.encode(users.map((u) => u.toMap()).toList()));
    return await clearActiveUser();
  }
}
