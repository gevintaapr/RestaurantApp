// GetX controller untuk favorit.
// Dipakai di halaman Detail (tombol hati) dan halaman Favorit (list).
// Datanya disimpan ke local database (Hive) lewat FavoriteDb.

import 'package:get/get.dart';

import '../models/restaurant.dart';
import '../services/favorite_db.dart';

class FavoriteController extends GetxController {
  var favorites = <Restaurant>[].obs;

  @override
  void onInit() {
    super.onInit();
    favorites.value = FavoriteDb.getAll();
  }

  bool isFavorite(String id) => favorites.any((r) => r.id == id);

  // List di layar diubah dulu (langsung terlihat), lalu disimpan ke database
  void add(Restaurant resto) {
    favorites.add(resto);
    FavoriteDb.add(resto);
  }

  void remove(String id) {
    favorites.removeWhere((r) => r.id == id);
    FavoriteDb.remove(id);
  }
}
