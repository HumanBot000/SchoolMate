import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/pages/home/marks/MarkSelection.dart';
import 'package:school_mate/pages/home/marks/add/AddMark.dart';
import 'package:school_mate/pages/home/marks/overview/MarksOverviewPage.dart';
import 'package:school_mate/util/dates.dart';

class SubjectMarksInspectionPage extends StatefulWidget {
  final Subject subject;
  final double? overallAverage;
  final Map<ExamType, double?> examTypeAverages;
  final Map<ExamType, List<Mark>> marksPerExamType;
  final GradingSystem gradingSystem;

  const SubjectMarksInspectionPage({
    super.key,
    required this.subject,
    required this.overallAverage,
    required this.examTypeAverages,
    required this.marksPerExamType,
    required this.gradingSystem,
  });

  @override
  State<SubjectMarksInspectionPage> createState() =>
      _SubjectMarksInspectionPageState();
}

class _SubjectMarksInspectionPageState
    extends State<SubjectMarksInspectionPage> {
  bool _isDark = false;
  List<int> extendedCards = [];
  final Set<int> _showAllMarksIndices = {};

  @override
  void initState() {
    super.initState();
    _isDark = (widget.overallAverage != null
                ? createMarkGradient(
                    bestMark: parseMark(widget.gradingSystem.range[0]).toInt(),
                    worstMark: parseMark(widget.gradingSystem.range[1]).toInt(),
                    valueMark: widget.overallAverage ?? 0,
                    colors: markColors)
                : LinearGradient(
                    colors: [Colors.grey.shade600, Colors.grey.shade900]))
            .colors
            .first
            .computeLuminance() <
        0.5;
  }

  List<Mark> _getSortedMarks(int index) {
    List<Mark> marks =
        List.from(widget.marksPerExamType.values.toList()[index]);
    marks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return marks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PreviousPage(),
        title: Text(widget.subject.name),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.overallAverage != null
                  ? createMarkGradient(
                      bestMark:
                          parseMark(widget.gradingSystem.range[0]).toInt(),
                      worstMark:
                          parseMark(widget.gradingSystem.range[1]).toInt(),
                      valueMark: widget.overallAverage ?? 0,
                      colors: markColors)
                  : LinearGradient(
                      colors: [Colors.grey.shade600, Colors.grey.shade900]),
            ),
            child: Center(
              child: Text(widget.overallAverage?.toStringAsFixed(2) ?? "N/A",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isDark ? Colors.white : Colors.grey[850],
                      )),
            ),
          ),
          ListView.builder(
              itemCount: widget.marksPerExamType.keys.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final examType = widget.examTypeAverages.keys.toList()[index];
                final marks = _getSortedMarks(index);
                final showAll = _showAllMarksIndices.contains(index);
                final displayedMarks = showAll ? marks : marks.take(6).toList();
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(examType.name),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: widget.examTypeAverages.values
                                              .toList()[index] !=
                                          null
                                      ? createMarkGradient(
                                          bestMark: parseMark(
                                                  widget.gradingSystem.range[0])
                                              .toInt(),
                                          worstMark: parseMark(
                                                  widget.gradingSystem.range[1])
                                              .toInt(),
                                          valueMark: widget
                                              .examTypeAverages.values
                                              .toList()[index]!,
                                          colors: markColors)
                                      : LinearGradient(colors: [
                                          Colors.grey.shade600,
                                          Colors.grey.shade900
                                        ]),
                                ),
                                child: Center(
                                  child: Text(
                                      widget.examTypeAverages.values
                                              .toList()[index]
                                              ?.toStringAsFixed(2) ??
                                          "N/A",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _isDark
                                                ? Colors.white
                                                : Colors.grey[850],
                                          )),
                                ),
                              ),
                              IconButton(
                                icon: Icon(extendedCards.contains(index)
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                onPressed: () {
                                  setState(() {
                                    if (extendedCards.contains(index)) {
                                      extendedCards.remove(index);
                                    } else {
                                      extendedCards.add(index);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        subtitle: examType.evaluationData.percentage == null
                            ? examType.evaluationData.multiplicationChildType ==
                                    null
                                ? const Text("This is the default Exam Type")
                                : Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                            text:
                                                "Every exam in this group is worth "),
                                        TextSpan(
                                          text:
                                              "${examType.evaluationData.multiplicationFactor}x",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                            text: " as much as a exam of the "),
                                        TextSpan(
                                          text: examType
                                                  .evaluationData
                                                  .multiplicationChildType
                                                  ?.name ??
                                              "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(text: " type"),
                                      ],
                                    ),
                                  )
                            : Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: "This Exam Group is worth "),
                                    TextSpan(
                                      text:
                                          "${examType.evaluationData.percentage}%",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      if (extendedCards.contains(index))
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              //todo onTap
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                children: displayedMarks.map((mark) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: mark.color,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Center(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  mark.toDisplayString(),
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        mark.description,
                                      ),
                                      Text(
                                        "${getVisualTimeTillDate(mark.createdAt, DateTime.now())[0]} ${getVisualTimeTillDate(mark.createdAt, DateTime.now())[1]} ago",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                              if (marks.length > 6)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (showAll) {
                                        _showAllMarksIndices.remove(index);
                                      } else {
                                        _showAllMarksIndices.add(index);
                                      }
                                    });
                                  },
                                  child:
                                      Text(showAll ? 'Show less' : 'Show more'),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }),
          MarkSelector(
              gradingSystem: widget.gradingSystem,
              onMarkSelected: (selectedMark) =>
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddMarkPage(
                      gradingSystem: widget.gradingSystem,
                      mark: selectedMark,
                      subject: widget.subject,
                    ),
                  )))
        ],
      ),
    );
  }
}
