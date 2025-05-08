import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/auth/userData.dart' as user;
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/pages/settings/SettingsPage.dart';
import 'package:school_mate/pages/settings/schedule/ScheduleEditLogic.dart'
    as schedule_edit_logic;
import 'package:school_mate/pages/settings/setup.dart';

class OtherSettingsPage extends StatefulWidget {
  const OtherSettingsPage({super.key});

  @override
  State<OtherSettingsPage> createState() => _OtherSettingsPageState();
}

class _OtherSettingsPageState extends State<OtherSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Residence'),
          leading: const Icon(
            Icons.location_on,
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
          ),
          subtitle: Text(
            "Tell us where you live, so we can calculate the next school holidays.",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SetupPage(
              afterSelectionRoute:
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
              isOnboarding: false,
            ),
          )),
        ),
        ListTile(
            title: const Text('Schedule'),
            leading: const Icon(
              Icons.calendar_month_outlined,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
            ),
            subtitle: Text(
              "Configure your schedule to start tracking your lessons.",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
            onTap: () => schedule_edit_logic.onTap(context)),
        Card(
          elevation: 4.0,
          shadowColor: Colors.red,
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Danger Zone",
                    style: Theme.of(context).textTheme.headlineSmall),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedGradientButton(
                      width: MediaQuery.of(context).size.width * 0.4,
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [Colors.red.shade900, Colors.red.shade700]),
                      onPressed: () => showAdaptiveDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: const Text("Are you sure?"),
                                  content: const Text(
                                      "You will be logged out of your account."),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          user.signOut(context);
                                        },
                                        child: const Text("Logout")),
                                  ])),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            Text("Logout",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ])),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
