import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
   bool get isLoading => _isLoading;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();  // Update UI to show loading state
    
    try {
      // Load habits from storage
      _habits = await StorageService.loadHabits();
      print('📱 Loaded ${_habits.length} habits from storage');
    } catch (e) {
      print('❌ Error loading habits: $e');
      _habits = [];  // Start with empty list if error
    }
    
    _isLoading = false;
    notifyListeners();  // Update UI with loaded habits
  }

   Future<void> _saveHabits() async {
    await StorageService.saveHabits(_habits);
  }

   void addHabit(Habit habit) {
    _habits.add(habit);
    _saveHabits();      // 💾 AUTO-SAVE!
    notifyListeners();  // IMPORTANT: This tells Flutter to rebuild widgets using this data
  }
  // Toggle habit completion for today
void toggleHabitCompletion(String habitId) {
    // Find the index of the habit with this ID
    final habitIndex = _habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;  // Habit not found, exit early

    final habit = _habits[habitIndex];
    final today = DateTime.now();
    // Create today's date string in format "YYYY-MM-DD" (e.g., "2026-01-29")
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Create a copy of the completed dates list (we don't modify the original)
    List<String> updatedDates = List.from(habit.completedDates);
    
    // Toggle: if already completed today, remove it; otherwise add it
    if (updatedDates.contains(todayString)) {
      updatedDates.remove(todayString);  // Uncheck
    } else {
      updatedDates.add(todayString);      // Check
    }

    // Replace the old habit with an updated version
    // We use copyWith() because habit properties are immutable
    _habits[habitIndex] = habit.copyWith(completedDates: updatedDates);
    _saveHabits();      // 💾 AUTO-SAVE!
    notifyListeners();  // Update the UI
  }
  // Delete a habit
  void deleteHabit(String habitId) {
    _habits.removeWhere((h) => h.id == habitId);
    _saveHabits();      
    notifyListeners();
  }

  // Update a habit
 void updateHabit(Habit updatedHabit) {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      _saveHabits();      // 💾 AUTO-SAVE!
      notifyListeners();  // Update the UI
    }
  }
}