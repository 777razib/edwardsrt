import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../controllers/note_edit_controller.dart';


class NoteEditorScreen extends StatelessWidget {
  NoteEditorScreen({super.key}) {
    Get.put(NoteEditorController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteEditorController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: Obx(() => Text(
          controller.isEditing.value ? 'Edit Note' : 'Create Note',
        )),
        suffixIcon: Obx(() => Icon(
          controller.isPinned.value ? Icons.push_pin : Icons.push_pin_outlined,
          size: 20,
          color: controller.isPinned.value ? AppColors.primary : Colors.black,
        )),
        onSuffixPressed: () => controller.togglePin(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Content Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.contentController,
                  decoration: const InputDecoration(
                    hintText: 'Start writing your note...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Save Button
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.saveNote(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        controller.isEditing.value ? 'Update Note' : 'Save Note',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}