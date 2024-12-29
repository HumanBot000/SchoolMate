import 'dart:async';

import 'package:flutter/material.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/home/start.dart';
import 'package:school_mate/pages/userAuth/emailVerification.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void _errorHandler(Object response, BuildContext context) {
  if (response is AuthException && response.statusCode.toString() == "422") {
    logger.w("Account already exists");
    showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                "There is already an registered account with that email. \nPlease try to login instead.",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              actions: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.errorContainer,
                  )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"),
                )
              ],
            ));
  } else if (response is AuthException &&
      response.code.toString() == "invalid_credentials") {
    logger.w("Invalid credentials");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Invalid credentials\nPlease try again"),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  } else {
    logger.e(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.toString()),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

Future<void> _signUpHandler(Object response, BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Sign up successful. Please check your email."),
    ),
  );
  if (response is AuthResponse) {
    logger.i("Signed up user");
    final username = response.user?.appMetadata['username'] as String?;
    await prefs.setString('pending_username',
        username.toString()); //Can only update after email verification
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return EmailVerificationPage(email: response.user!.email!);
    }));
  }
}

Future<void> _signInHandler(Object response, BuildContext context) async {
  if (response is AuthResponse) {
    logger.i("Signed in user");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const HomePage(),
    ));
  } else {
    logger.e(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.toString()),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

Scaffold build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Welcome to SchoolMate",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    ),
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SupaEmailAuth(
                  //todo password reset flow
                  onSignInComplete: (response) async {
                    await _signInHandler(
                      response,
                      context,
                    );
                  },
                  onSignUpComplete: (response) async {
                    await _signUpHandler(
                      response,
                      context,
                    );
                  },
                  onError: (response) {
                    _errorHandler(response, context);
                  },
                  metadataFields: [
                    MetaDataField(
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      label: 'Username',
                      key: 'username',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter something';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
