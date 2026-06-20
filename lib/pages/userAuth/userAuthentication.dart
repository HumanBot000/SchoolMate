import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/auth/userSettings.dart' as settings;
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/home/start.dart';
import 'package:school_mate/pages/settings/setup.dart';

import 'authenticationFlow.dart' as auth_ui;

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  Future<Map<String, dynamic>?>? _userSettingsFuture;

  @override
  void initState() {
    super.initState();
    if (supabaseClient.client.auth.currentSession != null) {
      _userSettingsFuture = settings.getUserSettings();
    }
  }

  void _retryLoadingSettings() {
    setState(() {
      _userSettingsFuture = settings.getUserSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (supabaseClient.client.auth.currentSession == null) {
      return auth_ui.build(context);
    }

    _userSettingsFuture ??= settings.getUserSettings();

    return FutureBuilder<Map<String, dynamic>?>(
      future: _userSettingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          logger.e("Failed to load user settings: ${snapshot.error}");
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    const Text(
                      "Connection Error",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "We couldn't connect to the server to check your settings. Please check your internet connection.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retryLoadingSettings,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final userSettings = snapshot.data;
        if (userSettings == null) {
          logger.i("No settings found. Redirecting to onboarding SetupPage.");
          return SetupPage(
            afterSelectionRoute: MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }

        return const HomePage();
      },
    );
  }
}
