import 'package:app/API/supabase/userData.dart';
import 'package:app/API/supabase/userSettings.dart' as supabase_settings;
import 'package:app/Classes/geoPolitics/Country.dart';
import 'package:app/pages/home/home/start.dart';
import 'package:flutter/material.dart';

import 'Widgets/settings/GradingSystemChooser.dart';
import 'Widgets/settings/ResidenceSelector/CountrySelector.dart';
import 'Widgets/settings/ResidenceSelector/StateSelector.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  var _exactSelectedResidence;
  var _selectedResidence;

  void changeExactResidence(String? residence) {
    if (residence == null) {
      setState(() {
        _selectedResidence = null;
      });
    }
    setState(() {
      _exactSelectedResidence = residence;
    });
  }

  void changeResidence(Country residence) {
    setState(() {
      _selectedResidence = residence;
    });
  }

  Future<void> changeGradingSystem(gradingSystem) async {
    await supabase_settings.updateUserSettings(
        _selectedResidence, _exactSelectedResidence, gradingSystem);
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
              selected: _selectedResidence,
            ),
            if (_selectedResidence != null)
              LocalResidenceSelector(
                onChange: changeExactResidence,
                selectedCountry: _selectedResidence!.code,
                selectedCountryString: _selectedResidence!.name,
                selectedExactResidence: _exactSelectedResidence,
              ),
            if (_exactSelectedResidence != null)
              GradingSystemSettings(
                onChange: changeGradingSystem,
              )
          ],
        ),
      ),
    );
  }
}
