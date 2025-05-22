import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/homeworks/tasks.dart';
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/homework/Homework.dart';
import 'package:school_mate/pages/home/homework/add/Widgets/AdditionalHomeworkNote.dart';
import 'package:school_mate/pages/home/homework/add/Widgets/DateSelector.dart';
import 'package:school_mate/pages/home/homework/add/Widgets/HandInToggle.dart';
import 'package:school_mate/pages/home/homework/add/Widgets/SubjectChooser.dart';
import 'package:school_mate/pages/home/homework/add/Widgets/TitleSelector.dart';
import 'package:school_mate/util/extensions/dates.dart';
import 'package:school_mate/util/notifications/homework.dart';

class AddHomeworkPage extends StatefulWidget {
  final dynamic schedule;
  final Homework? task;

  // Optional pre-fill parameters
  final String? initialTitle;
  final Subject? initialSubject;
  final DateTime? initialDate;
  final String? initialNote;
  final bool? initialHandIn;
  final TimeOfDay? initialHandInTime;

  const AddHomeworkPage({
    super.key,
    required this.schedule,
    this.task,
    this.initialTitle,
    this.initialSubject,
    this.initialDate,
    this.initialNote,
    this.initialHandIn,
    this.initialHandInTime,
  });

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _additionalNoteController =
      TextEditingController();
  Subject? _selectedSubject;
  DateTime? _selectedDate;
  bool _handInHomework = false;
  TimeOfDay? _handInTime;

  @override
  void initState() {
    super.initState();

    // Priority: task data > initial parameters > defaults
    _titleController.text = widget.task?.title ?? widget.initialTitle ?? '';
    _additionalNoteController.text =
        widget.task?.note ?? widget.initialNote ?? '';
    _selectedSubject = widget.task?.subject ?? widget.initialSubject;
    _selectedDate = widget.task?.dueDate ?? widget.initialDate;
    _handInHomework = widget.task?.handIn ?? widget.initialHandIn ?? false;
    _handInTime =
        widget.task?.dueDate?.toTimeOfDay() ?? widget.initialHandInTime;

    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _additionalNoteController.dispose();
    super.dispose();
  }

  void _onHandInTimeChanged(TimeOfDay value) {
    setState(() {
      _handInTime = value;
    });
  }

  void _onHandInStateChanged(bool value) {
    setState(() {
      _handInHomework = value;
    });
    if (value && _handInTime == null) {
      _onHandInTimeChanged(TimeOfDay.now());
    }
  }

  void _onTitleChanged(String value) {
    setState(() {
      _titleController.text = value;
    });
  }

  void _onLessonSelection(Lesson lesson, DateTime date) {
    Navigator.of(context).pop();
    setState(() {
      _selectedSubject = lesson.subject;
    });
    _onDateSelection(date);
  }

  void _onSubjectSelection(Subject subject) {
    setState(() {
      _selectedSubject = subject;
    });
  }

  void _onDateSelection(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onSave() async {
    if (_titleController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: const Text("Please provide a title"),
                ),
              ));
      return;
    }
    if (_selectedSubject == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: const Text("Please select a subject for this homework!"),
            ),
          ));
      return;
    }
    if (_selectedDate != null && _selectedDate!.isBefore(DateTime.now())) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: const Text("Select a date in the future!"),
                ),
              ));
      return;
    }
    if (_handInHomework && _handInTime == null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: const Text("Please select a hand in time!"),
                ),
              ));
      return;
    }
    if (widget.task == null) {
      // Not a preexisting task (new Task)
      try {
        await addTask(_titleController.text, _handInHomework, _selectedSubject!,
            dueDate: _selectedDate,
            handInTime: _handInTime,
            note: _additionalNoteController.text);
        logger.i("Added a new homework");
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Added Homework successfully!"),
                  ),
                ));
        // ensure page reload
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeworkPage(),
        ));
        await updateHomeworkNotifications(await fetchHomeworks());
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: const Text("Something went wrong. Please try again."),
              ),
            ));
        logger.e(e);
        rethrow;
      }
      return;
    }
    // Existing Task
    try {
      await updateTask(widget.task!, _titleController.text, _handInHomework,
          _selectedSubject!,
          dueDate: _selectedDate,
          handInTime: _handInTime,
          note: _additionalNoteController.text);
      logger.i("Updated a homework");
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Updated Homework successfully!"),
                ),
              ));
      // ensure page reload
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeworkPage(),
      ));
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: const Text("Something went wrong. Please try again."),
            ),
          ));
      logger.e(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0), // removes default ListView padding
        children: [
          HomeworkTitleSelector(
            titleController: _titleController,
            onChange: _onTitleChanged,
          ),
          HomeworkSubjectChooser(
            onLessonSelection: _onLessonSelection,
            selectedSubject: _selectedSubject,
            schedule: widget.schedule,
            onSubjectSelection: _onSubjectSelection,
          ),
          HomeworkDateSelector(
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelection,
          ),
          AdditionalHomeworkNote(
            noteController: _additionalNoteController,
          ),
          HandInHomeworkToggle(
            value: _handInHomework,
            onStateChanged: _onHandInStateChanged,
            handInTime: _handInTime,
            onTimeSelected: _onHandInTimeChanged,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedGradientButton(
              borderRadius: BorderRadius.circular(12.0),
              onPressed: () async => _onSave(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Save",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
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
