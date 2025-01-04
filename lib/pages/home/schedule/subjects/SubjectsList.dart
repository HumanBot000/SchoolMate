import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/subjects.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectCreation.dart';

class SubjectList extends StatefulWidget {
  final List<Subject> subjects;

  const SubjectList({super.key, required this.subjects});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  late List<Subject> _subjects;

  @override
  void initState() {
    super.initState();
    _subjects = widget.subjects;
  }

  Widget _emptyPage(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book,
                  size: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey.shade400),
            ],
          ),
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: const Text(
              "You haven't created any subjects yet",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
        ],
      );

  void _editDeleteDialog(Offset offset, Subject subject) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: offset.dy,
              left: offset.dx,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        logger.d(
                            "Set color to ${subject.color.r * 255} ${subject.color.g * 255} ${subject.color.b * 255} ${subject.color.a * 255}");
                        // After success it gets popped
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SubjectConfigurationPage(
                            onChange: (name, teacher, color) async {
                              final updatedSubject = await editSubject(
                                  subject,
                                  Subject(
                                      name: name,
                                      teacher: teacher,
                                      color: color));
                              setState(() {
                                _subjects.remove(subject);
                                _subjects.add(updatedSubject);
                              });
                            },
                            color: subject.color,
                            teacher: subject.teacher,
                            subjectName: subject.name,
                          ),
                        ));
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await deleteSubject(subject);
                        setState(() {
                          _subjects.remove(subject);
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _existingSubjectSelector() => ListView.builder(
      itemCount: _subjects.length * 2 - 1,
      itemBuilder: (context, index) {
        if (index % 2 == 1) {
          return const Divider();
        } else {
          return GestureDetector(
            onLongPressStart: (details) {
              _editDeleteDialog(details.globalPosition, _subjects[index ~/ 2]);
            },
            child: ListTile(
              title: Row(
                children: [
                  Container(child: _subjects[index ~/ 2].avatar()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_subjects[index ~/ 2].name),
                  ),
                ],
              ),
              onTap: () {
                //todo
                Navigator.of(context).pop();
              },
            ),
          );
        }
      });

  Widget _addSubjectButton() => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 16, 32),
          child: IconButton(
              tooltip: "Add a Subject",
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SubjectConfigurationPage(
                        onChange: (name, teacher, color) async {
                          logger.i("Created a new subject");
                          final newSubject = await createSubject(Subject(
                              name: name, teacher: teacher, color: color));
                          setState(() {
                            _subjects.add(newSubject);
                          });
                        },
                      ))),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              iconSize: 30,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Select a subject to add to the schedule",
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle
                  ?.copyWith(overflow: TextOverflow.visible, fontSize: 20)),
          leading: const PreviousPage()),
      body: Stack(
        children: [
          _subjects.isEmpty ? _emptyPage(context) : _existingSubjectSelector(),
          _addSubjectButton()
        ],
      ),
    );
  }
}
