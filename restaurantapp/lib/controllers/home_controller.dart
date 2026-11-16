// GetX controller untuk halaman list restaurant + filter kategori.

import 'package:get/get.dart';

import '../models/restaurant.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final categories = ['Semua', 'Italia', 'Modern', 'Sunda', 'Jawa', 'Bali'];

  // .obs = variabel reaktif, UI di dalam Obx() otomatis update
  var restaurants = <Restaurant>[].obs;
  var isLoading = false.obs;
  var errorText = ''.obs;
  var selected = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    errorText.value = '';
    try {
      if (selected.value == 'Semua') {
        restaurants.value = await ApiService.getList();
      } else {
        // Filter pakai endpoint search sesuai soal
        // contoh: GET /search?q=Modern
        restaurants.value = await ApiService.search(selected.value);
      }
    } catch (e) {
      errorText.value = 'Gagal memuat data. Cek koneksi internet.';
    } finally {
      isLoading.value = false;
    }
  }

  void pilihKategori(String kategori) {
    if (selected.value == kategori) return;
    selected.value = kategori;
    loadData();
  }
}
