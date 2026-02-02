import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/confirm_dialog.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          // OPTIONS MENU (edit, delete)
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HABIT INFO CARD
              _buildInfoCard(),
              
              const SizedBox(height: 24),
              
              // STREAK SECTION
              const SectionHeader(title: 'Current Streak'),
              const SizedBox(height: 8),
              _buildStreakCard(),
              
              const SizedBox(height: 24),
              
              // CALENDAR SECTION
              const SectionHeader(title: 'Completion History'),
              const SizedBox(height: 8),
              _buildCalendarSection(),
              
              const SizedBox(height: 24),
              
              // STATISTICS SECTION
              const SectionHeader(title: 'Statistics'),
              const SizedBox(height: 8),
              _buildStatisticsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// HABIT INFO CARD
  /// Shows name, description, created date
  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit name
            Text(
              habit.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Description (if exists)
            if (habit.description != null) ...[
              const SizedBox(height: 8),
              Text(
                habit.description!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Created date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Created ${_formatDate(habit.createdAt)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// STREAK CARD
  /// Shows current streak and best streak
  Widget _buildStreakCard() {
    final currentStreak = _calculateCurrentStreak();
    final bestStreak = _calculateBestStreak();
    
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // CURRENT STREAK
            Column(
              children: [
                const Icon(Icons.local_fire_department, 
                          size: 32, color: Colors.orange),
                const SizedBox(height: 8),
                Text(
                  '$currentStreak',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Current Streak',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            
            // DIVIDER
            Container(
              height: 60,
              width: 1,
              color: Colors.grey[300],
            ),
            
            // BEST STREAK
            Column(
              children: [
                const Icon(Icons.emoji_events, 
                          size: 32, color: Colors.amber),
                const SizedBox(height: 8),
                Text(
                  '$bestStreak',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Best Streak',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// CALENDAR SECTION
  /// Shows the habit calendar
  Widget _buildCalendarSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HabitDetailScreen(habit: habit),
      ),
    );
  }

  /// STATISTICS SECTION
  /// Shows various stats about the habit
  Widget _buildStatisticsSection() {
    final totalDays = _calculateTotalDays();
    final completedDays = habit.completedDates.length;
    final completionRate = totalDays > 0 
        ? (completedDays / totalDays * 100).round() 
        : 0;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatRow('Total Days', '$totalDays'),
            const Divider(),
            _buildStatRow('Completed', '$completedDays'),
            const Divider(),
            _buildStatRow('Completion Rate', '$completionRate%'),
            const Divider(),
            _buildStatRow('This Month', '${_getThisMonthCompletions()}'),
          ],
        ),
      ),
    );
  }

  /// STAT ROW
  /// Single row showing a statistic
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  /// HANDLE MENU ACTIONS
  /// Responds to edit/delete menu selections
  void _handleMenuAction(BuildContext context, String action) async {
    if (action == 'delete') {
      final confirmed = await showDeleteConfirmation(
        context,
        itemName: habit.name,
      );
      
      if (confirmed && context.mounted) {
        context.read<HabitProvider>().deleteHabit(habit.id);
        Navigator.pop(context);  // Go back to previous screen
      }
    } else if (action == 'edit') {
      // TODO: Navigate to edit screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Edit feature coming soon!')),
      );
    }
  }

  /// CALCULATE CURRENT STREAK
  /// Count consecutive days up to today
  int _calculateCurrentStreak() {
    if (habit.completedDates.isEmpty) return 0;
    
    int streak = 0;
    final today = DateTime.now();
    
    // Check backwards from today
    for (int i = 0; i <= 365; i++) {
      final date = today.subtract(Duration(days: i));
      final dateString = _formatDateString(date);
      
      if (habit.completedDates.contains(dateString)) {
        streak++;
      } else {
        break;  // Streak broken
      }
    }
    
    return streak;
  }

  /// CALCULATE BEST STREAK
  /// Find longest consecutive streak in history
  int _calculateBestStreak() {
    if (habit.completedDates.isEmpty) return 0;
    
    // Sort dates
    final sortedDates = habit.completedDates.toList()..sort();
    
    int currentStreak = 1;
    int bestStreak = 1;
    
    for (int i = 1; i < sortedDates.length; i++) {
      final prevDate = DateTime.parse(sortedDates[i - 1]);
      final currDate = DateTime.parse(sortedDates[i]);
      
      // Check if consecutive days
      if (currDate.difference(prevDate).inDays == 1) {
        currentStreak++;
        bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
      } else {
        currentStreak = 1;  // Reset streak
      }
    }
    
    return bestStreak;
  }

  /// CALCULATE TOTAL DAYS
  /// Days since habit was created
  int _calculateTotalDays() {
    final now = DateTime.now();
    return now.difference(habit.createdAt).inDays + 1;
  }

  /// GET THIS MONTH'S COMPLETIONS
  /// Count completions in current month
  int _getThisMonthCompletions() {
    final now = DateTime.now();
    final thisMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    
    return habit.completedDates
        .where((date) => date.startsWith(thisMonth))
        .length;
  }

  /// FORMAT DATE (full)
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// FORMAT DATE STRING (YYYY-MM-DD)
  String _formatDateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// USAGE:
/// 
/// Navigate to this screen from habit list:
/// 
/// onTap: () {
///   Navigator.push(
///     context,
///     MaterialPageRoute(
///       builder: (context) => HabitDetailScreen(habit: habit),
///     ),
///   );
/// }