import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/home/Widgets/DayProgressBar.dart';
import 'package:school_mate/pages/home/home/Widgets/HomeDrawer.dart';

import 'Widgets/UpcomingHolidaysCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Schedule? _schedule;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final scheduleData = await fetchSchedule();
    setState(() {
      _schedule = scheduleData != "" ? scheduleData : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      bottomNavigationBar: const HomeNavBar(
        currentIndex: 0,
      ),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0x003a7bff),
      ),
      body: Stack(children: [
        if (_schedule != null &&
            _schedule!.lessons
                .where((lesson) =>
                    lesson.temporalData.weekday == DateTime.now().weekday)
                .isNotEmpty)
          DayProgressBar(
            startTime: _schedule!.lessons
                .where((lesson) =>
                    lesson.temporalData.weekday == DateTime.now().weekday)
                .first
                .temporalData
                .startTime,
            endTime: _schedule!.lessons
                .where((lesson) =>
                    lesson.temporalData.weekday == DateTime.now().weekday)
                .last
                .temporalData
                .endTime,
          ),
        Align(alignment: Alignment.bottomCenter, child: UpcomingHolidaysCard()),
      ]),
    );
  }
}
