// flutter pub add get http shared_preferences hive hive_flutter

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/favorite_controller.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/auth_service.dart';
import 'services/favorite_db.dart';

const orange = Color(0xFFFF9800);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Buka local database (Hive) untuk favorit
  await FavoriteDb.init();

  // 2. Controller favorit dipakai di banyak halaman, jadi didaftarkan global
  Get.put(FavoriteController());

  // 3. Cek sesi login dari Shared Preferences
  final username = await AuthService.getUsername();

  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  final String? username;
  const MyApp({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: orange),
        appBarTheme: const AppBarTheme(
          backgroundColor: orange,
          foregroundColor: Colors.white,
        ),
      ),
      // Sudah login -> langsung ke Home, belum -> Login
      home: username == null
          ? const LoginPage()
          : HomePage(username: username!),
    );
  }
}
