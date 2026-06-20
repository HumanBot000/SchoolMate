import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/API/supabase/schedule/teachers.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/schedule/teachers/TeacherConfiguration.dart';

class TeacherSelector extends StatefulWidget {
  final List<Teacher> teachers;
  final Function(Teacher?) onSelect;

  const TeacherSelector(
      {super.key, required this.teachers, required this.onSelect});

  @override
  State<TeacherSelector> createState() => _TeacherSelectorState();
}

class _TeacherSelectorState extends State<TeacherSelector> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late List<Teacher> _teachers = [];

  @override
  void initState() {
    super.initState();
    _teachers = widget.teachers;
  }

  Widget _emptyPage(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school,
                  size: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey.shade400),
            ],
          ),
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Text(
              l10n.noTeachersSetup,
              // Configure is probably more suitable for persons instead of create or add :)
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
        ],
      );

  void _editDeleteDialog(Offset offset, Teacher teacher) {
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TeacherConfigurationPage(
                            mode: "U",
                            currentTeacher: teacher,
                            onChange: (teacher) async {
                              final updatedTeachers = await fetchTeachers();
                              setState(() {
                                _teachers = updatedTeachers;
                              });
                              widget.onSelect(null);
                            },
                          ),
                        ));
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(l10n.edit),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        logger.i("Deleting teacher ${teacher.name}");
                        await deleteTeacher(teacher);
                        // Update the list
                        setState(() {
                          _teachers.remove(teacher);
                        });
                        widget.onSelect(null);
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

  Widget _existingTeacherSelector() => ListView.builder(
        itemCount: _teachers.length * 2 - 1,
        itemBuilder: (context, index) {
          if (index % 2 == 1) {
            return const Divider();
          } else {
            return GestureDetector(
              onLongPressStart: (details) {
                _editDeleteDialog(
                    details.globalPosition, _teachers[index ~/ 2]);
              },
              child: ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.person),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_teachers[index ~/ 2].name),
                    ),
                  ],
                ),
                onTap: () {
                  widget.onSelect(_teachers[index ~/ 2]);
                },
              ),
            );
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n.selectTeacher,
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle
                  ?.copyWith(overflow: TextOverflow.visible, fontSize: 20)),
          leading: const PreviousPage()),
      body: Stack(
        children: [
          _teachers.isEmpty ? _emptyPage(context) : _existingTeacherSelector(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 16, 32),
              child: IconButton(
                  tooltip: l10n.configureTeacher,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TeacherConfigurationPage(
                          onChange: (teacher) async {
                            widget.onSelect(teacher);
                          },
                        ),
                      )),
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
          ),
        ],
      ),
    );
  }
}
