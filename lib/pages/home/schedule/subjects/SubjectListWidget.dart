import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/API/supabase/schedule/subjects.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectCreation.dart';

class SubjectListWidget extends StatefulWidget {
  final List<Subject> subjects;
  final Function(Subject) onSubjectSelected;
  final bool popAfterSelection;

  const SubjectListWidget(
      {super.key,
      required this.subjects,
      required this.onSubjectSelected,
      this.popAfterSelection = true});

  @override
  State<SubjectListWidget> createState() => _SubjectListWidgetState();
}

class _SubjectListWidgetState extends State<SubjectListWidget> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
            child: Text(
              l10n.noSubjectsCreated,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
        ],
      );

  void _editDeleteDialog(Offset offset, Subject subject) {
    final screenSize = MediaQuery.of(context).size;
    const dialogWidth = 200.0;
    const dialogHeight = 100.0;

    final double maxDx = screenSize.width - dialogWidth - 16.0;
    final double maxDy = screenSize.height - dialogHeight - 16.0;
    final dx = (offset.dx + dialogWidth > screenSize.width
        ? maxDx
        : offset.dx).clamp(16.0, maxDx < 16.0 ? 16.0 : maxDx);
    final dy = (offset.dy + dialogHeight > screenSize.height
        ? maxDy
        : offset.dy).clamp(16.0, maxDy < 16.0 ? 16.0 : maxDy);

    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: dy,
              left: dx,
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
                      label: Text(l10n.edit),
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
                      label: Text(l10n.delete),
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
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 80),
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
                  Container(child: _subjects[index ~/ 2].avatar(context)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_subjects[index ~/ 2].name),
                  ),
                ],
              ),
              onTap: () {
                if (widget.popAfterSelection) {
                  Navigator.of(context).pop();
                }
                widget.onSubjectSelected(_subjects[index ~/ 2]);
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
              tooltip: l10n.addSubjectTooltip,
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
    return Stack(
      children: [
        if (_subjects.isEmpty)
          _emptyPage(context)
        else
          Positioned.fill(child: _existingSubjectSelector()),
        Positioned(
          right: 16,
          bottom: 32,
          child: _addSubjectButton(),
        )
      ],
    );
  }
}
