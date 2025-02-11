import 'package:flutter/material.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';

class MarksPage extends StatelessWidget {
  const MarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marks"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const HomeNavBar(currentIndex: 3),
    );
  }
}
