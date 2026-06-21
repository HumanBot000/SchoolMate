import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';

class AdditionalHomeworkNote extends StatelessWidget {
  final TextEditingController noteController;

  const AdditionalHomeworkNote({super.key, required this.noteController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: noteController,
        maxLines: 6,
        decoration: InputDecoration(
          label: Row(
            children: [
              const Icon(Icons.edit_note),
              const SizedBox(width: 8),
              Text(l10n.additionalNote),
            ],
          ),
          labelStyle: const TextStyle(fontSize: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
