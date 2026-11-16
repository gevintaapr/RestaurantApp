// Halaman Login (pakai setState biasa, tanpa GetX controller)

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();
  bool hidePassword = true;

  void login() async {
    final username = usernameC.text.trim();
    final password = passwordC.text;

    if (username.isEmpty || password.isEmpty) {
      showMsg('Username dan password wajib diisi', Colors.red);
      return;
    }

    final berhasil = await AuthService.login(username, password);
    if (!mounted) return;
    if (!berhasil) {
      showMsg('Username atau password salah', Colors.red);
      return;
    }

    // offAll = hapus halaman login dari riwayat, jadi tidak bisa back
    Get.offAll(() => HomePage(username: username));
  }

  void showMsg(String text, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.restaurant, size: 80, color: orange),
              const SizedBox(height: 8),
              const Text(
                'Restaurant App',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: usernameC,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordC,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: login,
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () => Get.to(() => const RegisterPage()),
                child: const Text('Belum punya akun? Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
