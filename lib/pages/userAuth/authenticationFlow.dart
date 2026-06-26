import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:school_mate/API/supabase/auth/userSettings.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

// Configurable client IDs for Google Sign-In (replace with your actual client IDs from Google Cloud Console)
const String googleWebClientId =
    '318847705955-vtq1mnok1o0nbq126hj19hmbr31kh0rh.apps.googleusercontent.com';
const String googleIosClientId =
    '318847705955-dtojdt33njfd47b4l3p2n9ctvte9a52b.apps.googleusercontent.com';

void _errorHandler(Object response, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  if (response is AuthException &&
      (response.statusCode.toString() == "422" ||
          response.message.toLowerCase().contains("already registered") ||
          response.message.toLowerCase().contains("already exists"))) {
    logger.w("Account already exists/conflict");
    showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(l10n.accountConflictTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Text(
                l10n.accountConflictMessageEmail,
                style: const TextStyle(fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.ok),
                )
              ],
            ));
  } else if (response is AuthException &&
      response.code.toString() == "invalid_credentials") {
    logger.w("Invalid credentials");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l10n.invalidCredentialsMessage),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 4),
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
  final l10n = AppLocalizations.of(context)!;
  if (response is AuthResponse) {
    // Check if the user already exists with another provider (e.g. Google) but email confirmation is on.
    // If user's identity list is empty, Supabase returned a secure mock user signifying the email is in use.
    final identities = response.user?.identities;
    if (identities != null && identities.isEmpty) {
      logger.i("Account conflict: email already exists (mock user returned)");
      showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.accountConflictTitle,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            l10n.accountConflictMessageProvider,
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.signUpSuccessMessage),
      ),
    );

    logger.i("Signed up user");
    final username = response.user?.appMetadata['username'] as String?;
    await prefs.setString('pending_username',
        username.toString()); //Can only update after email verification
    if (context.mounted) {
      context.go(
          '/verify-email?email=${Uri.encodeComponent(response.user!.email!)}');
    }
  }
}

Future<void> _signInHandler(Object response, BuildContext context) async {
  if (response is AuthResponse) {
    logger.i("Signed in user");

    final userMetadata = response.user?.userMetadata;
    final hasUsername =
        userMetadata != null && userMetadata['username'] != null;

    if (context.mounted) {
      if (!hasUsername) {
        context.go('/setup-username');
        return;
      }

      final isNewUser = await getUserSettings() == null;
      if (context.mounted) {
        if (isNewUser) {
          context.go('/onboarding');
        } else {
          context.go('/home');
        }
      }
    }
  } else {
    logger.e(response);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

Future<void> _signInWithGoogle(BuildContext context) async {
  try {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        clientId: Platform.isIOS ? googleIosClientId : null,
        serverClientId: googleWebClientId,
      );

      final googleUser = await googleSignIn.authenticate();
      if (googleUser == null) {
        // User cancelled flow
        return;
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw 'No ID Token found. Please check Google Sign-in configuration.';
      }

      final googleAuthorization = await googleUser.authorizationClient.authorizationForScopes([]);
      final accessToken = googleAuthorization?.accessToken;

      final response = await supabaseClient.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: accessToken,
      );

      if (context.mounted) {
        await _signInHandler(response, context);
      }
    } else {
      // Fallback for Web/other platforms to redirect OAuth
      await supabaseClient.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'io.supabase.schoolmate://login-callback/',
      );
    }
  } catch (e) {
    logger.e("Google Sign-In failed", e);
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (e is AuthException &&
          (e.statusCode.toString() == "422" ||
              e.message.toLowerCase().contains("already registered") ||
              e.message.toLowerCase().contains("already exists"))) {
        showAdaptiveDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.accountConflictTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(
              l10n.accountConflictMessageGoogle,
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
              )
            ],
          ),
        );
      } else {
        _errorHandler(e, context);
      }
    }
  }
}

Scaffold build(BuildContext context) {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;
  final l10n = AppLocalizations.of(context)!;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        l10n.welcomeToSchoolMate,
        style: theme.textTheme.headlineLarge,
      ),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Theme(
                // Overrides input/button styling locally inside SupaEmailAuth to ensure good contrast
                data: theme.copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SupaEmailAuth(
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
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          label: l10n.usernameLabel,
                          key: 'username',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return l10n.pleaseEnterSomething;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            l10n.orLabel,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _GoogleSignInButton(
                      onPressed: () => _signInWithGoogle(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.string(
            _googleLogoSvg,
            height: 22,
            width: 22,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.continueWithGoogle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

const String _googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22c-.62-.62-1.09-1.34-1.25-2.14z"/>
  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/>
</svg>
''';
