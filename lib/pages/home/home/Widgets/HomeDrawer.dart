import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:school_mate/pages/settings/SettingsPage.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String version = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: DrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary),
            child: Text(
              'SchoolMate v$version',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.profileTitle),
          leading: const Icon(Icons.person),
          onTap: () {},
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.settingsTitle),
          leading: const Icon(Icons.settings),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ));
          },
        ),
      ]),
    );
  }
}
