import 'package:flutter/material.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/schedule/page/Widgets/ScheduleGridView.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectsList.dart';

class SchedulePage extends StatefulWidget {
  final Schedule schedule;

  const SchedulePage({super.key, required this.schedule});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
      ),
      bottomNavigationBar: const HomeNavBar(
        currentIndex: 1,
      ),
      body: Stack(
        children: [
          ScheduleGridView(schedule: widget.schedule),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: IconButton(
                  tooltip: "Add Lesson",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SubjectList(
                        subjects: widget.schedule.subjects,
                      ),
                    ));
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  iconSize: 30,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
