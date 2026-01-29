 import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  // PROPERTIES
  final String? message;      // Optional message to show below spinner
  final double size;          // Size of the spinner (diameter)
  final Color? color;         // Color of the spinner (null = use theme color)

  const LoadingWidget({
    Key? key,
    this.message,
    this.size = 50,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
        children: [
          // CIRCULAR PROGRESS INDICATOR (spinner)
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 4,  // Thickness of the spinner
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
          
          // MESSAGE (optional)
          // Only show if message is provided
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// FULL SCREEN LOADING OVERLAY
/// 
/// Use this to cover the entire screen while loading
/// Prevents user interaction during loading
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // SEMI-TRANSPARENT BLACK BACKGROUND
      // Dims the content behind it
      color: Colors.black.withOpacity(0.5),
      child: LoadingWidget(message: message),
    );
  }
}

/// INLINE LOADING
/// 
/// Small loading indicator for buttons or list items
class InlineLoading extends StatelessWidget {
  final Color? color;
  final double size;

  const InlineLoading({
    Key? key,
    this.color,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}