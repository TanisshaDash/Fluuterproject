import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class WeeklyHabitsView extends StatefulWidget {
  const WeeklyHabitsView({super.key});

  @override
  State<WeeklyHabitsView> createState() => _WeeklyHabitsViewState();
}

class _WeeklyHabitsViewState extends State<WeeklyHabitsView> {
  late DateTime currentWeekStart;

  @override
  void initState() {
    super.initState();
    currentWeekStart = _getWeekStart(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWeekHeader(),
        const SizedBox(height: 16),

        /// ✅ FIXED HEIGHT — NO Expanded
        SizedBox(
          height: 450,
          child: _buildWeeklyGrid(),
        ),
      ],
    );
  }

  // ================= HEADER =================

  Widget _buildWeekHeader() {
    final weekEnd = currentWeekStart.add(const Duration(days: 6));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                currentWeekStart =
                    currentWeekStart.subtract(const Duration(days: 7));
              });
            },
          ),
          Column(
            children: [
              const Text(
                'Week View',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatShortDate(currentWeekStart)} - ${_formatShortDate(weekEnd)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                currentWeekStart =
                    currentWeekStart.add(const Duration(days: 7));
              });
            },
          ),
        ],
      ),
    );
  }

  // ================= GRID =================

  Widget _buildWeeklyGrid() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, _) {
        final habits = habitProvider.habits;

        if (habits.isEmpty) {
          return const Center(
            child: Text(
              'No habits yet!',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              final date =
                  currentWeekStart.add(Duration(days: index));
              return _buildDayColumn(date, habits);
            }),
          ),
        );
      },
    );
  }

  // ================= DAY COLUMN =================

  Widget _buildDayColumn(DateTime date, List<Habit> habits) {
    final today = DateTime.now();
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          // Day header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isToday ? Colors.blue[100] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  _getDayName(date.weekday),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.blue[700] : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.blue[700] : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// ✅ FIXED HEIGHT LIST
          SizedBox(
            height: 320,
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return _buildHabitCheckbox(habits[index], date);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= HABIT ITEM =================

  Widget _buildHabitCheckbox(Habit habit, DateTime date) {
    final dateString = _formatDate(date);
    final isCompleted = habit.completedDates.contains(dateString);

    final today = DateTime.now();
    final isFuture =
        date.isAfter(DateTime(today.year, today.month, today.day));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: isCompleted,
        onChanged: isFuture
            ? null
            : (_) => _toggleHabitForDate(habit, date),
        title: Text(
          habit.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            decoration:
                isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  // ================= HELPERS =================

  void _toggleHabitForDate(Habit habit, DateTime date) {
    final dateString = _formatDate(date);
    final updatedDates = List<String>.from(habit.completedDates);

    if (updatedDates.contains(dateString)) {
      updatedDates.remove(dateString);
    } else {
      updatedDates.add(dateString);
    }

    context.read<HabitProvider>().updateHabit(
          habit.copyWith(completedDates: updatedDates),
        );
  }

  DateTime _getWeekStart(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day - (date.weekday - 1),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
