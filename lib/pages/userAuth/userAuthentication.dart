import 'package:flutter/material.dart';

import '../../main.dart';
import '../home/HomePage.dart';
import 'authenticate.dart' as auth_ui;

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});
  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return supabaseClient.client.auth.currentSession == null
        ? auth_ui.build(context)
        : const HomePage();
  }
}
