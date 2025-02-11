import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/auth/userSettings.dart' as settings;
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/home/start.dart';
import 'package:school_mate/pages/settings/setup.dart';

import 'authenticationFlow.dart' as auth_ui;

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return supabaseClient.client.auth.currentSession == null
        ? auth_ui.build(context)
        : FutureBuilder(
            future: settings.getUserSettings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.data == null) {
                return const SetupPage();
              } else if (snapshot.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Something went wrong. Please try again. ${snapshot.error}"),
                  ),
                );
                logger.e(snapshot.error);
              }
              return const HomePage();
            });
  }
}
