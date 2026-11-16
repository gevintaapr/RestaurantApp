// Card restaurant: gambar, nama, kota, rating.
// Dipakai di halaman Home dan Favorit.

import 'package:flutter/material.dart';

import '../main.dart';
import '../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant resto;
  final VoidCallback onTap;
  final Widget? trailing; // contoh: tombol hapus di halaman favorit

  const RestaurantCard({
    super.key,
    required this.resto,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Hero = animasi gambar saat pindah ke halaman detail
              Hero(
                tag: resto.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    resto.imageUrl,
                    width: 100,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      width: 100,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resto.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        Text(
                          resto.city,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: orange),
                        Text(' ${resto.rating}'),
                      ],
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
