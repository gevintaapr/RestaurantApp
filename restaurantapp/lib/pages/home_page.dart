// Halaman List Restaurant (pakai GetX: HomeController + Obx)

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../widgets/restaurant_card.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // Get.put = buat controller dan simpan supaya bisa dipakai di bawah
    final c = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, $username!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorit',
            onPressed: () => Get.to(() => const FavoritePage()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await AuthService.logout();
              Get.delete<HomeController>();
              Get.offAll(() => const LoginPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------- Filter kategori ----------
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: c.categories.map((kategori) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Obx(() {
                    final aktif = c.selected.value == kategori;
                    return ChoiceChip(
                      label: Text(kategori),
                      selected: aktif,
                      selectedColor: orange,
                      labelStyle: TextStyle(
                        color: aktif ? Colors.white : Colors.black87,
                      ),
                      checkmarkColor: Colors.white,
                      onSelected: (_) => c.pilihKategori(kategori),
                    );
                  }),
                );
              }).toList(),
            ),
          ),

          // ---------- List restaurant ----------
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (c.errorText.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(c.errorText.value),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: c.loadData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              if (c.restaurants.isEmpty) {
                return const Center(child: Text('Restaurant tidak ditemukan'));
              }

              return RefreshIndicator(
                onRefresh: c.loadData,
                child: ListView.builder(
                  itemCount: c.restaurants.length,
                  itemBuilder: (context, i) {
                    final resto = c.restaurants[i];
                    return RestaurantCard(
                      resto: resto,
                      onTap: () => Get.to(() => DetailPage(resto: resto)),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: orange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restoran',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
        ],
        onTap: (index) {
          if (index == 1) {
            Get.to(() => const FavoritePage());
          }
        },
      ),
    );
  }
}
