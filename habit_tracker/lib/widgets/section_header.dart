 // ignore_for_file: use_super_parameters

 import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  // PROPERTIES
  final String title;              // Section title (e.g., "Today's Habits")
  final String? subtitle;          // Optional subtitle for additional context
  final String? actionText;        // Optional action button text (e.g., "See All")
  final VoidCallback? onAction;    // Function to call when action is tapped
  final IconData? icon;            // Optional icon before title

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // LEFT SIDE: Icon and title/subtitle
          Expanded(
            child: Row(
              children: [
                // ICON (optional)
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                ],
                
                // TITLE AND SUBTITLE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      // SUBTITLE (optional)
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // RIGHT SIDE: Action button (optional)
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// SIMPLE SECTION DIVIDER
/// 
/// Just a title with divider line, no action button
class SectionDivider extends StatelessWidget {
  final String title;

  const SectionDivider({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // TITLE
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // DIVIDER LINE
          // Expands to fill remaining space
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}