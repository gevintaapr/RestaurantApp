// Local database untuk favorit pakai Hive.
// Hive jalan di Android, iOS, dan Chrome (IndexedDB).
// Key = id restaurant, value = Map data restaurant.

import 'package:hive_flutter/hive_flutter.dart';

import '../models/restaurant.dart';

class FavoriteDb {
  static const boxName = 'favorites';

  static Box get box => Hive.box(boxName);

  // Dipanggil sekali di main()
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static List<Restaurant> getAll() {
    return box.values
        .map((e) => Restaurant.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> add(Restaurant resto) async {
    await box.put(resto.id, resto.toJson());
  }

  static Future<void> remove(String id) async {
    await box.delete(id);
  }

  static bool isFavorite(String id) => box.containsKey(id);
}
