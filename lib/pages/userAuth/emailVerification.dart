import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with SingleTickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late AnimationController _pinAnimationController;
  bool _isCodeValid = false;
  int _resendCountdown = 120;

  @override
  void initState() {
    super.initState();
    _pinAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    Future.delayed(Duration.zero, _startResendCountdown);
  }

  @override
  void dispose() {
    _pinAnimationController.dispose();
    _resendCountdown =
        0; // Don't rebuild the ui for button label that doesn't exist anymore
    super.dispose();
  }

  void _startResendCountdown() {
    Future.doWhile(() async {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        await Future.delayed(const Duration(seconds: 1));
      }
      return _resendCountdown > 0;
    });
  }

  void _resendCode() {
    setState(() {
      _resendCountdown = 160;
    });
    _startResendCountdown();
    supabaseClient.client.auth.resend(type: OtpType.email, email: widget.email);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l10n.verificationCodeSent(widget.email)),
    ));
    logger.i("New OTP requested");
  }

  Future<void> _handleVerification() async {
    String username = prefs.getString('pending_username') ?? '';
    await supabaseClient.client.auth.updateUser(UserAttributes(
      data: {'display_name': username, "email_verified": true},
    ));
    logger.i("Set display name to $username");
    if (context.mounted) {
      context.go('/onboarding');
    }
  }

  Future<bool> _validateOTP(value) async {
    try {
      AuthResponse response = await supabaseClient.client.auth
          .verifyOTP(type: OtpType.email, token: value, email: widget.email);
      setState(() {
        _isCodeValid = response.user != null;
      });
    } catch (e) {
      if (e is AuthException) {
        logger.w("Invalid OTP");
        _pinAnimationController.forward(from: 0);
        return false;
      }
    }
    logger.i("OTP verified");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcomeToSchoolMate),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Lottie.asset(
                'assets/animations/email_verification_animation.json',
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/email_verification_animation_foreground.json',
                    height: 200,
                    repeat: true,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.emailVerificationSent,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.enterCodeToVerify,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onCompleted: (value) async {
                      bool isValid = await _validateOTP(value);
                      setState(() {
                        _isCodeValid = isValid;
                      });
                      if (_isCodeValid) {
                        await Future.delayed(const Duration(seconds: 3));
                        await _handleVerification();
                      }
                    },
                    animationType: AnimationType.fade,
                    textStyle: const TextStyle(
                      color: Colors.purple,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor:
                          _isCodeValid ? Colors.grey[400]! : Colors.red[100]!,
                      selectedFillColor: Colors.grey[400]!,
                      inactiveFillColor: Colors.grey[400]!,
                      activeColor: Theme.of(context).colorScheme.inversePrimary,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Theme.of(context).colorScheme.secondary,
                    ),
                    enableActiveFill: true,
                    animationDuration: const Duration(milliseconds: 300),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  if (_isCodeValid)
                    Expanded(
                      child: Lottie.asset(
                        'assets/animations/email_verified.json',
                        height: 100,
                        repeat: false,
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            _resendCountdown == 0
                                ? Icons.lock_open_rounded
                                : Icons.lock_outline_rounded,
                            color: _resendCountdown == 0
                                ? Colors.green
                                : Colors.grey,
                            size: 16),
                        TextButton(
                          onPressed: _resendCountdown == 0
                              ? () => _resendCode()
                              : null,
                          child: Text(
                            _resendCountdown == 0
                                ? l10n.resendCode
                                : l10n.resendInSeconds(_resendCountdown.toString()),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
