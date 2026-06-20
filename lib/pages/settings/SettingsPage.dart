import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/pages/settings/Widgets/NotificationSettingsPage.dart';
import 'package:school_mate/pages/settings/Widgets/OtherSettingsPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.settingsTitle),
            leading: const PreviousPage(),
            bottom: TabBar(tabs: [
              Tab(
                icon: const Icon(Icons.settings),
                child: Text(l10n.generalTab),
              ),
              Tab(
                icon: const Icon(Icons.notifications),
                child: Text(l10n.notificationsTab),
              ),
            ]),
          ),
          body: const TabBarView(children: [
            OtherSettingsPage(),
            NotificationSettingsPage(),
          ]),
        ));
  }
}
