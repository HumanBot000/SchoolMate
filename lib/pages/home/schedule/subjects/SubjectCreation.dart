import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/API/supabase/schedule/teachers.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/pages/home/schedule/teachers/TeachersList.dart';

class SubjectConfigurationPage extends StatefulWidget {
  final String? subjectName;
  final Teacher? teacher;
  final Color? color;
  final Function(String, Teacher, Color)
      onChange; //The Subject class should be built outside, this just returns the raw values

  const SubjectConfigurationPage(
      {super.key,
      this.subjectName,
      this.teacher,
      this.color,
      required this.onChange});

  @override
  State<SubjectConfigurationPage> createState() =>
      _SubjectConfigurationPageState();
}

class _SubjectConfigurationPageState extends State<SubjectConfigurationPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
      const Color(0xFFF2F8FF)
    ],
    [
      const Color(0xFFD53A3A),
      const Color(0xFFD56868),
      const Color(0xFFD59696),
      const Color(0xFFD5C4C4),
      const Color(0xFFFFE5E5)
    ],
    [
      const Color(0xFFD5B63A),
      const Color(0xFFD5C768),
      const Color(0xFFF5D596),
      const Color(0xFFFFE7C4),
      const Color(0xFFFFFBE5)
    ],
    [
      const Color(0xFF3AD53A),
      const Color(0xFF68D568),
      const Color(0xFF96D596),
      const Color(0xFFC4E7C4),
      const Color(0xFFE5FFE5)
    ],
    [
      const Color(0xFF7B3AD5),
      const Color(0xFF9F68D5),
      const Color(0xFFC396D5),
      const Color(0xFFE7C4F5),
      const Color(0xFFFBE5FF)
    ],
    [
      const Color(0xFFD57B3A),
      const Color(0xFFD59F68),
      const Color(0xFFF5C396),
      const Color(0xFFFFE7C4),
      const Color(0xFFFFF2E5)
    ],
    [
      const Color(0xFF3AD5A7),
      const Color(0xFF68D5C3),
      const Color(0xFF96D5E7),
      const Color(0xFFC4F5F5),
      const Color(0x3a7bd5ff)
    ],
  ];

  void _fetchVisualData() {
    // Ensures that the values are re-fetched if the user started a creation but then got navigated back after teacher selection.
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
  void initState() {
    /* navigatorTreeObserver.printHistory(); O my f-cking god... Spent hours just debugging the navigation...
    This isn't reliable when building new routes on top of it, but mainly it's inconsistent, where the navigation is handled.
    But this was so frustrating. I am not going to refactor this now
     */
    _fetchVisualData();
    super.initState();
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    super.dispose();
  }

  Widget _coloredTitleContainer(Color textColor) {
    return Container(
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
                    ? l10n.enterSubjectNameHint
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
    );
  }

  Future<void> _navigateToTeacherSelection() async {
    final teachersList = await fetchTeachers();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TeacherSelector(
          teachers: teachersList,
          onSelect: (teacher) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SubjectConfigurationPage(
                subjectName: _subjectNameController.text,
                teacher: teacher,
                color: _selectedColor,
                onChange: widget.onChange,
              ),
            ));
          }),
    ));
  }

  void _showColorPicker() {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) => setState(() => _selectedColor = color),
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
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                              Navigator.of(context).pop();
                            },
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
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.continueLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          l10n.createSubjectTitle,
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
          _coloredTitleContainer(textColor),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _subjectNameController,
              decoration: InputDecoration(
                hintText: l10n.subjectNameLabel,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.menu_book),
                    const SizedBox(width: 8),
                    Text(l10n.enterSubjectNameInstruction)
                  ],
                ),
                labelStyle: const TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) =>
                  setState(() {}), // ensures live updates to the title
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () async => _navigateToTeacherSelection(),
              child: TextFormField(
                enabled: false,
                controller: _teacherNameController,
                decoration: InputDecoration(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 8),
                      Text(l10n.teacherLabel)
                    ],
                  ),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () => _showColorPicker(),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(_selectedColor),
              ),
              child: Text(l10n.changeColor,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                      )),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_subjectNameController.text.isEmpty ||
                    _selectedTeacher == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              l10n.subjectValidationAlert),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ));
                  return;
                }
                Navigator.of(context).pop();
                widget.onChange.call(
                  _subjectNameController.text,
                  _selectedTeacher!,
                  _selectedColor,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Icon(Icons.save), const SizedBox(width: 8), Text(l10n.save)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
