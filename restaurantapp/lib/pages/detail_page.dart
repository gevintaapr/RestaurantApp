// ============================================================================
// Halaman Detail Restaurant
// Fitur:
// 1. Mengambil data lengkap resto dari API menggunakan FutureBuilder.
// 2. Tombol Favorit (tambah/hapus) dengan GetX (FavoriteController).
// 3. Menampilkan indikator SnackBar hijau (tambah) dan merah (hapus) sesuai soal.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../main.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class DetailPage extends StatefulWidget {
  // Menerima data dasar restoran yang dikirim saat card resto di-klik dari halaman list
  final Restaurant resto;
  const DetailPage({super.key, required this.resto});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Mengambil instance FavoriteController yang sudah didaftarkan di GetX
  final favC = Get.find<FavoriteController>();

  // Variabel untuk menampung hasil pemanggilan data API Detail
  late Future<Restaurant> futureDetail;

  @override
  void initState() {
    super.initState();
    // Memanggil API detail restaurant berdasarkan ID resto saat halaman pertama kali dibuka.
    // Ditaruh di initState agar tidak terpanggil berulang kali saat layar me-rebuild.
    futureDetail = ApiService.getDetail(widget.resto.id);
  }

  // Fungsi toggle untuk menambah atau menghapus resto dari daftar favorit
  void toggleFavorite() {
    final resto = widget.resto;

    // Jika resto sudah ada di favorit -> Hapus dan tampilkan snackbar merah
    if (favC.isFavorite(resto.id)) {
      favC.remove(resto.id);
      showMsg('${resto.name} dihapus dari favorit', Colors.red);
    } 
    // Jika resto belum ada di favorit -> Tambahkan dan tampilkan snackbar hijau
    else {
      favC.add(resto);
      showMsg('${resto.name} ditambahkan ke favorit', Colors.green);
    }
  }

  // Fungsi pembantu (helper) untuk memunculkan notifikasi SnackBar di bawah layar
  void showMsg(String text, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // Menyembunyikan snackbar sebelumnya jika masih muncul
      ..showSnackBar(SnackBar(content: Text(text), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resto.name),
        actions: [
          // Obx: Widget reaktif dari GetX. 
          // Icon hati akan otomatis berubah warna secara real-time saat status favorit berubah
          Obx(() {
            final isFav = favC.isFavorite(widget.resto.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.white,
              ),
              onPressed: toggleFavorite,
            );
          }),
        ],
      ),
      // FutureBuilder: Menangani status pemanggilan API secara asinkron
      body: FutureBuilder<Restaurant>(
        future: futureDetail,
        builder: (context, snapshot) {
          // 1. Kondisi saat masih proses download/loading dari API
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Kondisi jika terjadi error (misal: koneksi internet mati)
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat detail'),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      // Trigger ulang pemanggilan API jika tombol coba lagi ditekan
                      futureDetail = ApiService.getDetail(widget.resto.id);
                    }),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // 3. Kondisi jika data berhasil didapat: tampilkan UI detail
          return buildDetail(snapshot.data!);
        },
      ),
    );
  }

  // Widget untuk merender seluruh konten detail resto (Gambar, Nama, Alamat, Menu, Review)
  Widget buildDetail(Restaurant r) {
    return ListView(
      children: [
        // Gambar Utama dengan animasi Hero Transition dari halaman list
        Hero(
          tag: r.id,
          child: Image.network(
            r.imageUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            // Jika gambar gagal dimuat, tampilkan ikon placeholder abu-abu
            errorBuilder: (context, error, stack) => Container(
              height: 220,
              color: Colors.grey.shade300,
              child: const Icon(Icons.broken_image, size: 60),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian: Nama Restoran & Badge Rating Bintang
              Row(
                children: [
                  Expanded(
                    child: Text(
                      r.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.white),
                        Text(
                          ' ${r.rating}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Bagian: Alamat & Kota Restoran
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${r.address}, ${r.city}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              // Bagian: Kategori Restoran (misal: Modern, Italia)
              judul('Kategori'),
              chipList(r.categories, Colors.white),

              // Bagian: Deskripsi Lengkap
              judul('Deskripsi'),
              Text(r.description, textAlign: TextAlign.justify),

              // Bagian: Daftar Makanan
              judul('Menu Makanan'),
              chipList(r.foods, Colors.orange.shade100),

              // Bagian: Daftar Minuman
              judul('Menu Minuman'),
              chipList(r.drinks, Colors.blue.shade50),

              // Bagian: Customer Reviews (Ulasan Pelanggan)
              judul('Customer Reviews (${r.reviews.length})'),
              ...r.reviews.map(
                (rev) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      // Ambil inisial huruf depan dari nama reviewer
                      child: Text(
                        rev.name.isEmpty ? '?' : rev.name[0].toUpperCase(),
                      ),
                    ),
                    title: Text(rev.name),
                    subtitle: Text('${rev.review}\n${rev.date}'),
                    isThreeLine: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget helper untuk membuat teks judul section yang seragam
  Widget judul(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget helper untuk menampilkan daftar teks sebagai Chip berderet rapi ke samping/bawah
  Widget chipList(List<String> items, Color color) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: items
          .map((e) => Chip(label: Text(e), backgroundColor: color))
          .toList(),
    );
  }
}
