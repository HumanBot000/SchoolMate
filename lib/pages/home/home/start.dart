import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Widgets/specialThemes/futuristic.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/home/Widgets/DayProgressBar.dart';
import 'package:school_mate/pages/home/home/Widgets/HomeDrawer.dart';

import 'Widgets/UpcomingHolidaysCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  Schedule? _schedule;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSchedule();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _loadSchedule() async {
    final scheduleData = await fetchSchedule();
    setState(() {
      _schedule = scheduleData != "" ? scheduleData : null;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Widget _buildMainContent() {
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: topPadding + 16,
              bottom: 100,
            ),
            child: Column(
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 20),
                if (_schedule != null && _hasTodayLessons()) ...[
                  _buildEnhancedProgressSection(),
                  const SizedBox(height: 20),
                ],
                if (_schedule == null || !_hasTodayLessons()) ...[
                  _buildNoLessonsCard(),
                  const SizedBox(height: 20),
                ],
                const UpcomingHolidaysCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F36).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wb_sunny_rounded,
            color: Color(0xFF3A7BFF),
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getTimeOfDayGreeting(l10n)}!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.welcomeGreeting,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedProgressSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F36).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DayProgressBar(
          startTime: _getTodayLessons().first.temporalData.startTime,
          endTime: _getTodayLessons().last.temporalData.endTime,
          widgetBuildTime: DateTime.now(),
        ),
      ),
    );
  }

  Widget _buildNoLessonsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F36).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.free_breakfast_rounded,
            color: Color(0xFF00D4AA),
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noClassesToday,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.enjoyFreeTime,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasTodayLessons() {
    if (_schedule == null) return false;
    return _getTodayLessons().isNotEmpty;
  }

  List<dynamic> _getTodayLessons() {
    if (_schedule == null) return [];
    return _schedule!.lessons
        .where((lesson) =>
            (lesson.temporalData.weekday == DateTime.now().weekday) &&
            lesson.temporalData.alternatingWeeks
                .contains(_schedule!.metadata.currentAlternatedWeek))
        .toList();
  }

  String _getTimeOfDayGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      bottomNavigationBar: const HomeNavBar(currentIndex: 0),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            l10n.homeTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          buildGradientBackground(),
          const ParticleBackground(),
          _buildMainContent(),
        ],
      ),
    );
  }
}
