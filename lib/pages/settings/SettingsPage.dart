import 'package:flutter/material.dart';

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
            leading: const BackButton(),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.settings),
                child: Text("General"),
              ),
              Tab(
                icon: Icon(Icons.settings),
                child: Text("Other"),
              ),
            ]),
          ),
        ));
  }
}
