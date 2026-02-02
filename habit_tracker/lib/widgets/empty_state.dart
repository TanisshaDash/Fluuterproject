import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  // PROPERTIES
  final IconData icon;           // Icon to display (e.g., Icons.inbox)
  final String title;            // Main heading (e.g., "No habits yet")
  final String message;          // Descriptive text (e.g., "Tap + to add your first habit")
  final String? actionText;      // Optional button text (e.g., "Get Started")
  final VoidCallback? onAction;  // Function to call when button pressed

  // ignore: use_super_parameters
  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
          children: [
            // ICON
            // Large icon with subtle color
            Icon(
              icon,
              size: 80,
              color: Colors.grey[300],
            ),
            
            const SizedBox(height: 24),
            
            // TITLE
            // Bold, larger text for the main message
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // MESSAGE
            // Smaller, lighter text for additional context
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,  // Line height for better readability
              ),
              textAlign: TextAlign.center,
            ),
            
            // ACTION BUTTON (optional)
            // Only show if actionText and onAction are provided
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
