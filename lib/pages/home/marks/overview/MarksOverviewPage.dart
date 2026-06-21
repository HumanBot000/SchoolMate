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
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/marks/Utils.dart';
import 'package:school_mate/pages/home/marks/add/AddMark.dart';
import 'package:school_mate/pages/home/marks/overview/MarkSubjectCard.dart';
import 'package:school_mate/pages/home/marks/overview/SkeletonLoader.dart';
import 'package:school_mate/pages/home/marks/overview/subjectView/SubjectMarksInspectionPage.dart';

import 'EmptySubjectsNotice.dart';

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
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  // Data state variables
  List<Subject> _subjects = [];
  Map<Subject, List<Mark>> _marks = {};
  Map<Subject, double?> _averageMarks = {};
  Map<Subject, Map<ExamType, List<Mark>>> _marksPerExamType = {};
  Map<Subject, Map<ExamType, double?>> _averageMarksPerSubjectAndExamType = {};
  Map<Subject, List<Mark>>? _recentMarks;
  double? _overallAverage;

  // UI state variables
  bool _isLoading = true;
  bool _showSkeleton = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();

    // Show skeleton loader after 3 seconds if still loading
    Timer(const Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        setState(() {
          _showSkeleton = true;
        });
      }
    });
  }

  /// Single point of data loading that optimizes database calls
  Future<void> _loadData() async {
    try {
      // Step 1: Fetch schedule once to get subjects
      dynamic schedule = await fetchSchedule();
      if (schedule is String && schedule.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'No schedule available';
        });
        return;
      }

      List<Subject> subjects = schedule.subjects;

      if (subjects.isEmpty) {
        setState(() {
          _subjects = [];
          _isLoading = false;
        });
        return;
      }

      // Step 2: Fetch all marks data - this makes a single DB call with our optimized API
      Map<Subject, Map<String, Object>> allMarksData =
          await fetchMarksBySubjects(onlyConsiderated: true);

      // Step 3: Calculate averages - now uses cached data from the previous call
      Map<Subject, double?> averageMarks =
          await calculateAverageMarksBySubjects(subjects);

      Map<Subject, Map<ExamType, double?>> averagesPerExamType =
          await calculateAverageMarksBySubjectsAndExamTypes(subjects);

      // Step 4: Get recent marks - also uses cached data
      Map<Subject, List<Mark>> recentMarks =
          await fetchMostRecentMarksForSubjects(widget.gradingSystem, subjects);

      var totalAverage = 0.0;
      int totalMarks = 0;
      for (var averagePerSubject in averageMarks.values) {
        if (averagePerSubject != null) {
          totalAverage += averagePerSubject;
          totalMarks++;
        }
      }
      totalAverage /= totalMarks;
      // Update state only once with all the data
      if (mounted) {
        setState(() {
          _subjects = subjects;
          _marks = allMarksData.map((subject, data) =>
              MapEntry(subject, data["marks"] as List<Mark>));
          _marksPerExamType = allMarksData.map((subject, data) => MapEntry(
              subject, data["marksPerExamType"] as Map<ExamType, List<Mark>>));
          _averageMarks = averageMarks;
          _averageMarksPerSubjectAndExamType = averagesPerExamType;
          _recentMarks = recentMarks;
          _overallAverage = totalAverage;
          _isLoading = false;
          _showSkeleton = false;
        });
      }
    } catch (e) {
      logger.e("Error loading marks data: $e");
      rethrow;
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Error loading marks data: $e';
        });
      }
    }
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
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
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
                        .withValues(alpha: 0.1),
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

  Widget _buildErrorContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
                _errorMessage = '';
              });
              _loadData();
            },
            child: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }

  Container _overallAverageContainer() => Container(
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _overallAverage != null
              ? createMarkGradient(
                  bestMark: parseMark(widget.gradingSystem.range[0]).toInt(),
                  worstMark: parseMark(widget.gradingSystem.range[1]).toInt(),
                  valueMark: _overallAverage!,
                  colors: markColors)
              : LinearGradient(
                  colors: [Colors.grey.shade600, Colors.grey.shade900]),
        ),
        child: Center(
          child: Text(_overallAverage?.toStringAsFixed(2) ?? "No Marks",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: createMarkGradient(
                                    bestMark:
                                        parseMark(widget.gradingSystem.range[0])
                                            .toInt(),
                                    worstMark:
                                        parseMark(widget.gradingSystem.range[1])
                                            .toInt(),
                                    valueMark: _overallAverage!,
                                    colors: markColors)
                                .colors
                                .first
                                .computeLuminance() <
                            0.5
                        ? Colors.white
                        : Colors.grey[850],
                  )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Show skeleton loader if loading takes more than 3 seconds
    if (_isLoading && _showSkeleton) {
      return Scaffold(
        body: buildMarkOverviewSkeletonLoader(),
      );
    }

    // Show loading content with tips and animations
    if (_isLoading) {
      return Scaffold(
        body: _buildLoadingContent(),
      );
    }

    // Show error screen if there was a problem loading data
    if (_hasError) {
      return Scaffold(
        body: _buildErrorContent(),
      );
    }

    // Show empty state if no subjects are available
    if (_subjects.isEmpty) {
      return buildNoSubjectsForGradingNoticePage(context);
    }

    // Show the actual content with subjects and marks
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoading = true;
              });
              await _loadData();
            },
            child: ListView.builder(
              itemCount: _subjects.length + 1,
              itemBuilder: (context, index) => index == 0
                  ? _overallAverageContainer()
                  : InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SubjectMarksInspectionPage(
                            subject: _subjects[index - 1],
                            overallAverage: _averageMarks[_subjects[index - 1]],
                            examTypeAverages:
                                _averageMarksPerSubjectAndExamType[
                                        _subjects[index - 1]] ??
                                    {},
                            marksPerExamType:
                                _marksPerExamType[_subjects[index - 1]] ?? {},
                            gradingSystem: widget.gradingSystem,
                          ),
                        ),
                      ),
                      child: buildGradingSubjectCard(
                        context,
                        _subjects[index - 1],
                        _averageMarks,
                        widget.gradingSystem,
                        _recentMarks?[_subjects[index - 1]] ?? [],
                      ),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: FloatingActionButton(
                tooltip: l10n.addMarkTooltip,
                onPressed: () => Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AddMarkPage(gradingSystem: widget.gradingSystem),
                  ),
                )
                    .then((_) {
                  // Refresh data when returning from add mark page
                  _loadData();
                }),
                child: const Icon(Icons.add_chart_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
