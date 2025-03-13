import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/ShimmerEffectForSkeletonLoader.dart';
import 'package:school_mate/pages/home/schedule/start.dart';

class MarksOverviewPage extends StatefulWidget {
  final GradingSystem gradingSystem;

  const MarksOverviewPage({super.key, required this.gradingSystem});

  @override
  State<MarksOverviewPage> createState() => _MarksOverviewPageState();
}

List<Color> markColors = [
  const Color(0xFF00C000),
  const Color(0xFFBDBD00),
  const Color(0xFFFFC000),
  const Color(0xFFFF6400),
  const Color(0xFFB00000),
];

class _MarksOverviewPageState extends State<MarksOverviewPage> {
  List<Subject> _subjects = [];
  Map<Subject, List<Mark>> _marks = {};
  Map<Subject, double?> _averageMarks = {};
  final List<String> _studyTips = [
    "Break study sessions into 25-minute chunks with 5-minute breaks ⏳",
    "Teach concepts to a friend to reinforce your understanding 👩🏫",
    "Create colorful mind maps for visual learning 🎨",
    "Use the Pomodoro technique for focused productivity 🍅",
    "Test yourself with flashcards for active recall 🗂️",
    "Study in natural light to reduce eye strain and boost mood ☀️",
    "Record voice notes of key ideas to listen while walking 🎧",
    "Start with the hardest task when your energy is highest 💪",
    "Organize notes with color-coded highlighters 🌈",
    "Stretch every 30 minutes to improve circulation 🧘♂️",
    "Keep a water bottle nearby to stay hydrated and focused 💧",
    "Use website blockers to minimize digital distractions 🚫",
    "Review notes for 15 minutes before bed for better retention 🌙",
    "Create a lo-fi study playlist to maintain concentration 🎶",
    "Practice past exams under timed conditions ⏱️",
    "Use mnemonics like 'ROYGBIV' for memorization 🧠",
    "Snack on brain foods like nuts and blueberries 🫐",
    "Declutter your workspace for mental clarity 🧹",
    "Reward yourself with a small treat after milestones 🎉",
    "Schedule weekly goals and celebrate progress 📆",
  ];

  final List<String> _motivationalQuotes = [
    "Progress over perfection 🌱",
    "You don’t have to be great to start – just start 💫",
    "Every page turned is a step closer to mastery 📖",
    "Mistakes are proof you’re growing 🌻",
    "Your pace is valid – comparison steals joy 🐢⚡",
    "Resting is part of the journey, not quitting 💤",
    "The expert was once a curious beginner 🔍",
    "Small efforts compound into big results 🧱",
    "Courage is quiet persistence, not loud perfection 🦁",
    "You’ve survived 100% of your toughest days 💯",
    "Learning is planting seeds for tomorrow’s forest 🌳",
    "Your brain grows stronger with every challenge 💪🧠",
    "The best time to start was yesterday. The next best time is now 🕒",
    "You’re not failing – you’re discovering what works 🔄",
    "Curiosity is the compass to wisdom 🧭",
    "Your potential is an ocean – dive in 🌊",
    "One chapter at a time writes the story 📝",
    "Burnout isn’t a badge of honor – balance is key ⚖️",
    "You’re building wings while learning to fly 🦅",
    "Today’s effort is tomorrow’s foundation 🏗️",
  ];
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
    Map<Subject, List<Mark>> marks =
        await fetchMarksBySubjects(onlyConsiderated: true);
    Map<Subject, double?> averageMarks = await calculateAverageMarksBySubjects(
        schedule.subjects,
        onlyConsiderated: true);
    setState(() {
      _subjects = schedule.subjects;
      _marks = marks;
      _averageMarks = averageMarks;
    });
  }

  Future<void> _load() async {
    await _loadData();
    setState(() {
      _isLoading = false;
      _showSkeleton = false;
    });
  }

  Color getGradeColor({
    required int bestMark,
    required int worstMark,
    required double? valueMark,
    required List<Color> colors,
  }) {
    if (valueMark == null || int.tryParse(valueMark.toString()) == 0) {
      return Colors.grey;
    }
    int markRange = worstMark - bestMark;
    int colorSteps = colors.length - 1;

    if (markRange <= 0 || colors.isEmpty) {
      throw ArgumentError("Invalid range or empty color list.");
    }

    // 0 = bestMark, 1 = worstMark
    double normalizedValue = (valueMark - bestMark) / markRange;
    normalizedValue = normalizedValue.clamp(0.0, 1.0);

    int colorIndex = (normalizedValue * colorSteps).round();

    return colors[colorIndex.clamp(0, colorSteps)];
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
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
                  _studyTips[Random().nextInt(_studyTips.length)],
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
                    _motivationalQuotes[
                        Random().nextInt(_motivationalQuotes.length)],
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

  Widget _buildSubjectCard(Subject subject) {
    final recent = [10.0];
    //todo
    final Color gradeColor = getGradeColor(
        bestMark: int.parse(widget.gradingSystem.range[0]),
        worstMark: int.parse(widget.gradingSystem.range[1]),
        valueMark: _averageMarks[subject] ?? 0,
        colors: markColors);

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
                    gradient: _averageMarks[subject] == null
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.grey])
                        : createMarkGradient(
                            bestMark: int.parse(widget.gradingSystem.range[0]),
                            worstMark: int.parse(widget.gradingSystem.range[1]),
                            valueMark: _averageMarks[subject]!,
                            colors: markColors),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    double.tryParse(_averageMarks[subject].toString()) != null
                        ? _averageMarks[subject]!.toStringAsFixed(2)
                        : 'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
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
                        backgroundColor: gradeColor.withValues(alpha: 0.15),
                        label: Text(mark.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white)),
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
                  ))),
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

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    ShimmerEffect(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShimmerEffect(
                        child: Container(
                          height: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    ShimmerEffect(
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerEffect(
                      child: Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                    ),
                    ShimmerEffect(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ShimmerEffect(
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ShimmerEffect(
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _showSkeleton) {
      return Scaffold(
        body: _buildSkeletonLoader(),
      );
    }

    if (_isLoading) {
      return Scaffold(
        body: _buildLoadingContent(),
      );
    }

    if (_subjects.isEmpty) return _emptySubjectsList();

    return Scaffold(
        body: Stack(
      children: [
        ListView.builder(
          itemCount: _subjects.length,
          itemBuilder: (context, index) => _buildSubjectCard(_subjects[index]),
        ),
        FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_chart_rounded),
        ),
      ],
    ));
  }
}
