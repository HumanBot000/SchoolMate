import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/geoPolitics/Country.dart';
import 'package:school_mate/pages/settings/Widgets/settings/ResidenceSelector/CountrySelector.dart';
import 'package:school_mate/pages/settings/Widgets/settings/ResidenceSelector/StateSelector.dart';

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
              preSelectedCountry: _selectedResidence,
            ),
            if (_selectedResidence != null)
              LocalResidenceSelector(
                onChange: changeExactResidence,
                selectedCountry: _selectedResidence!.code,
                selectedCountryString: _selectedResidence!.name,
                selectedExactResidence: _exactSelectedResidence,
              ),
          ],
        ),
      ),
    );
  }
}
