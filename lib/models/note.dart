import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int id;
  final String title;
  final String content;
  final String creationDate;
  final bool isArchived;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.isArchived,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      creationDate: json['date'],
      isArchived: json['is_archived'],
    );
  }

  factory Note.empty() {
    return const Note(
      id: -1,
      title: '',
      content: '',
      creationDate: '',
      isArchived: false,
    );
  }

  @override
  List<Object> get props => [id, title, content, creationDate, isArchived];
}
