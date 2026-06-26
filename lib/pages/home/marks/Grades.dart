import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/marks/overview/MarksOverviewPage.dart';
import 'package:school_mate/pages/home/marks/setup/GradingSetupPage.dart';

import '../../../API/supabase/grades/gradingSystem.dart';

class MarksPage extends StatefulWidget {
  const MarksPage({super.key});

  @override
  State<MarksPage> createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.marksTitle),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const HomeNavBar(currentIndex: 3),
      body: FutureBuilder<dynamic>(
          future: fetchGradingSystem(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              logger.e(snapshot.error);
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data;
              if (data == null) {
                return const GradingSetupPage();
              }
              return MarksOverviewPage(gradingSystem: data);
            } else {
              return Center(
                child: Text(l10n.noDataAvailable),
              );
            }
          }),
    );
  }
}
