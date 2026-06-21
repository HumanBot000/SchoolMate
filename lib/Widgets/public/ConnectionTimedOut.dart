import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';

class ConnectionTimedOutPage extends StatelessWidget {
  final Function() onTryAgain;

  const ConnectionTimedOutPage({super.key, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large sad emoji
            const Text(
              "😞",
              style: TextStyle(fontSize: 80), // Huge emoji
            ),
            const SizedBox(height: 20),
            // Error message
            Text(
              l10n.couldNotConnectToServers,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle
            Text(
              l10n.checkConnectionAndTry,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            // Try Again button with styling
            ElevatedButton.icon(
              onPressed: onTryAgain,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
