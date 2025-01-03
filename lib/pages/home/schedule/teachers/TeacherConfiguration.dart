import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/teachers.dart';
import 'package:school_mate/Classes/persons/Gender.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/main.dart';

class TeacherConfigurationPage extends StatefulWidget {
  // This page can be used to configure or update a teacher
  final Function(Teacher)? onChange;
  final String mode;
  final Teacher? currentTeacher; // Used for Updating

  // This is a bad way of handling this, but it's hard to rebuild everything because this page was built with only the creation in mind
  const TeacherConfigurationPage(
      {super.key,
      this.onChange,
      this.mode = "C",
      this.currentTeacher}); // Create -> C, Update -> U

  @override
  State<TeacherConfigurationPage> createState() =>
      _TeacherConfigurationPageState();
}

class _TeacherConfigurationPageState extends State<TeacherConfigurationPage> {
  final TextEditingController _teacherNameController = TextEditingController();
  final TextEditingController _teacherAddressController =
      TextEditingController();
  Gender _selectedGender = Gender.male();

  @override
  void initState() {
    _teacherAddressController.text = _selectedGender.address;
    if (widget.currentTeacher != null) {
      setState(() {});
      _teacherNameController.text = widget.currentTeacher!.name;
      _selectedGender = widget.currentTeacher!.gender;
    }
    super.initState();
  }

  @override
  void dispose() {
    _teacherNameController.dispose();
    _teacherAddressController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_teacherNameController.text.isEmpty ||
        _selectedGender.address.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      "Please provide a valid name and form of address for this teacher."),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ));
      return;
    }
    if (widget.mode == "C") {
      final teacher =
          await addTeacher(_teacherNameController.text, _selectedGender);
      logger.i("Added a new teacher");
      if (widget.onChange != null) {
        widget.onChange!(teacher);
      }
    } else if (widget.mode == "U") {
      if (widget.currentTeacher == null) {
        logger.w("Should update a teacher, but no old instance is provided.");
        return;
      }
      final newTeacher = await updateTeacher(
        widget.currentTeacher!,
        // The ID won't change between creation and update
        Teacher(_teacherNameController.text, _selectedGender,
            widget.currentTeacher!.id),
      );
      logger.i("Updated a teacher");
      if (widget.onChange != null) {
        widget.onChange!(newTeacher);
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure a Teacher"),
        leading: const PreviousPage(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _teacherNameController,
              decoration: InputDecoration(
                hintText: "Enter the teacher's name",
                labelText: "Name",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _teacherNameController.text.isNotEmpty
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 1.5,
            ),
            const SizedBox(height: 16),
            Text(
              "Gender",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGenderButton("Male", "M", Colors.green),
                _buildGenderButton("Female", "F", Colors.pink),
                _buildGenderButton("Diverse", "D", Colors.grey),
              ],
            ),
            const SizedBox(height: 24),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 1.5,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _teacherAddressController,
              decoration: InputDecoration(
                hintText: "Enter the form of address",
                labelText: "Form of Address",
                prefixIcon: const Icon(Icons.quick_contacts_mail),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) => setState(() {
                _selectedGender.address = value;
              }),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async => await _onSave(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.save), SizedBox(width: 8), Text("Save")],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, String genderLetter, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() {
          _selectedGender = Gender.fromLetter(genderLetter);
          _teacherAddressController.text = _selectedGender.address;
        }),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedGender.genderLetter == genderLetter
              ? color
              : Colors.grey[300],
          foregroundColor: _selectedGender.genderLetter == genderLetter
              ? Colors.white
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
        ),
        child: Text(label),
      ),
    );
  }
}
