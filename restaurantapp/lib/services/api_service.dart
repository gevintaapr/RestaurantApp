// Semua request ke API ada di sini.
// Dokumentasi: https://restaurant-api.dicoding.dev/#/

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/restaurant.dart';

class ApiService {
  static const baseUrl = 'https://restaurant-api.dicoding.dev';

  // GET /list -> semua restaurant
  static Future<List<Restaurant>> getList() async {
    final res = await http.get(Uri.parse('$baseUrl/list'));
    if (res.statusCode != 200) throw Exception('Gagal memuat data');

    final data = jsonDecode(res.body);
    final List list = data['restaurants'];
    return list.map((e) => Restaurant.fromJson(e)).toList();
  }

  // GET /search?q=... -> dipakai untuk filter kategori
  static Future<List<Restaurant>> search(String query) async {
    final url = Uri.parse(
      '$baseUrl/search?q=${Uri.encodeQueryComponent(query)}',
    );
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Gagal mencari data');

    final data = jsonDecode(res.body);
    final List list = data['restaurants'];
    return list.map((e) => Restaurant.fromJson(e)).toList();
  }

  // GET /detail/{id} -> detail satu restaurant
  static Future<Restaurant> getDetail(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/detail/$id'));
    if (res.statusCode != 200) throw Exception('Gagal memuat detail');

    final data = jsonDecode(res.body);
    return Restaurant.fromJson(data['restaurant']);
  }
}
