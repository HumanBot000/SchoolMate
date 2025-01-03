import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:school_mate/API/supabase/schedule/teachers.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/pages/home/schedule/teachers/TeachersList.dart';

class SubjectCreationPage extends StatefulWidget {
  final String? subjectName;
  final Teacher? teacher;
  final Color? color;

  const SubjectCreationPage(
      {super.key, this.subjectName, this.teacher, this.color});

  @override
  State<SubjectCreationPage> createState() => _SubjectCreationPageState();
}

class _SubjectCreationPageState extends State<SubjectCreationPage> {
  Color _selectedColor = const Color(0xFF3A7BD5);
  Teacher? _selectedTeacher;
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _teacherNameController =
      TextEditingController(); // This is just to manipulate the content later. Don't read from this controller, the field is always disabled
  final List<List<Color>> _blockSelectColors = [
    [
      const Color(0xFF3A7BD5),
      const Color(0xFF689FD5),
      const Color(0xFF96C3D5),
      const Color(0xFFC4E7F5),
      const Color(0xFFF2F8FF),
    ],
    [
      const Color(0xFFD53A3A),
      const Color(0xFFD56868),
      const Color(0xFFD59696),
      const Color(0xFFD5C4C4),
      const Color(0xFFFFE5E5),
    ],
    [
      const Color(0xFFD5B63A),
      const Color(0xFFD5C768),
      const Color(0xFFF5D596),
      const Color(0xFFFFE7C4),
      const Color(0xFFFFFBE5),
    ],
    [
      const Color(0xFF3AD53A),
      const Color(0xFF68D568),
      const Color(0xFF96D596),
      const Color(0xFFC4E7C4),
      const Color(0xFFE5FFE5),
    ],
    [
      const Color(0xFF7B3AD5),
      const Color(0xFF9F68D5),
      const Color(0xFFC396D5),
      const Color(0xFFE7C4F5),
      const Color(0xFFFBE5FF),
    ],
    [
      const Color(0xFFD57B3A),
      const Color(0xFFD59F68),
      const Color(0xFFF5C396),
      const Color(0xFFFFE7C4),
      const Color(0xFFFFF2E5),
    ],
    [
      const Color(0xFF3AD5A7),
      const Color(0xFF68D5C3),
      const Color(0xFF96D5E7),
      const Color(0xFFC4F5F5),
      const Color(0xFFE5FFFF),
    ],
  ];

  @override
  void initState() {
    /* navigatorTreeObserver.printHistory(); O my f-cking god... Spent hours just debugging the navigation...
    This isn't reliable when building new routes on top of it, but mainly it's inconsistent, where the navigation is handled.
    But this was so frustrating. I am not going to refactor this now

     */
    // Ensures that the values are re-fetched if the user started a creation but then got navigated back after teacher selection.
    super.initState();
    if (widget.subjectName != null) {
      _subjectNameController.text = widget.subjectName!;
    }
    if (widget.color != null) {
      setState(() {
        _selectedColor = widget.color!;
      });
    }
    if (widget.teacher != null) {
      _teacherNameController.text =
          "${widget.teacher!.gender.address} ${widget.teacher!.name}";
      setState(() {
        _selectedTeacher = widget.teacher!;
      });
    }
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The UI features an always readable text, no matter the background
    bool isDark = _selectedColor.computeLuminance() < 0.5;
    Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Create a Subject",
          style: TextStyle(color: textColor),
        ),
        leading: PreviousPage(
          iconColor: textColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            color: _selectedColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _subjectNameController.text.isEmpty
                          ? "Enter Subject Name"
                          : _subjectNameController.text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.menu_book,
                        color: textColor,
                        size: 32,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _subjectNameController,
              decoration: InputDecoration(
                hintText: "Subject Name",
                label: const Row(
                  children: [
                    Icon(Icons.menu_book),
                    Text("Enter the name of the subject")
                  ],
                ),
                labelStyle: const TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () async {
                final teachersList = await fetchTeachers();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TeacherSelector(
                      teachers: teachersList,
                      onSelect: (teacher) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SubjectCreationPage(
                            subjectName: _subjectNameController.text,
                            teacher: teacher,
                            color: _selectedColor,
                          ),
                        ));
                      }),
                ));
              },
              child: TextFormField(
                enabled: false,
                controller: _teacherNameController,
                decoration: InputDecoration(
                  label: const Row(
                    children: [Icon(Icons.person), Text("Teacher")],
                  ),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorPicker(
                      pickerColor: _selectedColor,
                      onColorChanged: (color) =>
                          setState(() => _selectedColor = color),
                    ),
                    const SizedBox(height: 16),
                    Table(
                      children: [
                        for (var row in _blockSelectColors)
                          TableRow(
                            children: [
                              for (var color in row)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedColor = color),
                                    // Ensure that color's aren't shown in inverse because of default dark theme
                                    child: Theme(
                                      data: ThemeData.light(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: color,
                                        ),
                                        height: 32,
                                        width: 32,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(_selectedColor),
            ),
            child: Text("Change Color",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                    )),
          )
        ],
      ),
    );
  }
}
