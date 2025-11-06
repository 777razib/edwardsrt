import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../controllers/notepad_controller.dart';

class NotepadScreen extends StatelessWidget {
  NotepadScreen({super.key}) {
    Get.put(NotepadController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotepadController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Notepad'),
        suffixIcon: const Icon(
          Icons.add,
          size: 20,
          color: Colors.black,
        ),
        onSuffixPressed: () {
          // Navigate to create note screen
          controller.navigateToCreateNote();
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notes.isEmpty) {
          return _buildEmptyState(controller);
        }

        return _buildNotesList(controller);
      }),
    );
  }

  Widget _buildEmptyState(NotepadController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No Notes Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first note to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              controller.navigateToCreateNote();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Create Note',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(NotepadController controller) {
    final groupedNotes = controller.groupedNotes;
    final dates = groupedNotes.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final notes = groupedNotes[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // Notes for this date
            ...notes.map((note) => _buildNoteCard(note, controller)),
            
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildNoteCard(Note note, NotepadController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Content (limited to 2 lines)
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Divider(height: 1, color: Color.fromARGB(255, 197, 195, 195)),
          ),
          
          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date info
                Text(
                  _getDateInfo(note.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                
                // Three dots menu
                GestureDetector(
                  onTap: () => _showNoteOptions(note, controller),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.more_vert,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDateInfo(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(date.year, date.month, date.day);
    
    final dayName = _getDayName(date.weekday);
    final dateStr = '${date.day}/${date.month}/${date.year}';
    
    if (noteDate == today) {
      return 'Today • $dateStr';
    } else if (noteDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday • $dateStr';
    } else {
      return '$dayName • $dateStr';
    }
  }

  String _getDayName(int weekday) {
    const days = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ];
    return days[weekday - 1];
  }

 void _showNoteOptions(Note note, NotepadController controller) {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Option - Updated to use navigation
              _buildOptionItem(
                text: 'Edit Note',
                icon: Icons.edit_outlined,
                onTap: () {
                  Get.back();
                  controller.navigateToEditNote(note); // Use navigation instead
                },
              ),
              
              const Divider(),
              
              // Delete Option
              _buildOptionItem(
                text: 'Delete Note',
                icon: Icons.delete_outline,
                onTap: () {
                  Get.back();
                  _showDeleteConfirmation(note, controller);
                },
                isDelete: true,
              ),
              
              const SizedBox(height: 8),
              
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    bool isDelete = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isDelete ? Colors.red : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        icon,
        color: isDelete ? Colors.red : Colors.grey,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(Note note, NotepadController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteNote(note.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}