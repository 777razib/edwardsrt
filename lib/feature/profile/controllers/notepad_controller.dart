import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/note_edit_screen.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
  });
}

class NotepadController extends GetxController {
  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final selectedNoteId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void loadNotes() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      notes.assignAll([
        Note(
          id: '1',
          title: 'Meeting Notes',
          content: 'Discuss the upcoming church event and budget allocation for the community program. Need to finalize the venue and invite guests.',
          createdAt: DateTime.now(),
          isPinned: true,
        ),
        Note(
          id: '2',
          title: 'Sermon Ideas',
          content: 'Theme: Forgiveness and redemption. Key verses: Matthew 6:14-15, Ephesians 4:32. Personal stories to include...',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Note(
          id: '3',
          title: 'Volunteer Schedule',
          content: 'Sunday service volunteers: John - ushering, Sarah - music, Mike - children ministry. Need to confirm availability.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Note(
          id: '4',
          title: 'Bible Study Topics',
          content: 'Next month focus on the Book of Psalms. Weekly breakdown: Week 1 - Psalms of Praise, Week 2 - Psalms of Lament...',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Note(
          id: '5',
          title: 'Church Event Planning',
          content: 'Christmas celebration ideas: Carol singing, nativity play, community dinner. Budget: \$2000. Volunteers needed: 15 people.',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ]);
      isLoading.value = false;
    });
  }

  void navigateToCreateNote() {
    Get.to(() => NoteEditorScreen());
  }

  void navigateToEditNote(Note note) {
    Get.to(
      () => NoteEditorScreen(),
      arguments: {
        'isEditing': true,
        'noteId': note.id,
        'title': note.title,
        'content': note.content,
        'isPinned': note.isPinned,
      },
    );
  }

  // Add this missing method
  void handleNoteSaved(Map<String, dynamic> noteData) {
    if (noteData['isEditing'] == true) {
      // Update existing note
      final index = notes.indexWhere((note) => note.id == noteData['noteId']);
      if (index != -1) {
        notes[index] = Note(
          id: noteData['noteId'],
          title: noteData['title'],
          content: noteData['content'],
          createdAt: notes[index].createdAt, // Keep original creation date
          isPinned: noteData['isPinned'],
        );
      }
    } else {
      // Create new note
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: noteData['title'],
        content: noteData['content'],
        createdAt: DateTime.now(),
        isPinned: noteData['isPinned'],
      );
      notes.insert(0, newNote); // Add to top
    }
  }

  void deleteNote(String noteId) {
    notes.removeWhere((note) => note.id == noteId);
    Get.snackbar(
      'Success',
      'Note deleted successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void editNote(String noteId) {
    selectedNoteId.value = noteId;
    // Navigate to edit screen or show dialog
    Get.snackbar(
      'Edit Note',
      'Edit functionality for note $noteId',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Group notes by date
  Map<String, List<Note>> get groupedNotes {
    final Map<String, List<Note>> grouped = {};
    
    for (final note in notes) {
      final String dateKey = _getDateKey(note.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(note);
    }
    
    return grouped;
  }

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(date.year, date.month, date.day);
    
    if (noteDate == today) {
      return 'Today';
    } else if (noteDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}