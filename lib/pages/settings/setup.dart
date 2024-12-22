import 'package:app/Widgets/settings/GradingSystemChooser.dart';
import 'package:app/Widgets/settings/ResidenceChooser.dart';
import 'package:app/pages/home/start.dart';
import 'package:app/supabase/userData.dart';
import 'package:app/supabase/userSettings.dart' as supabase_settings;
import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  var _selectedResidence;
  void changeResidence(residence) {
    setState(() {
      _selectedResidence = residence;
    });
  }

  Future<void> changeGradingSystem(gradingSystem) async {
    await supabase_settings.updateUserSettings(
        _selectedResidence, gradingSystem);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${getUserName()}",
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thanks for signing up!",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            Wrap(
              children: [
                Text(
                  "Before you can start using SchoolMate, we need to know some last details about you.",
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
            ResidenceSelector(
              onChange: changeResidence,
            ),
            if (_selectedResidence != null)
              GradingSystemSettings(
                onChange: changeGradingSystem,
              )
          ],
        ),
      ),
    );
  }
}
