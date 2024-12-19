import 'package:app/pages/settings/residence.dart';
import 'package:app/util/userData.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${getUserName()}",
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
        child: Column(
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
            ResidenceSelector(),
          ],
        ),
      ),
    );
  }
}
