// Halaman Register (pakai setState biasa)

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();
  bool hidePassword = true;

  void register() async {
    final username = usernameC.text.trim();
    final password = passwordC.text;

    if (username.isEmpty || password.isEmpty) {
      showMsg('Username dan password wajib diisi', Colors.red);
      return;
    }

    final berhasil = await AuthService.register(username, password);
    if (!mounted) return;
    if (!berhasil) {
      showMsg('Username sudah terdaftar', Colors.red);
      return;
    }

    Get.back(); // kembali ke halaman login
    Get.snackbar(
      'Berhasil',
      'Registrasi berhasil, silakan login',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showMsg(String text, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.person_add, size: 80, color: orange),
              const SizedBox(height: 8),
              const Text(
                'Buat Akun',
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
                  onPressed: register,
                  child: const Text('Daftar'),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
