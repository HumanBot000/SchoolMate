import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/gradingSystem.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/marks/setup/GradingSetupPage.dart';

import '../../../main.dart';

class MarksPage extends StatefulWidget {
  const MarksPage({super.key});

  @override
  State<MarksPage> createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  @override
  void initState() {
    super.initState();
    test();
  }

  Future<void> test() async {
    GradingSystem g = await fetchGradingSystem();
    for (ExamType et in g.examTypes) {
      logger.wtf(et.evaluationData.multiplicationChildType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marks"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const HomeNavBar(currentIndex: 3),
      body: const GradingSetupPage(),
    );
  }
}
