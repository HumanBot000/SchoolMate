import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:school_mate/pages/home/home/start.dart';
import 'package:school_mate/pages/home/homework/Homework.dart';
import 'package:school_mate/pages/home/marks/Grades.dart';
import 'package:school_mate/pages/home/schedule/start.dart';

final GlobalKey bottomNavBarKey = GlobalKey();

class HomeNavBar extends StatefulWidget {
  final int currentIndex;

  const HomeNavBar({super.key, required this.currentIndex});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  late int _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.currentIndex;
  }

  void _setSelectedPage(int index) {
    if (index == _selectedPage) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedPage = index;
      });
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/schedule');
          break;
        case 2:
          context.go('/homework');
          break;
        case 3:
          context.go('/marks');
          break;
      }
    });
  }

  final List<Widget> navigationBarDestinations = [
    const HomePage(),
    const ScheduleNavigationIntersection(),
    const HomeworkPage(),
    const MarksPage(),
  ];

  List<NavigationDestination> navigationBarItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      NavigationDestination(
        icon: Icon(Icons.home,
            color: _selectedPage == 0
                ? Theme.of(context).colorScheme.primary
                : Colors.grey),
        label: l10n.homeTitle,
      ),
      NavigationDestination(
        label: l10n.scheduleTitle,
        icon: Icon(Icons.calendar_month,
            color: _selectedPage == 1
                ? Theme.of(context).colorScheme.primary
                : Colors.grey),
      ),
      NavigationDestination(
        label: l10n.homeworkTitle,
        icon: Icon(Icons.assignment,
            color: _selectedPage == 2
                ? Theme.of(context).colorScheme.primary
                : Colors.grey),
      ),
      NavigationDestination(
        label: l10n.marksTitle,
        icon: Icon(Icons.show_chart,
            color: _selectedPage == 3
                ? Theme.of(context).colorScheme.primary
                : Colors.grey),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      key: bottomNavBarKey,
      animationDuration: const Duration(milliseconds: 300),
      onDestinationSelected: _setSelectedPage,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: navigationBarItems(context),
      selectedIndex: _selectedPage,
    );
  }
}
