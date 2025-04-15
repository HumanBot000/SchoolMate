import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectListWidget.dart';

class AddMarkSubjectSelector extends StatelessWidget {
  final Function(Subject) onSelection;

  const AddMarkSubjectSelector({super.key, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchSchedule(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data is String && snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No subjects found. Please set them up in the schedule tab first.',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            return Expanded(
              child: SubjectListWidget(
                subjects: snapshot.data!.subjects,
                popAfterSelection: false,
                onSubjectSelected: (selectedSubject) =>
                    onSelection(selectedSubject),
              ),
            );
          }
          return Container();
        });
  }
}
