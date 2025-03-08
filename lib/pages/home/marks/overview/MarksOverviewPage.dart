import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/pages/home/schedule/start.dart';

class MarksOverviewPage extends StatefulWidget {
  final GradingSystem gradingSystem;

  const MarksOverviewPage({super.key, required this.gradingSystem});

  @override
  State<MarksOverviewPage> createState() => _MarksOverviewPageState();
}

class _MarksOverviewPageState extends State<MarksOverviewPage> {
  List<Subject> subjects = [];
  final Map<int, Map<String, dynamic>> _mockMarks = {};
  final List<String> _studyTips = [
    "Break your study sessions into 25-minute chunks with 5-minute breaks",
    "Teach what you've learned to someone else - it reinforces your understanding",
    "Create mind maps to visualize complex topics",
    "Use the Pomodoro technique to maintain focus",
    "Practice active recall by testing yourself regularly",
    "Mix different subjects in a single study session for better retention",
    "Get enough sleep - it's crucial for memory consolidation"
  ];

  final List<String> _motivationalQuotes = [
    "Success is the sum of small efforts, repeated day in and day out.",
    "The expert in anything was once a beginner.",
    "Don't watch the clock; do what it does. Keep going.",
    "You don't have to be great to start, but you have to start to be great.",
    "The beautiful thing about learning is that no one can take it away from you.",
    "Believe you can and you're halfway there.",
    "Your future is created by what you do today, not tomorrow."
  ];

  int _currentTipIndex = 0;
  int _currentQuoteIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
    _loadSubjects().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _startLoadingAnimation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _currentTipIndex = (_currentTipIndex + 1) % _studyTips.length;
        _currentQuoteIndex =
            (_currentQuoteIndex + 1) % _motivationalQuotes.length;
      });
      return _isLoading;
    });
  }

  void _generateMockMarks() {
    final Random rand = Random();
    for (var subject in subjects) {
      _mockMarks[subject.id] = {
        'average': 4.0 + rand.nextDouble() * 6.0,
        'recent': List.generate(3, (_) => 4.0 + rand.nextDouble() * 6.0),
        'attendance': 0.7 + rand.nextDouble() * 0.3,
      };
    }
  }

  Color _getGradeColor(double grade) {
    if (grade >= 8.5) return Colors.green.shade600;
    if (grade >= 6.5) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Container(
              key: ValueKey<int>(_currentTipIndex),
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
                    _studyTips[_currentTipIndex],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
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
              key: ValueKey<int>(_currentQuoteIndex),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
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
                    _motivationalQuotes[_currentQuoteIndex],
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
    );
  }

  Widget _buildSubjectCard(Subject subject) {
    final marks = _mockMarks[subject.id]!;
    final average = marks['average'] as double;
    final recent = marks['recent'] as List<double>;
    final attendance = marks['attendance'] as double;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                subject.avatar(context),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    subject.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getGradeColor(average).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    average.toStringAsFixed(1),
                    style: TextStyle(
                      color: _getGradeColor(average),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: attendance,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                attendance >= 0.85 ? Colors.green : Colors.orange,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance ${(attendance * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Icon(
                    attendance >= 0.85
                        ? Icons.trending_up
                        : Icons.trending_flat,
                    color: attendance >= 0.85 ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent marks:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade600)),
                IconButton(
                  icon: Icon(Icons.add_circle,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    /* Add mark functionality */
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: recent
                  .map((mark) => Chip(
                        backgroundColor: _getGradeColor(mark).withOpacity(0.15),
                        label: Text(mark.toStringAsFixed(1),
                            style: TextStyle(color: _getGradeColor(mark))),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    final averages = _mockMarks.values.map((m) => m['average'] as double);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBadge(
                  Icons.emoji_events,
                  'Best',
                  _mockMarks.values
                      .map((m) => m['average'])
                      .reduce((a, b) => a > b ? a : b)
                      .toStringAsFixed(1)),
              _buildStatBadge(
                  Icons.warning,
                  'Needs Attention',
                  _mockMarks.values
                      .map((m) => m['average'])
                      .reduce((a, b) => a < b ? a : b)
                      .toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }

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

  Future<void> _loadSubjects() async {
    dynamic schedule = await fetchSchedule();
    if (schedule is String && schedule.isEmpty) return;
    setState(() {
      subjects = schedule.subjects;
      _generateMockMarks();
    });
  }

  Container _emptySubjectsList() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("You have no subjects",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                Text(
                    "Create some subjects via the schedule page to start tracking marks!",
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        const ScheduleNavigationIntersection()));
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Take me there", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: _buildLoadingContent(),
      );
    }

    if (subjects.isEmpty) return _emptySubjectsList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildStatsHeader()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildSubjectCard(subjects[index]),
              childCount: subjects.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_chart_rounded),
      ),
    );
  }
}
