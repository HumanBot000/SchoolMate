import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/lessons.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart'
    as fetch_schedule;
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Widgets/specialThemes/futuristic.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/homework/add/AddHomework.dart';
import 'package:school_mate/pages/home/schedule/lessons/ConfigureLesson.dart';
import 'package:school_mate/pages/home/schedule/page/Widgets/ScheduleGridView.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectsListPage.dart';

class SchedulePage extends StatefulWidget {
  final Schedule schedule;
  final bool showBreaks;
  final Function(TimeOfDay, TimeOfDay, int) onBreakSelection;
  final bool showLessonTapCallback;
  final Function(Lesson, DateTime)? onLessonSelection;
  final bool crossOutPastLessons;
  final List<Homework> homeworks;
  final bool showBottomNavBar;

  const SchedulePage({
    super.key,
    required this.schedule,
    this.showBreaks = false,
    this.onBreakSelection = _defaultBreakSelection,
    this.showLessonTapCallback = true,
    this.onLessonSelection,
    this.crossOutPastLessons = false,
    this.homeworks = const [],
    this.showBottomNavBar = true,
  });

  static void _defaultBreakSelection(
      TimeOfDay start, TimeOfDay end, int weekdays) {}

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildTimeButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D4AA), Color(0xFF3A7BFF)],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4AA).withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              tooltip: l10n.backToPresentTooltip,
              onPressed: () {
                // We need to reset the page because the currentSelectedWeek var is handled internally
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => SchedulePage(
                    schedule: widget.schedule,
                    showLessonTapCallback: widget.showLessonTapCallback,
                    onBreakSelection: widget.onBreakSelection,
                    showBreaks: widget.showBreaks,
                  ),
                ));
              },
              icon: const Icon(
                Icons.access_time_filled_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedScheduleGrid() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1F36).withValues(alpha: 0.3),
              const Color(0xFF2D3561).withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF3A7BFF).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A7BFF).withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ScheduleGridView(
            schedule: widget.schedule,
            onBreakSelection: widget.onBreakSelection,
            showBreaks: widget.showBreaks,
            showLessonTapCallback: widget.showLessonTapCallback,
            callbackForLessonsInPast: false,
            onLessonSelection: widget.onLessonSelection ?? _showEnhancedDialog,
            crossOutLessonsInPast: widget.crossOutPastLessons,
            homeworks: widget.homeworks,
            navBarVisible: widget.showBottomNavBar,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3A7BFF), Color(0xFF00D4AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3A7BFF).withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _handleAddLesson,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEnhancedDialog(Lesson lesson, DateTime time) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Assignment',
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0A0E27),
                      Color(0xFF1A1F36),
                      Color(0xFF2D3561),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFF3A7BFF).withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3A7BFF).withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDialogHeader(),
                      const SizedBox(height: 30),
                      _buildDialogMainButton(lesson, time),
                      const SizedBox(height: 24),
                      _buildDialogCancelButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF3A7BFF).withValues(alpha: 0.4),
                const Color(0xFF3A7BFF).withValues(alpha: 0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3A7BFF).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.assignment_ind_rounded,
            color: Color(0xFF3A7BFF),
            size: 36,
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF3A7BFF), Color(0xFF00D4AA)],
          ).createShader(bounds),
          child: const Text(
            'Add Assignment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 2,
          width: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFF3A7BFF),
                Color(0xFF00D4AA),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogMainButton(Lesson lesson, DateTime time) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3A7BFF).withValues(alpha: 0.2),
            const Color(0xFF00D4AA).withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF3A7BFF).withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A7BFF).withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => AddHomeworkPage(
                schedule: widget.schedule,
                initialDate: time,
                initialSubject: lesson.subject,
              ),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3A7BFF), Color(0xFF00D4AA)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Homework due this lesson',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create assignment for this lesson',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color(0xFF3A7BFF).withValues(alpha: 0.8),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogCancelButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _handleAddLesson() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SubjectList(
        subjects: widget.schedule.subjects,
        onSubjectSelected: (selectedSubject) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonConfigurationPage(
                subject: selectedSubject,
                schedule: widget.schedule,
                onUpdate: (subject, startTime, endTime, weekday,
                    alternatingWeeks, room) async {
                  await addLesson(subject, startTime, endTime, weekday,
                      alternatingWeeks, room);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => FutureBuilder<dynamic>(
                      future: fetch_schedule.fetchSchedule(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          logger.e(snapshot.error);
                          return Scaffold(
                            body: Center(
                                child: Text(
                                    '${l10n.errorPrefix}: ${snapshot.error}')),
                          );
                        } else if (snapshot.connectionState == ConnectionState.done) {
                          final data = snapshot.data;
                          if (data == null) {
                            return const ScheduleSetupPage();
                          }
                          return SchedulePage(schedule: data);
                        } else {
                          return Scaffold(
                            body: Center(child: Text(l10n.noDataAvailable)),
                          );
                        }
                      },
                    ),
                  ));
                },
              ),
            ),
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.showBottomNavBar
          ? HomeNavBar(
              currentIndex: 1,
              key: bottomNavBarKey,
            )
          : null,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        bottom: widget.showBottomNavBar, // Add this line
        child: Stack(
          children: [
            buildGradientBackground(),
            const ParticleBackground(),
            Column(
              children: [
                futuristicAppBar(
                  context,
                  'Schedule',
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  _fadeAnimation,
                  _fadeController,
                  trailing: _buildTimeButton(),
                  showBackButtonInstead: !widget.showBottomNavBar,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.showBottomNavBar ? 0 : 80,
                    ),
                    child: _buildEnhancedScheduleGrid(),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: widget.showBottomNavBar
                  ? MediaQuery.of(context).size.height * 0.00125
                  : 20, // Adjust FAB position
              right: 20,
              child: _buildFloatingActionButton(),
            ),
          ],
        ),
      ),
    );
  }
}
