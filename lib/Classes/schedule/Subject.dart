import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/teachers.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/main.dart';

class Subject {
  final String name;
  final Teacher teacher;
  final Color color;
  final int id;

  Subject(
      {required this.name,
      required this.teacher,
      required this.color,
      this.id = -1});

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Subject && other.id == id;

  @override
  String toString() => name;

  static Future<Subject> fromJson(Map<String, dynamic> json) async {
    // no factory because of async
    try {
      return Subject(
        name: json["name"],
        teacher: await fetchTeacherByID(json["teacher"]),
        color: Color(int.parse("0x${json["color"]}")),
        id: json["subject_id"],
      );
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  String _getCircleAvatarAbbreviation({int maxLength = 3}) {
    String initials =
        name.split(" ").map((w) => w.isNotEmpty ? w[0] : "").join();
    return initials.substring(0, min(maxLength, initials.length));
  }

  CircleAvatar avatar(BuildContext context) {
    return CircleAvatar(
      // Ensures that the color is opaque
      backgroundColor: color.withValues(alpha: 1.0),
      child: Text(
        _getCircleAvatarAbbreviation(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:
                color.computeLuminance() >= 0.5 ? Colors.black : Colors.white),
      ),
    );
  }
}
