import 'package:flutter/material.dart';

import '../../Widgets/home/UpcomingHolidaysCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0x003a7bff),
      ),
      body: const Stack(children: [
        Align(alignment: Alignment.bottomCenter, child: UpcomingHolidaysCard()),
      ]),
    );
  }
}
