import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // PROPERTIES
  final String text;              // Button text to display
  final VoidCallback? onPressed;  // Function to call when pressed (null = disabled)
  final IconData? icon;           // Optional icon to show before text
  final bool isLoading;           // Show loading spinner instead of text
  final Color? backgroundColor;   // Custom background color (null = use theme color)
  final Color? textColor;         // Custom text color (null = white)

  const CustomButton({
    Key? key,
    required this.text,           // Text is required
    this.onPressed,               // Optional - button disabled if null
    this.icon,                    // Optional icon
    this.isLoading = false,       // Default: not loading
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // ONPRESSED
      // If loading, disable button (set to null)
      // Otherwise use the provided onPressed callback
      onPressed: isLoading ? null : onPressed,
      
      // STYLE
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),  // Rounded corners
        ),
        elevation: 2,  // Shadow depth
      ),
      
      // CHILD (content of the button)
      child: isLoading
          // LOADING STATE: Show circular spinner
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          // NORMAL STATE: Show icon and text
          : Row(
              mainAxisSize: MainAxisSize.min,  // Only take up space needed
              children: [
                // Show icon if provided
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),  // Space between icon and text
                ],
                // Button text
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}