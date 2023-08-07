import 'package:flutter/material.dart';
import 'package:notes_app/resources/app_strings.dart';

class NoteArchiveDialog extends StatelessWidget {
  final int noteID;
  final Function(int) archiveNote;

  const NoteArchiveDialog({
    Key? key,
    required this.noteID,
    required this.archiveNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.kArchiveNote),
      content: const Text(AppStrings.kArchiveNoteQuestion),
      actions: <Widget>[
        TextButton(
          child: Text('Yes', style: TextStyle(color: Colors.grey.shade100)),
          onPressed: () {
            Navigator.of(context).pop();
            archiveNote(noteID);
          },
        ),
        TextButton(
          child: Text('No', style: TextStyle(color: Colors.grey.shade100)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}