import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notepad_controller.dart';

class NoteEditorController extends GetxController {
  final isEditing = false.obs;
  final isLoading = false.obs;
  final noteId = ''.obs;
  
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final isPinned = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if we're in edit mode and load the note data
    final arguments = Get.arguments;
    if (arguments != null && arguments['isEditing'] == true) {
      isEditing.value = true;
      noteId.value = arguments['noteId'] ?? '';
      _loadNoteData(arguments);
    }
  }

  void _loadNoteData(Map<String, dynamic> arguments) {
    // Simulate loading note data
    titleController.text = arguments['title'] ?? '';
    contentController.text = arguments['content'] ?? '';
    isPinned.value = arguments['isPinned'] ?? false;
  }

// In your NoteEditorController, update the saveNote method:
Future<void> saveNote() async {
  if (titleController.text.trim().isEmpty) {
    Get.snackbar(
      'Error',
      'Please enter a title',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  if (contentController.text.trim().isEmpty) {
    Get.snackbar(
      'Error',
      'Please enter note content',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  isLoading.value = true;

  // Simulate API call
  await Future.delayed(const Duration(seconds: 1));

  isLoading.value = false;

  // Prepare data to send back
  final noteData = {
    'isEditing': isEditing.value,
    'noteId': noteId.value,
    'title': titleController.text.trim(),
    'content': contentController.text.trim(),
    'isPinned': isPinned.value,
  };

  // Notify NotepadController about the saved note
  Get.find<NotepadController>().handleNoteSaved(noteData);

  // Show success message
  Get.snackbar(
    'Success',
    isEditing.value ? 'Note updated successfully' : 'Note created successfully',
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );

  // Navigate back
  Get.back(result: true);
}

  void togglePin() {
    isPinned.value = !isPinned.value;
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}