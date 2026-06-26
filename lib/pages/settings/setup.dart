import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/API/supabase/auth/userSettings.dart';
import 'package:school_mate/Classes/geoPolitics/Country.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/l10n/app_localizations.dart';

import '../../main.dart';
import 'Widgets/ResidenceSelector/SearchableResidenceSelector.dart';

class SetupPage extends StatefulWidget {
  final MaterialPageRoute afterSelectionRoute;
  final bool isOnboarding;

  const SetupPage(
      {super.key, required this.afterSelectionRoute, this.isOnboarding = true});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String? _exactSelectedResidence;
  Country? _selectedResidence;

  void changeExactResidence(String? residence) {
    if (residence == null) {
      setState(() {
        _selectedResidence = null;
      });
    } else {
      setState(() {
        _exactSelectedResidence = residence;
      });
    }
  }

  void changeResidence(Country residence) {
    setState(() {
      _selectedResidence = residence;
      _exactSelectedResidence =
          null; // Reset state selection when country changes
    });
    logger.d(
        "Selected residence: ${_selectedResidence!.name} (${_selectedResidence!.code})");
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isOnboarding
                ? l10n.welcomeUsername(getUserName())
                : l10n.residenceUpdate,
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title and description section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.isOnboarding
                        ? l10n.thanksSigningUp
                        : l10n.updateCurrentResidence,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.isOnboarding
                  ? l10n.setupIntroOnboarding
                  : l10n.setupIntroUpdate,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Country Selector
                    SearchableResidenceSelector(
                      onChange: changeResidence,
                      preSelectedCountry: _selectedResidence,
                    ),
                    const SizedBox(height: 16),

                    // State Selector (shows only when a country is selected)
                    if (_selectedResidence != null)
                      SearchableStateSelector(
                        onChange: changeExactResidence,
                        selectedCountry: _selectedResidence!.code,
                        selectedCountryString: _selectedResidence!.name,
                        selectedExactResidence: _exactSelectedResidence,
                      ),
                  ],
                ),
              ),
            ),

            // Save Button
            if (_exactSelectedResidence != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedGradientButton(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  onPressed: () async {
                    await forceUpdateUserSettings(
                        residenceCountry: _selectedResidence,
                        residence: _exactSelectedResidence);
                    if (context.mounted) {
                      if (widget.isOnboarding) {
                        context.go('/home');
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(l10n.save,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
