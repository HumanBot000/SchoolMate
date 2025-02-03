import 'package:flutter/material.dart';

class PreLessonNotificationSetup extends StatefulWidget {
  const PreLessonNotificationSetup({super.key});

  @override
  State<PreLessonNotificationSetup> createState() =>
      _PreLessonNotificationSetupState();
}

class _PreLessonNotificationSetupState
    extends State<PreLessonNotificationSetup> {
  bool _notificationsEnabled = false;

  List<List<dynamic>> _reminders = [
    ["seconds", 5]
  ]; // [String: time unit, int: value]

  late List<TextEditingController> _reminderValueControllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _reminders.length; i++) {
      _reminderValueControllers
          .add(TextEditingController(text: _reminders[i][1].toString()));
    }
  }

  @override
  void dispose() {
    // Many text fields may cause performance issues (need to clarify)
    for (int i = 0; i < _reminderValueControllers.length; i++) {
      _reminderValueControllers[i].dispose();
    }
    super.dispose();
  }

  Widget _buildReminderRows() {
    List<Widget> rows = [];

    for (int i = 0; i < _reminders.length; i++) {
      rows.add(GestureDetector(
        onLongPressStart: (_) => setState(() => _reminders.removeAt(i)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: 50,
                    child: TextField(
                      controller: _reminderValueControllers[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                      // Changed text color for visibility
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50, // todo doesn't have same height as TextField
                      child: DropdownMenu<String>(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        initialSelection: _reminders[i][0],
                        enableSearch: false,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: "seconds", label: "Seconds"),
                          DropdownMenuEntry(value: "minutes", label: "Minutes"),
                          DropdownMenuEntry(value: "hours", label: "Hours"),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            setState(() {
                              _reminders[i][0] = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "before the lesson starts",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return Column(
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pre-Lesson Notification Setup"),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Pre-Lesson Notification Enabled"),
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              onChanged: (value) =>
                  setState(() => _notificationsEnabled = value),
            ),
          ),
          Opacity(
            opacity: _notificationsEnabled ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !_notificationsEnabled,
              child: Column(
                children: [
                  if (_reminderValueControllers.isNotEmpty)
                    _buildReminderRows(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        tooltip: "Add a reminder",
                        onPressed: () {
                          List<List<dynamic>> newReminders =
                              List.from(_reminders);
                          newReminders.add(["minutes", 5]);
                          List<TextEditingController> newControllers =
                              List.from(_reminderValueControllers);
                          newControllers.add(TextEditingController(text: "5"));
                          setState(() {
                            _reminders = newReminders;
                            _reminderValueControllers = newControllers;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        iconSize: 30,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
