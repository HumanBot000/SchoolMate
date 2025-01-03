import 'package:flutter/material.dart';
import 'package:school_mate/Classes/schedule/Subjects.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectCreation.dart';

class SubjectList extends StatefulWidget {
  final List<Subject> subjects;

  const SubjectList({super.key, required this.subjects});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
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

  Widget _existingSubjectSelector() => ListView.builder(
      itemCount: widget.subjects.length * 2,
      itemBuilder: (context, index) {
        if (index % 2 == 1) {
          return const Divider();
        } else {
          return ListTile(
            title: Text(widget.subjects[index].name),
            onTap: () {
              Navigator.of(context).pop(widget.subjects[index]);
            },
          );
        }
      });

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
          widget.subjects.isEmpty
              ? _emptyPage(context)
              : _existingSubjectSelector(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 16, 32),
              child: IconButton(
                  tooltip: "Add a Subject",
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SubjectCreationPage(),
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
