import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/pages/home/marks/Utils.dart';
import 'package:school_mate/pages/home/marks/add/AddMark.dart';

import 'MarksOverviewPage.dart';

Widget buildGradingSubjectCard(BuildContext context, Subject subject,
    Map<Subject, double?> averageMarks, GradingSystem gradingSystem) {
  final recent = [10.0];
  final Color gradeColor = getMarkColor(
      bestMark: parseMark(gradingSystem.range[0]).toInt(),
      worstMark: parseMark(gradingSystem.range[1]).toInt(),
      valueMark: averageMarks[subject] ?? 0,
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
                  gradient: averageMarks[subject] == null
                      ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                      : createMarkGradient(
                          bestMark: parseMark(gradingSystem.range[0]).toInt(),
                          worstMark: parseMark(gradingSystem.range[1]).toInt(),
                          valueMark: averageMarks[subject]!,
                          colors: markColors),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  double.tryParse(averageMarks[subject].toString()) != null
                      ? averageMarks[subject]!.toStringAsFixed(2)
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddMarkPage(
                      gradingSystem: gradingSystem,
                      subject: subject,
                    ),
                  ));
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
