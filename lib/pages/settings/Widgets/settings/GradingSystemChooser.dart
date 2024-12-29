import 'package:flutter/material.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';

class GradingSystemSettings extends StatelessWidget {
  final Function onChange;

  const GradingSystemSettings({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "What grading system do you use?",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedGradientButton(
                gradient:
                    const LinearGradient(colors: [Colors.black, Colors.red]),
                onPressed: () => onChange("1-6"),
                borderRadius: BorderRadius.circular(24),
                child: const Column(
                  children: [
                    Text("1-6"),
                    Text("1 is the best, 6 is the worst"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedGradientButton(
                gradient:
                    const LinearGradient(colors: [Colors.purple, Colors.pink]),
                onPressed: () => onChange("6-1"),
                borderRadius: BorderRadius.circular(24),
                child: const Column(
                  children: [
                    Text("1-6"),
                    Text("6 is the best, 1 is the worst"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedGradientButton(
                gradient: const LinearGradient(
                    colors: [Colors.cyanAccent, Colors.blue]),
                onPressed: () => onChange("0-15"),
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    Text("0-15",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                            )),
                    Text(
                      "15 is the best, 0 is the worst",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedGradientButton(
                gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.yellow]),
                onPressed: () => onChange("A-F"),
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    Text("A-F",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                            )),
                    Text(
                      "A is the best, F is the worst",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
