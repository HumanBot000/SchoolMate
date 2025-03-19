import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/pages/home/marks/AddMark.dart';
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

  void _showAddMarkDialog(double markValue) {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController dateController = TextEditingController(
      text: DateTime.now().toLocal().toString().split(' ')[0],
    );

    ExamType? selectedExamType = widget.marksPerExamType.keys.isNotEmpty
        ? widget.marksPerExamType.keys.first
        : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Add New ${markRepresentation(markValue, widget.gradingSystem)} Mark'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ExamType>(
                  value: selectedExamType,
                  decoration: const InputDecoration(
                    labelText: 'Exam Type',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.marksPerExamType.keys.map((ExamType type) {
                    return DropdownMenuItem<ExamType>(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (ExamType? newValue) {
                    selectedExamType = newValue;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Chapter 3 Test',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      dateController.text = picked.toString().split(' ')[0];
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedExamType != null &&
                    descriptionController.text.isNotEmpty) {
                  // Here you would add the logic to save the mark
                  // Example: SupabaseMarksAPI.addMark(newMark, selectedExamType, widget.subject);

                  // Show a confirmation snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mark added successfully')),
                  );

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDecimalMarkSelector() {
    // For grading systems that support decimal marks
    final int minMark = parseMark(widget.gradingSystem.range[0]).toInt();
    final int maxMark = parseMark(widget.gradingSystem.range[1]).toInt();
    double selectedValue = minMark.toDouble();

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  markRepresentation(selectedValue, widget.gradingSystem),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: getMarkColor(
                          bestMark: minMark,
                          worstMark: maxMark,
                          valueMark: selectedValue,
                          colors: markColors,
                        ),
                      ),
                ),
                ElevatedButton(
                  onPressed: () => _showAddMarkDialog(selectedValue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getMarkColor(
                      bestMark: minMark,
                      worstMark: maxMark,
                      valueMark: selectedValue,
                      colors: markColors,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Slider(
              value: selectedValue,
              min: minMark.toDouble(),
              max: maxMark.toDouble(),
              divisions: (maxMark - minMark) * 10,
              // Allow for decimals (0.1 increments)
              label: markRepresentation(selectedValue, widget.gradingSystem),
              onChanged: (value) {
                setState(() {
                  selectedValue = double.parse(
                      value.toStringAsFixed(1)); // Round to 1 decimal place
                });
              },
              activeColor: getMarkColor(
                bestMark: minMark,
                worstMark: maxMark,
                valueMark: selectedValue,
                colors: markColors,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
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
                            ? Text(
                                "This Exam Group is worth ${examType.evaluationData.multiplicationFactor}x as a child of ${examType.evaluationData.multiplicationChildType?.name}")
                            : Text(
                                "This Exam Group is worth ${examType.evaluationData.percentage}%"),
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
                                            color: getMarkColor(
                                              bestMark: parseMark(widget
                                                      .gradingSystem.range[0])
                                                  .toInt(),
                                              worstMark: parseMark(widget
                                                      .gradingSystem.range[1])
                                                  .toInt(),
                                              valueMark: parseMark(mark.value),
                                              colors: markColors,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: Text(
                                              markRepresentation(
                                                  parseMark(mark.value),
                                                  widget.gradingSystem),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
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

          // Improved "Add a Mark" section
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add a Mark",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                    const SizedBox(height: 12),
                    if (!widget.gradingSystem.modifiers.contains("."))
                      Column(
                        children: List.generate(
                          ((parseMark(widget.gradingSystem.range[1]).toInt() -
                                      parseMark(widget.gradingSystem.range[0])
                                          .toInt() +
                                      1) /
                                  3)
                              .ceil(),
                          (rowIndex) {
                            final startIndex = rowIndex * 3;
                            final endIndex = (rowIndex * 3 + 3).clamp(
                                0,
                                parseMark(widget.gradingSystem.range[1])
                                        .toInt() -
                                    parseMark(widget.gradingSystem.range[0])
                                        .toInt() +
                                    1);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  endIndex - startIndex,
                                  (collumnIndex) {
                                    final index = startIndex + collumnIndex;
                                    final markValue =
                                        parseMark(widget.gradingSystem.range[0])
                                                .toInt() +
                                            index;

                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: collumnIndex < 2 ? 8.0 : 0.0,
                                        ),
                                        child: SizedBox(
                                          height: 60,
                                          child: Material(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            elevation: 2,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddMarkPage(),
                                                ));
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Center(
                                                child: Text(
                                                  markRepresentation(
                                                      markValue.toDouble(),
                                                      widget.gradingSystem),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (widget.gradingSystem.modifiers.contains("."))
                      _buildDecimalMarkSelector(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
