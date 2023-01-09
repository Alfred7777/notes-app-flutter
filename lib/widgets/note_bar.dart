import 'package:flutter/material.dart';
import 'package:notes_app/repositories/note_repository.dart';

class NoteBar extends StatelessWidget {
  final int index;
  final Note note;
  final Function(int) onDoubleTap;
  final Function(int) onButtonPressed;
  
  const NoteBar({
    Key? key,
    required this.index,
    required this.note,
    required this.onDoubleTap,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => onDoubleTap(note.id),
      child: Container(
        color: note.state == 0 ? Colors.blue.shade800 : note.state == 1 ? Colors.green.shade800 : Colors.red.shade800,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 6.0,
                      ),
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      note.creationDate,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              note.state != 2 ? Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onButtonPressed(note.id),
                  ),
                ],
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}