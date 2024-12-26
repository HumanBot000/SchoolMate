/*
 The default flutter implementation makes no sense. Almost lost my will to live whilst writing this, 4 hours wasted trying to fix this.
 Flutter expects a NavigationBar to be inside an Scaffold which 1. doesn't move the indicator when calling Navigator.pushReplacement() and 2. sometimes raises Stack Overflows.
 I didn't wanted this solution with the index as an argument, but I couldn't find a better way to do it. (after 4 hours!!!)
 I don't know if there is a better way to do this, but if not then I ask me what the devs thought???
 Dev 1:"Add a way to use the custom onDestinationSelected function to have full control over the navigation. Also let's save the currentIndex across rebuilds and page changes because he wraps it in an StateFulWidget anyways."
 Dev 2: "You know what? Just expect him to pass a list of widgets instead of MaterialPageRoutes. So he has to rewrite everything he programmed so far and it will result in really bad code quality"
 Everyone in the meeting: "Give this man a raise!"

 It neither makes any sense, because why would I want this (expect for 20 line example code like in the BottomNavBar Docs)??? nor does it match with the flutter style (from my perspective)

 The Android Studio inbuilt gemini does mistakes on purpose whilst not helping me even 1%.
 It writes extendsStatefulWidget and sometimes seState()???
 Ig somewhere in a system prompt it tells it sound more human...

 I am not very happy about how this worked out, but
 1. I think it's not my fault. There isn't another way, without building or extending BottomNavBar to a custom widget
 2. I want to go to bed (As I said 4 hours!!!)
 3. I don't want to think about this again (I hope google pays my therapy)
  */
import 'package:flutter/material.dart';

import '../home/start.dart';
import '../schedule/start.dart';

class HomeNavBar extends StatefulWidget {
  final int currentIndex;

  const HomeNavBar({super.key, required this.currentIndex});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  late int selectedPage;

  @override
  void initState() {
    super.initState();
    selectedPage = widget.currentIndex;
  }

  void _setSelectedPage(int index) {
    if (index == selectedPage) {
      return;
    }
    setState(() {
      selectedPage = index;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return navigationBarDestinations[index];
    }));
  }

  List<Widget> navigationBarDestinations = [
    const HomePage(),
    const SchedulePage()
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
