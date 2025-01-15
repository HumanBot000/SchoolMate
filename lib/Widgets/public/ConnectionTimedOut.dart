import 'package:flutter/material.dart';

class ConnectionTimedOutPage extends StatelessWidget {
  final Function() onTryAgain;

  const ConnectionTimedOutPage({super.key, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large sad emoji
            Text(
              "😞",
              style: TextStyle(fontSize: 80), // Huge emoji
            ),
            SizedBox(height: 20),
            // Error message
            Text(
              "We couldn't connect to the servers.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            // Subtitle
            Text(
              "Please check your connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            // Try Again button with styling
            ElevatedButton.icon(
              onPressed: onTryAgain,
              icon: Icon(Icons.refresh),
              label: Text("Try Again"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
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
