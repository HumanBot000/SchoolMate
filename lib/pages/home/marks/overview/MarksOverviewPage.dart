import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/pages/home/marks/Utils.dart';
import 'package:school_mate/pages/home/marks/add/AddMark.dart';
import 'package:school_mate/pages/home/marks/overview/MarkSubjectCard.dart';
import 'package:school_mate/pages/home/marks/overview/SkeletonLoader.dart';
import 'package:school_mate/pages/home/marks/overview/subjectView/SubjectMarksInspectionPage.dart';

import 'EmptySubjectsNotics.dart';

class MarksOverviewPage extends StatefulWidget {
  final GradingSystem gradingSystem;

  const MarksOverviewPage({super.key, required this.gradingSystem});

  @override
  State<MarksOverviewPage> createState() => _MarksOverviewPageState();
}

LinearGradient createMarkGradient({
  required int bestMark,
  required int worstMark,
  required double valueMark,
  required List<Color> colors,
}) {
  final double t =
      ((valueMark - bestMark) / (worstMark - bestMark)).clamp(0.0, 1.0);

  final int colorCount = colors.length;
  final double segmentSize = 1.0 / (colorCount - 1);

  int segmentIndex = (t / segmentSize).floor();
  segmentIndex = segmentIndex.clamp(0, colorCount - 2);

  final List<Color> gradientColors = [
    colors[segmentIndex],
    colors[segmentIndex + 1],
  ];
  final List<double> stops = [0.0, 1.0];

  return LinearGradient(
    colors: gradientColors,
    stops: stops,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class _MarksOverviewPageState extends State<MarksOverviewPage> {
  List<Subject> _subjects = [];
  Map<Subject, List<Mark>> _marks = {};
  Map<Subject, double?> _averageMarks = {};
  Map<Subject, Map<ExamType, List<Mark>>> _marksPerExamType = {};
  Map<Subject, Map<ExamType, double?>>? _averageMarksPerSubjectAndExamType = {};
  int goal = 7;
  bool _isLoading = true;
  bool _showSkeleton = false;

  @override
  void initState() {
    super.initState();
    _load();
    Timer(const Duration(seconds: 3), () {
      if (_isLoading) {
        setState(() {
          _showSkeleton = true;
        });
      }
    });
  }

  Future<void> _loadData() async {
    dynamic schedule = await fetchSchedule();
    if (schedule is String && schedule.isEmpty) return;

    Map<Subject, Map<String, Object>> marks =
        await fetchMarksBySubjects(onlyConsiderated: true);

    var averageMarksBySubjects =
        await calculateAverageMarksBySubjects(schedule.subjects);
    var averageMarksBySubjectAndExamType =
        await calculateAverageMarksBySubjectsAndExamTypes(schedule.subjects);
    setState(() {
      _subjects = schedule.subjects;
      _marks = marks.map(
          (subject, data) => MapEntry(subject, data["marks"] as List<Mark>));
      _marksPerExamType = marks.map((subject, data) => MapEntry(
          subject, data["marksPerExamType"] as Map<ExamType, List<Mark>>));
      _averageMarks = averageMarksBySubjects;
      if (schedule.subjects.isNotEmpty) {
        _averageMarksPerSubjectAndExamType = averageMarksBySubjectAndExamType;
      }
    });
  }

  Future<void> _load() async {
    await _loadData();
    setState(() {
      _isLoading = false;
      _showSkeleton = false;
    });
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Stack(
        children: [
          Positioned.fill(
            top: 100,
            child: Opacity(
              opacity: 0.1,
              child: Lottie.asset(
                'assets/animations/school_building.json',
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Study Tip',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      studyTips[Random().nextInt(studyTips.length)],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        motivationalQuotes[
                            Random().nextInt(motivationalQuotes.length)],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @deprecated
  Widget _buildStatsHeader() {
    //todo
    final averages = [10];
    final overallAverage = averages.reduce((a, b) => a + b) / averages.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('Overall Average',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(overallAverage.toStringAsFixed(1),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          /* todo Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBadge(Icons.emoji_events, 'Goal Achieved',
                  "${_mockMarks.values.where((e) => e['average'] >= goal).length.toString()} Subjects"),
              _buildStatBadge(Icons.warning, 'Needs Attention',
                  "${_mockMarks.values.where((e) => e['average'] < goal).length.toString()} Subjects"),
            ],
          ),
          */
        ],
      ),
    );
  }

  @deprecated
  Widget _buildStatBadge(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8))),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _showSkeleton) {
      return Scaffold(
        body: buildMarkOverviewSkeletonLoader(),
      );
    }

    if (_isLoading) {
      return Scaffold(
        body: _buildLoadingContent(),
      );
    }

    if (_subjects.isEmpty) return buildNoSubjectsForGradingNoticePage(context);

    return Scaffold(
        body: Stack(
      children: [
        ListView.builder(
          itemCount: _subjects.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SubjectMarksInspectionPage(
                subject: _subjects[index],
                overallAverage: _averageMarks[_subjects[index]],
                examTypeAverages:
                    _averageMarksPerSubjectAndExamType?[_subjects[index]] ?? {},
                marksPerExamType: _marksPerExamType[_subjects[index]] ?? {},
                gradingSystem: widget.gradingSystem,
              ),
            )),
            child: buildGradingSubjectCard(
                context, _subjects[index], _averageMarks, widget.gradingSystem),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: FloatingActionButton(
              tooltip: "Add a Mark to a subject",
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AddMarkPage(gradingSystem: widget.gradingSystem),
              )),
              child: const Icon(Icons.add_chart_rounded),
            ),
          ),
        ),
      ],
    ));
  }
}
