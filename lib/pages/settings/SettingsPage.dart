import 'package:flutter/material.dart';
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
            leading: const PreviousPage(),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.settings),
                child: Text("General"),
              ),
              Tab(
                icon: Icon(Icons.notifications),
                child: Text("Notifications"),
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
