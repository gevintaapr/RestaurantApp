// Login & Register sederhana pakai Shared Preferences.
//
// Yang disimpan:
//   'user_<username>' -> password      (akun hasil register)
//   'username'        -> username login (sesi, supaya tetap login)

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Register: false kalau username sudah dipakai
  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_$username')) return false;

    await prefs.setString('user_$username', password);
    return true;
  }

  // Login: cek password, kalau cocok simpan sesi
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('user_$username');
    if (savedPassword == null || savedPassword != password) return false;

    await prefs.setString('username', username);
    return true;
  }

  // Ambil username yang sedang login (null = belum login)
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }
}
