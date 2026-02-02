 import 'package:flutter/material.dart';


Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,           // Dialog title (e.g., "Delete Habit?")
  required String message,         // Explanation (e.g., "This action cannot be undone")
  String confirmText = 'Confirm',  // Text for confirm button
  String cancelText = 'Cancel',    // Text for cancel button
  Color? confirmColor,             // Color for confirm button (red for delete)
  IconData? icon,                  // Optional icon to show
}) async {
  // showDialog returns the value passed to Navigator.pop()
  final result = await showDialog<bool>(
    context: context,
    // barrierDismissible: false means clicking outside won't close dialog
    barrierDismissible: true,
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: confirmColor,
      icon: icon,
    ),
  );
  
  // Return false if user dismissed without choosing (tapped outside)
  return result ?? false;
}

/// CONFIRM DIALOG WIDGET
/// 
/// The actual dialog UI
/// This is separated so it can be customized if needed
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;

  // ignore: use_super_parameters
  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.confirmColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // ICON (optional)
      // Shows at the top of the dialog
      icon: icon != null
          ? Icon(
              icon,
              size: 48,
              color: confirmColor ?? Theme.of(context).primaryColor,
            )
          : null,
      
      // TITLE
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // MESSAGE/CONTENT
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
          height: 1.5,  // Line height for readability
        ),
      ),
      
      // ACTION BUTTONS
      actions: [
        // CANCEL BUTTON
        TextButton(
          onPressed: () {
            // Close dialog and return false (not confirmed)
            Navigator.of(context).pop(false);
          },
          child: Text(
            cancelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // CONFIRM BUTTON
        ElevatedButton(
          onPressed: () {
            // Close dialog and return true (confirmed)
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// SPECIALIZED CONFIRMATION DIALOGS
/// Helper functions for common scenarios

/// DELETE CONFIRMATION
/// Pre-configured for delete actions (red button)
Future<bool> showDeleteConfirmation(
  BuildContext context, {
  required String itemName,  // e.g., "Exercise habit"
}) {
  return showConfirmDialog(
    context,
    title: 'Delete $itemName?',
    message: 'This action cannot be undone. Are you sure you want to proceed?',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    confirmColor: Colors.red,
    icon: Icons.delete_outline,
  );
}

/// CLEAR ALL CONFIRMATION
/// For clearing all data
Future<bool> showClearAllConfirmation(
  BuildContext context, {
  required String dataType,  // e.g., "habits", "history"
}) {
  return showConfirmDialog(
    context,
    title: 'Clear All $dataType?',
    message: 'This will permanently delete all your $dataType. This action cannot be undone.',
    confirmText: 'Clear All',
    cancelText: 'Cancel',
    confirmColor: Colors.red,
    icon: Icons.warning_amber_outlined,
  );
}

/// DISCARD CHANGES CONFIRMATION
/// For when user has unsaved changes
Future<bool> showDiscardChangesConfirmation(BuildContext context) {
  return showConfirmDialog(
    context,
    title: 'Discard Changes?',
    message: 'You have unsaved changes. Are you sure you want to leave?',
    confirmText: 'Discard',
    cancelText: 'Keep Editing',
    confirmColor: Colors.orange,
    icon: Icons.info_outline,
  );
}