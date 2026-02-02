import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  // PROPERTIES
  final TextEditingController controller;  // Controls the text value
  final String label;                      // Label above the field
  final String? hint;                      // Placeholder text
  final String? errorText;                 // Error message to display
  final bool isRequired;                   // Whether field is required
  final bool obscureText;                  // Hide text (for passwords)
  final int maxLines;                      // Number of lines (1 = single line)
  final int? maxLength;                    // Maximum character length
  final TextInputType keyboardType;        // Type of keyboard to show
  final List<TextInputFormatter>? inputFormatters;  // Input restrictions
  final Widget? prefixIcon;                // Icon at the start
  final Widget? suffixIcon;                // Icon at the end
  final VoidCallback? onTap;               // Called when field is tapped
  final Function(String)? onChanged;       // Called when text changes
  final bool readOnly;                     // Make field read-only

  // ignore: use_super_parameters
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.isRequired = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,  // Align left
      children: [
        // LABEL with optional required indicator (*)
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            children: [
              // Show red asterisk if field is required
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // TEXT FIELD
        TextField(
          controller: controller,
          obscureText: obscureText,        // Hide text for passwords
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          
          // DECORATION (visual styling)
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            
            // ERROR MESSAGE (shown when errorText is not null)
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 12),
            
            // BORDER STYLING
            // Border when field is not focused
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey[300]!,
                width: 1,
              ),
            ),
            // Border when field is focused (user is typing)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null 
                    ? Colors.red 
                    : Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            // Border when there's an error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            
            // PADDING inside the field
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            
            // Fill color (background)
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : Colors.white,
          ),
        ),
      ],
    );
  }
}