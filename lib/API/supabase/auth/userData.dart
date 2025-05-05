import 'package:flutter/material.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/userAuth/userAuthentication.dart';

String getUserName() =>
    supabaseClient.client.auth.currentUser!.userMetadata!['username'] as String;

Future<String> getUserID() async => supabaseClient.client.auth.currentUser!.id;

void signOut(BuildContext context) {
  logger.w("Signed out user (by user request)");
  supabaseClient.client.auth.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthenticationPage()));
}
