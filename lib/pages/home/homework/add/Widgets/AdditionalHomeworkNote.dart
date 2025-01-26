import 'package:flutter/material.dart';

class AdditionalHomeworkNote extends StatelessWidget {
  final TextEditingController titleController;

  const AdditionalHomeworkNote({super.key, required this.titleController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: 6,
        decoration: InputDecoration(
          label: const Row(
            children: [
              Icon(Icons.edit_note),
              SizedBox(width: 8),
              Text("Additional Note"),
            ],
          ),
          labelStyle: const TextStyle(fontSize: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
