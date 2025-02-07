import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/settings/preLessonNotifications.dart';
import 'package:school_mate/main.dart';

class PreLessonNotificationSetup extends StatefulWidget {
  const PreLessonNotificationSetup({super.key});

  @override
  State<PreLessonNotificationSetup> createState() =>
      _PreLessonNotificationSetupState();
}

class _PreLessonNotificationSetupState extends State<PreLessonNotificationSetup>
    with TickerProviderStateMixin {
  bool _notificationsEnabled = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<List<dynamic>> _reminders = [];
  List<TextEditingController> _reminderValueControllers = [];

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    final reminders = await fetchPreLessonNotifications();
    List<TextEditingController> reminderValueControllers = [];
    for (var reminder in reminders) {
      reminderValueControllers
          .add(TextEditingController(text: reminder[1].toString()));
    }
    setState(() {
      _reminders = reminders;
      _notificationsEnabled = _reminders.isNotEmpty;
      _reminderValueControllers = reminderValueControllers;
    });
    if (_reminders.isEmpty) return;
    _listKey.currentState?.insertItem(_reminders.length - 1,
        duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    for (final controller in _reminderValueControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _addReminder() async {
    final newReminder = ["minutes", 5];
    final newController = TextEditingController(text: "5");
    _reminders.add(newReminder);
    _reminderValueControllers.add(newController);
    _listKey.currentState?.insertItem(_reminders.length - 1,
        duration: const Duration(milliseconds: 300));
    await _onChange();
  }

  Future<void> _removeReminder(int index) async {
    final removedItem = _reminders.removeAt(index);
    _reminderValueControllers.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildReminderItem(removedItem, index, animation),
      duration: const Duration(milliseconds: 300),
    );
    await _onChange();
  }

  Future<void> _onChange() async {
    if (preLessonNotificationListIsValid(_reminders)) {
      await updatePreLessonNotifications(_reminders);
      logger.i("Updated pre-lesson notifications");
    }
  }

  Widget _buildReminderItem(
      List<dynamic> reminder, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: GestureDetector(
        onLongPress: () => _removeReminder(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 4.0,
            shadowColor: Colors.blueAccent.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNumberField(index),
                  const SizedBox(width: 10),
                  _buildDropdown(index),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "before the lesson starts",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _removeReminder(index),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(int index) {
    return SizedBox(
      width: 80,
      height: 50,
      child: TextField(
        controller: _reminderValueControllers.isEmpty
            ? null
            : _reminderValueControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) async {
          if (value.isEmpty || int.tryParse(value) == null) return;
          setState(() {
            _reminders[index][1] = int.parse(value);
          });
          await _onChange();
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.timer, color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildDropdown(int index) {
    return DropdownButton<String>(
      value: _reminders.isEmpty ? null : _reminders[index][0],
      items: const [
        DropdownMenuItem(value: "seconds", child: Text("Seconds")),
        DropdownMenuItem(value: "minutes", child: Text("Minutes")),
        DropdownMenuItem(value: "hours", child: Text("Hours")),
      ],
      onChanged: (value) async {
        if (value != null) {
          setState(() {
            _reminders[index][0] = value;
          });
          await _onChange();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pre-Lesson Notifications"),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Pre-Lesson Notifications Enabled"),
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          Opacity(
            opacity: _notificationsEnabled ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !_notificationsEnabled,
              child: Column(
                children: [
                  AnimatedList(
                    key: _listKey,
                    initialItemCount: _reminders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index, animation) {
                      return _buildReminderItem(
                          _reminders[index], index, animation);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Add Reminder"),
                        onPressed: _addReminder,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
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
