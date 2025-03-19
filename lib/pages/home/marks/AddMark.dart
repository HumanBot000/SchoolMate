import 'package:flutter/material.dart';
import 'package:school_mate/Widgets/public/MultipleStepPageIndicator.dart';

class AddMarkPage extends StatefulWidget {
  const AddMarkPage({super.key});

  @override
  State<AddMarkPage> createState() => _AddMarkPageState();
}

class _AddMarkPageState extends State<AddMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MultipleStepPageIndicator(
          stepCount: 4,
          currentStep: 2,
          headTitles: ["Subject", "Mark", "Exam Type", "Confirm"],
          backgroundColor: Theme.of(context).colorScheme.surface,
          connectionLineThickness: 4,
          headTitleStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold),
          icons: const [
            Icons.calendar_month_outlined,
            Icons.numbers,
            Icons.percent_sharp,
            Icons.check
          ],
          indicatorColor: Colors.blueGrey,
          waveColor: Colors.blueGrey.shade100,
        ),
      ),
    );
  }
}
