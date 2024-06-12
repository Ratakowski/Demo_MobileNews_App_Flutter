import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:busidemo31/news_database.dart';
import 'package:busidemo31/user.dart';

class LoginPage extends StatefulWidget {
  final Function(User) onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are denied.");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final user = await NewsDatabase.instance.authenticate(username, password);

    if (user != null) {
      final position = await _getLocation(); // Mendapatkan posisi GPS
      final location = "Lat: ${position.latitude}, Long: ${position.longitude}"; // Format lokasi

      // Perbarui lokasi login pengguna
      await NewsDatabase.instance.updateLoginLocation(user.id!, location);

      widget.onLogin(user); // Berhasil login, callback dengan pengguna yang login
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login gagal. Coba lagi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
