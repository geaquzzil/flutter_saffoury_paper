// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PageStorageBucket appBucket = PageStorageBucket();

class Configurations {
  static const first_run = "first_run";
  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static void saveScrollOffset(
          BuildContext context, double offset, String key) =>
      appBucket.writeState(context, offset, identifier: ValueKey(key));
  static double currentPageScrollOffset(BuildContext context, String key) =>
      appBucket.readState(context, identifier: ValueKey(key)) ?? 0.0;

  static Future<bool> hasSavedValue(Object value) async {
    String? objectHistoryList =
        await getValueString(value.runtimeType.toString());
    debugPrint(
        "Configurations has saved value key :${value.runtimeType.toString()}  value = > $objectHistoryList");
    return objectHistoryList != null;
  }

  static Future<bool?> getValuebool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<String?> getValueString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveQueryHistory(
      ViewAbstract viewAbstract, String? query) async {
    if (query == null) return;
    if (query.isEmpty) return;
    List<String> objectHistory = await loadListQuery(viewAbstract);
    bool isSearchBefore = false;
    for (int i = 0; i < objectHistory.length; i++) {
      if (objectHistory[(i)] == (query)) {
        objectHistory.remove(query);
        objectHistory.insert(0, query);
        isSearchBefore = true;
        break;
      }
    }
    if (!isSearchBefore) {
      objectHistory.insert(0, query);
    }
    _saveListOfQuery(objectHistory, viewAbstract);
  }

  static void _saveListOfQuery(
      List<String> objects, ViewAbstract viewAbstract) {
    save("${viewAbstract.runtimeType}list-query", jsonEncode(objects));
  }

  static Future<void> saveViewAbstract(ViewAbstract value,
      {String? postKey, String? customKey}) async {
    String key = customKey ?? (value.runtimeType.toString()) + (postKey ?? "");
    save(key, jsonEncode(value.toJsonViewAbstract()));
  }

  static Future<void> removeViewAbstract(ViewAbstract value,
      {String? customKey}) async {
    await remove(value.runtimeType.toString() + (customKey ?? ""));
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static void save(String key, dynamic value) async {
    debugPrint("Configrations  save key: $key value:$value");
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is ViewAbstract) {
      key = value.runtimeType.toString() + key;
      debugPrint("Configrations  save value as ViewAbstract key: $key");
      save(key, jsonEncode(value.toJsonViewAbstract()));
    } else {
      debugPrint("Configrations cant ! save value as ViewAbstract");
    }
  }

  static Future<T> getReturnDefaultOnNull<T extends ViewAbstract>(T obj,
      {String? customKey}) async {
    String key = (obj.runtimeType.toString()) + (customKey ?? "");
    String? objectHistoryList = await getValueString(key);
    if (objectHistoryList == null) {
      debugPrint(
          "Configrations  cant get saved value for key =>$key return defaults");
      return obj;
    }

    Map<String, dynamic> map = {};
    map = jsonDecode(objectHistoryList) as Map<String, dynamic>;
    final value = obj.fromJsonViewAbstract(map);
    debugPrint(
        "Configrations getting saved value for key =>$key  value $value");
    return value;
  }

  static Future<T?> get<T extends ViewAbstract>(T obj,
      {String? postKey, String? customKey}) async {
    String key = customKey ?? (obj.runtimeType.toString()) + (postKey ?? "");
    String? objectHistoryList = await getValueString(key);
    if (objectHistoryList == null) {
      debugPrint("Configrations  cant get saved value for key =>$key");
      return null;
    }
    debugPrint("Configrations getting saved value for key =>$key");
    Map<String, dynamic> map = {};
    map = jsonDecode(objectHistoryList) as Map<String, dynamic>;
    return obj.fromJsonViewAbstract(map);
  }

  static Future<List<String>> loadListQuery(ViewAbstract t) async {
    String? objectHistoryList =
        await getValueString("${t.runtimeType}list-query");
    if (objectHistoryList == null) {
      return [];
    } else {
      return (jsonDecode(objectHistoryList) as List<dynamic>).cast<String>();
    }
  }

  //  static <T> T loadMulti( String key, Class<T> tClass) {
  //     String objectHistoryList = getValueString(, key);
  //     if (objectHistoryList == null) return null;
  //     return new Gson().fromJson(objectHistoryList, tClass);
  // }

  //  static void save( Object value) {
  //     save(, value.getClass().getName(), new Gson().toJson(value));
  // }

  //  static void saveMulti( String key, Object value) {
  //     save(, key, new Gson().toJson(value));
  // }

  //  static void saveList( List<?> objects, ViewAbstract<?> viewAbstract) {
  //     save(, viewAbstract.getClass().getName() + "list", new Gson().toJson(objects));
  // }

  //  static void saveHistory( ViewAbstract<?> viewAbstract) {
  //     List<ViewAbstract<?>> objectHistory = loadList(, viewAbstract);
  //     bool isSearchBefore = false;
  //     for (int i = 0; i < objectHistory.size(); i++) {
  //         if (viewAbstract.iD == objectHistory.get(i).iD) {
  //             ViewAbstract<?> object = objectHistory.get(i);
  //             objectHistory.remove(i);
  //             objectHistory.add(0, object);
  //             isSearchBefore = true;
  //             break;
  //         }
  //     }
  //     if (!isSearchBefore) {
  //         viewAbstract.setIsHistory(true);
  //         objectHistory.add(0, viewAbstract);
  //     }
  //     saveList(, objectHistory, viewAbstract);
  //     // save(, viewAbstract()PRODUCT_HIST, ServiceGenerator.Constants.getUploadGSON().toJson(objectHistory, listType));

  // }

  //  static void saveNotification( String objectGson, String objectType) {
  //     List<NotificationHistory> objectHistory = loadNotificationList();

  //     NotificationHistory notificationHistory = new NotificationHistory();
  //     notificationHistory.object = objectGson;
  //     notificationHistory.objectType = objectType;

  //     objectHistory.add(0, notificationHistory);
  //     saveNotificationList(, objectHistory);

  // }

  //  static void saveNotificationList( List<NotificationHistory> objects) {
  //     save(, "notiHistList", new Gson().toJson(objects));
  // }

  //  static List<ViewAbstract<?>> loadList( ViewAbstract<?> t) {
  //     String objectHistoryList = getValueString(, t.getClass().getName() + "list");
  //     if (objectHistoryList == null) {
  //         return new ArrayList<>();

  //     } else {
  //         return new Gson().fromJson(objectHistoryList, Objects.makeGenericList(t.getClass()));
  //     }
  // }

  //  static List<NotificationHistory> loadNotificationList( ) {
  //     String objectHistoryList = getValueString(, "notiHistList");
  //     if (objectHistoryList == null) {
  //         return new ArrayList<>();

  //     } else {
  //         return new Gson().fromJson(objectHistoryList, Objects.makeGenericList(NotificationHistory.class));
  //     }
  // }

  //  static List<ViewAbstract<?>> getHistory( int count, ViewAbstract<?> object) {
  //     List<ViewAbstract<?>> suggestionList = loadList(, object);
  //     for (ViewAbstract<?> p : suggestionList
  //     ) {
  //         p.setIsHistory(true);
  //     }
  //     return suggestionList.subList(0, Math.min(count, suggestionList.size()));
  // }
}
