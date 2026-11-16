// ============================================================================
// Halaman Favorit (FavoritePage)
// Sesuai Soal No. 4 pada Modul Responsi:
// 1. Menampilkan daftar restoran yang telah ditambahkan ke favorit dari Database Lokal.
// 2. Tombol hapus: jika diklik, item langsung hilang dari daftar dan menampilkan SnackBar merah.
// 3. Menggunakan GetX (FavoriteController + Obx) untuk update UI otomatis (reaktif).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../widgets/restaurant_card.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses controller favorit yang sudah aktif di GetX
    final favC = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      // Obx: Widget reaktif GetX. 
      // Layar akan otomatis ter-update seketika saat data favorit bertambah atau dihapus
      body: Obx(() {
        // KONDISI 1: Jika daftar favorit masih kosong
        if (favC.favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                SizedBox(height: 8),
                Text('Belum ada restaurant favorit'),
              ],
            ),
          );
        }

        // KONDISI 2: Jika ada item favorit, tampilkan dalam bentuk ListView
        return ListView.builder(
          itemCount: favC.favorites.length,
          itemBuilder: (context, i) {
            final resto = favC.favorites[i];

            return RestaurantCard(
              resto: resto,
              // Navigasi ke halaman detail saat item resto di-klik
              onTap: () => Get.to(() => DetailPage(resto: resto)),
              // Tombol tong sampah di sebelah kanan kartu untuk menghapus dari favorit
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Hapus resto dari database lokal melalui controller
                  favC.remove(resto.id);

                  // Tampilkan notifikasi snackbar merah sesuai instruksi soal
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${resto.name} dihapus dari favorit'),
                        backgroundColor: Colors.red,
                      ),
                    );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
