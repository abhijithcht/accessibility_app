import 'package:flutter/material.dart';

class JournalProvider extends ChangeNotifier {
  final List<JournalEntry> _entries = [];

  // Getter for entries
  List<JournalEntry> get entries => _entries;

  // Function to add a journal entry
  void addJournal(JournalEntry entry) {
    _entries.add(entry);
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}

class JournalEntry {
  String title;
  String content;
  DateTime date;

  JournalEntry({
    required this.title,
    required this.content,
    required this.date,
  });

  // Convert a JournalEntry object to a JSON string
  String toJsonString() {
    return '{"title": "$title", "content": "$content", "date": "${date.toIso8601String()}"}';
  }
}
