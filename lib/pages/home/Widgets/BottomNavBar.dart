import 'package:app/pages/home/schedule/schedule.dart';
import 'package:flutter/material.dart';

import '../home/start.dart';

class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int selectedPage = 0;

  void _setSelectedPage(int index) {
    if (index == selectedPage) {
      return;
    }
    setState(() {
      selectedPage = index;
    });
    Navigator.of(context).push(navigationBarDestinations[index]);
  }

  List<MaterialPageRoute> navigationBarDestinations = [
    MaterialPageRoute(builder: (context) => const HomePage()),
    MaterialPageRoute(builder: (context) => const SchedulePage()),
  ];

  List<NavigationDestination> navigationBarItems(BuildContext context) => [
        NavigationDestination(
          icon: Icon(Icons.home,
              color: selectedPage == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey),
          label: 'Home',
        ),
        NavigationDestination(
            label: 'Schedule',
            icon: Icon(Icons.calendar_month,
                color: selectedPage == 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey)),
      ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: const Duration(milliseconds: 300),
      onDestinationSelected: _setSelectedPage,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: navigationBarItems(context),
      selectedIndex: selectedPage,
    );
  }
}
