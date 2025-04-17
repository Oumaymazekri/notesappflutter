import 'package:flutter/material.dart';
import '../components/note_item.dart';
import '../components/note_input_dialog.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [
    {
      'id': '1',
      'content': 'Learn Flutter',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'content': 'Complete the tutorial',
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  TextEditingController noteController = TextEditingController();
  Map<String, dynamic>? editingNote;

  void saveNote() {
    if (noteController.text.trim().isEmpty) return;

    setState(() {
      if (editingNote != null) {
        for (int i = 0; i < notes.length; i++) {
          if (notes[i]['id'] == editingNote!['id']) {
            notes[i] = {
              ...notes[i],
              'content': noteController.text,
              'updatedAt': DateTime.now().toIso8601String(),
            };
            break;
          }
        }
        editingNote = null;
      } else {
        final newNote = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': noteController.text,
          'createdAt': DateTime.now().toIso8601String(),
        };
        notes.insert(0, newNote);
      }
    });

    noteController.clear();
  }

  void deleteNote(String id) {
    setState(() {
      notes.removeWhere((note) => note['id'] == id);
    });
  }

  void editNote(Map<String, dynamic> note) {
    editingNote = note;
    noteController.text = note['content'];
    showNoteDialog();
  }

  void showNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => NoteInputDialog(
        controller: noteController,
        isEditing: editingNote != null,
        onSave: saveNote,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.blue,
            padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    editingNote = null;
                    noteController.clear();
                    showNoteDialog();
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: notes.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return NoteItem(
                        note: notes[index],
                        onEdit: editNote,
                        onDelete: deleteNote,
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No notes yet. Create one!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
