import 'package:app/pages/home/start.dart';
import 'package:app/pages/settings/setup.dart';
import 'package:app/supabase/userSettings.dart' as settings;
import 'package:flutter/material.dart';

import '../../main.dart';
import 'authenticate.dart' as auth_ui;

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
