import 'package:flutter/material.dart';
import 'package:school_mate/pages/home/home/start.dart';
import 'package:school_mate/pages/home/homework/Homework.dart';
import 'package:school_mate/pages/home/marks/Grades.dart';
import 'package:school_mate/pages/home/schedule/start.dart';

GlobalKey bottomNavBarKey = GlobalKey();

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

  void _setSelectedPage(int index) async {
    if (index == _selectedPage) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedPage = index;
      });
      // Clear nav history
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return navigationBarDestinations[index];
        },
      ));
    });
  }

  final List<Widget> navigationBarDestinations = [
    const HomePage(),
    const ScheduleNavigationIntersection(),
    const HomeworkPage(),
    const MarksPage(),
  ];

  List<NavigationDestination> navigationBarItems(BuildContext context) => [
        NavigationDestination(
          icon: Icon(Icons.home,
              color: _selectedPage == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey),
          label: 'Home',
        ),
        NavigationDestination(
          label: 'Schedule',
          icon: Icon(Icons.calendar_month,
              color: _selectedPage == 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey),
        ),
        NavigationDestination(
          label: 'Homework',
          icon: Icon(Icons.assignment,
              color: _selectedPage == 2
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey),
        ),
        NavigationDestination(
          label: 'Marks',
          icon: Icon(Icons.show_chart,
              color: _selectedPage == 3
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    bottomNavBarKey =
        GlobalKey(); // Ensure it's unique but still accessible from outside
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
