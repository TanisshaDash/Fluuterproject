
/// HABIT CALENDAR WIDGET
/// 
/// Displays a monthly calendar view showing which days a habit was completed.
/// Similar to GitHub's contribution graph.
/// 
/// WHAT IT DOES:
/// - Shows a month calendar grid
/// - Highlights completed days in green
/// - Shows today with a special indicator
/// - Allows tapping dates to mark complete/incomplete
/// 
/// WHY WE NEED IT:
/// - Visual feedback on habit consistency
/// - See patterns and streaks at a glance
/// - Motivates users to maintain streaks
/// 
/// USAGE EXAMPLE:
/// HabitCalendar(
///   habit: myHabit,
///   month: DateTime(2026, 1),
/// )
library;


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitCalendar extends StatefulWidget {
  final Habit habit;
  final DateTime? initialMonth;  // Which month to show (defaults to current month)
  final bool readOnly;           // If true, can't tap to toggle completion

  const HabitCalendar({
    super.key,
    required this.habit,
    this.initialMonth,
    this.readOnly = false,
  });

  @override
  State<HabitCalendar> createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    // Start with provided month or current month
    currentMonth = widget.initialMonth ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // MONTH HEADER with navigation
        _buildMonthHeader(),
        
        const SizedBox(height: 16),
        
        // DAY LABELS (Mon, Tue, Wed, etc.)
        _buildDayLabels(),
        
        const SizedBox(height: 8),
        
        // CALENDAR GRID
        _buildCalendarGrid(),
      ],
    );
  }

  /// MONTH HEADER
  /// Shows current month/year with previous/next buttons
  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // PREVIOUS MONTH BUTTON
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              // Go back one month
              currentMonth = DateTime(
                currentMonth.year,
                currentMonth.month - 1,
              );
            });
          },
        ),
        
        // MONTH AND YEAR LABEL
        Text(
          _getMonthYearString(currentMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // NEXT MONTH BUTTON
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              // Go forward one month
              currentMonth = DateTime(
                currentMonth.year,
                currentMonth.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  /// DAY LABELS ROW
  /// Shows Mon, Tue, Wed, Thu, Fri, Sat, Sun
  Widget _buildDayLabels() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// CALENDAR GRID
  /// Shows all days of the month in a grid
  Widget _buildCalendarGrid() {
    // Get all days for this month
    final days = _getDaysInMonth(currentMonth);
    
    return GridView.builder(
      shrinkWrap: true,  // Don't take infinite height
      physics: const NeverScrollableScrollPhysics(),  // Disable scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,  // 7 days per week
        childAspectRatio: 1,  // Square cells
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        return _buildDayCell(date);
      },
    );
  }

  /// DAY CELL
  /// Individual cell for each day
  Widget _buildDayCell(DateTime? date) {
    // Empty cell (for padding at start/end of month)
    if (date == null) {
      return const SizedBox.shrink();
    }

    final today = DateTime.now();
    final isToday = date.year == today.year && 
                    date.month == today.month && 
                    date.day == today.day;
    
    // Check if this day is completed
    final dateString = _formatDate(date);
    final isCompleted = widget.habit.completedDates.contains(dateString);
    
    // Is this date in the future?
    final isFuture = date.isAfter(today);

    return GestureDetector(
      onTap: widget.readOnly || isFuture 
          ? null 
          : () => _toggleDate(date),
      child: Container(
        decoration: BoxDecoration(
          // Background color based on completion status
          color: isCompleted 
              ? Colors.green[400]
              : (isFuture ? Colors.grey[100] : Colors.grey[200]),
          
          // Border for today
          border: isToday 
              ? Border.all(color: Colors.blue, width: 2)
              : null,
          
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isCompleted 
                  ? Colors.white 
                  : (isFuture ? Colors.grey[400] : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  /// TOGGLE DATE COMPLETION
  /// Marks a date as complete or incomplete
  void _toggleDate(DateTime date) {
    final dateString = _formatDate(date);
    final habit = widget.habit;
    
    // Create updated list of completed dates
    List<String> updatedDates = List.from(habit.completedDates);
    
    if (updatedDates.contains(dateString)) {
      updatedDates.remove(dateString);  // Mark as incomplete
    } else {
      updatedDates.add(dateString);      // Mark as complete
    }
    
    // Update the habit
    final updatedHabit = habit.copyWith(completedDates: updatedDates);
    context.read<HabitProvider>().updateHabit(updatedHabit);
  }

  /// HELPER: Get all days in a month (including padding)
  /// Returns list with nulls for empty cells at start/end
  List<DateTime?> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    
    // Calculate padding needed at start (Monday = 1, Sunday = 7)
    // We want Monday to be index 0, so subtract 1
    int startPadding = firstDay.weekday - 1;
    
    // Build the list
    List<DateTime?> days = [];
    
    // Add padding at start
    for (int i = 0; i < startPadding; i++) {
      days.add(null);
    }
    
    // Add all days of the month
    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(month.year, month.month, day));
    }
    
    return days;
  }

  /// HELPER: Format date as "YYYY-MM-DD"
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// HELPER: Get month/year as string (e.g., "January 2026")
  String _getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.year}';
  }
}

/// COMPACT CALENDAR WIDGET
/// 
/// Smaller version showing just current month
/// Good for habit detail pages
class CompactHabitCalendar extends StatelessWidget {
  final Habit habit;

  const CompactHabitCalendar({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HabitCalendar(
          habit: habit,
          initialMonth: DateTime.now(),
        ),
      ),
    );
  }
}

