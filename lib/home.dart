import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'journal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController title;
  late TextEditingController content;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    title = TextEditingController();
    content = TextEditingController();
    _initSharedPreferences();
  }

  // Initialize shared preferences
  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void clearFields() {
    title.clear();
    content.clear();
    Navigator.pop(context);
  }

  void addJournal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Journal',
          style: GoogleFonts.archivoBlack(fontSize: 20),
        ),
        semanticLabel: 'Create a Journal',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: 'Add Journal title here',
              child: TextField(
                controller: title,
                style: GoogleFonts.archivoBlack(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: GoogleFonts.archivoBlack(fontSize: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
            Semantics(
              label: 'Write your Journal here',
              child: TextField(
                controller: content,
                style: GoogleFonts.archivoBlack(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Write here',
                  hintStyle: GoogleFonts.archivoBlack(fontSize: 20),
                  border: InputBorder.none,
                ),
                maxLines: 10,
              ),
            ),
          ],
        ),
        actions: [
          Semantics(
            label: 'Cancel journal',
            child: ElevatedButton(
              onPressed: () {
                clearFields();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.archivoBlack(fontSize: 20),
              ),
            ),
          ),
          Semantics(
            label: 'Save Journal Button',
            child: ElevatedButton(
              onPressed: () {
                // Call the provider function to add the journal entry
                Provider.of<JournalProvider>(context, listen: false).addJournal(
                  JournalEntry(
                    title: title.text,
                    content: content.text,
                    date: DateTime.now(),
                  ),
                );
                _saveToSharedPreferences();
                clearFields();
              },
              child: Text(
                'Save',
                style: GoogleFonts.archivoBlack(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Save data to shared preferences
  Future<void> _saveToSharedPreferences() async {
    // Get the current list of entries from the provider
    List<JournalEntry> entries =
        Provider.of<JournalProvider>(context, listen: false).entries;

    // Convert the list to a format that can be stored in shared preferences
    List<String> entriesStringList =
        entries.map((entry) => entry.toJsonString()).toList();

    // Save the list to shared preferences
    await prefs.setStringList('journal_entries', entriesStringList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'DAYBOOK JOURNAL',
          child: Text(
            'DAYBOOK JOURNAL',
            style: GoogleFonts.archivoBlack(fontSize: 24),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: Semantics(
        label: 'Add new Journal button',
        child: FloatingActionButton(
          onPressed: () {
            addJournal(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      body:
          Consumer<JournalProvider>(builder: (context, journalProvider, child) {
        return ListView.builder(
          itemCount: journalProvider.entries.length,
          itemBuilder: (context, index) {
            String formattedDate =
                DateFormat.yMd().format(journalProvider.entries[index].date);
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Text(journalProvider.entries[index].title),
                title: Text(journalProvider.entries[index].content),
                trailing: Text(formattedDate),
              ),
            );
          },
        );
      }),
    );
  }
}
