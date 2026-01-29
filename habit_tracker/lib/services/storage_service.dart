 /// STORAGE SERVICE
/// 
/// Handles saving and loading habit data to/from device storage.
/// Uses shared_preferences to store data as JSON strings.
/// 
/// WHAT IT DOES:
/// - Saves habits to permanent storage
/// - Loads habits when app starts
/// - Persists data between app sessions
/// - Auto-saves whenever data changes
/// 
/// WHY WE NEED IT:
/// - Without this, all data is lost when app closes
/// - Users need their habits to persist
/// - Enables offline functionality
/// 
/// HOW IT WORKS:
/// 1. Converts habits to JSON
/// 2. Stores JSON string in shared_preferences
/// 3. On app start, loads JSON and converts back to Habit objects
/// 
/// PACKAGE NEEDED:
/// Add to pubspec.yaml:
///   shared_preferences: ^2.2.2

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class StorageService {
  // STORAGE KEY
  // This is the identifier used to save/load habits
  static const String _habitsKey = 'habits_list';
  
  /// SAVE HABITS TO STORAGE
  /// 
  /// Takes a list of habits and saves them permanently
  /// Converts each habit to JSON, then saves the entire list
  /// 
  /// HOW IT WORKS:
  /// 1. Get SharedPreferences instance
  /// 2. Convert each Habit to Map using toJson()
  /// 3. Convert list of Maps to JSON string
  /// 4. Save string to storage
  /// 
  /// Example:
  /// await StorageService.saveHabits([habit1, habit2, habit3]);
  static Future<bool> saveHabits(List<Habit> habits) async {
    try {
      // Get the SharedPreferences instance
      // This is the interface to device storage
      final prefs = await SharedPreferences.getInstance();
      
      // Convert each habit to a Map (JSON format)
      final habitsJson = habits.map((habit) => habit.toJson()).toList();
      
      // Convert the list of Maps to a JSON string
      final jsonString = jsonEncode(habitsJson);
      
      // Save the JSON string to storage with our key
      final success = await prefs.setString(_habitsKey, jsonString);
      
      print('✅ Saved ${habits.length} habits to storage');
      return success;
    } catch (e) {
      // If something goes wrong, log the error
      print('❌ Error saving habits: $e');
      return false;
    }
  }
  
  /// LOAD HABITS FROM STORAGE
  /// 
  /// Retrieves saved habits from device storage
  /// Returns empty list if no habits saved yet
  /// 
  /// HOW IT WORKS:
  /// 1. Get SharedPreferences instance
  /// 2. Retrieve JSON string using our key
  /// 3. Convert JSON string to list of Maps
  /// 4. Convert each Map to Habit object
  /// 
  /// Example:
  /// final habits = await StorageService.loadHabits();
  static Future<List<Habit>> loadHabits() async {
    try {
      // Get the SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();
      
      // Get the JSON string from storage
      // Returns null if key doesn't exist (first time app runs)
      final jsonString = prefs.getString(_habitsKey);
      
      // If no data saved yet, return empty list
      if (jsonString == null) {
        print('ℹ️ No saved habits found (first time?)');
        return [];
      }
      
      // Decode JSON string to List<dynamic>
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      // Convert each Map to a Habit object
      final habits = jsonList
          .map((json) => Habit.fromJson(json as Map<String, dynamic>))
          .toList();
      
      print('✅ Loaded ${habits.length} habits from storage');
      return habits;
    } catch (e) {
      // If something goes wrong, log error and return empty list
      print('❌ Error loading habits: $e');
      return [];
    }
  }
  
  /// CLEAR ALL HABITS (for testing or reset feature)
  /// 
  /// Deletes all saved habit data
  /// Use carefully - this is permanent!
  /// 
  /// Example:
  /// await StorageService.clearAllHabits();
  static Future<bool> clearAllHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_habitsKey);
      
      print('✅ Cleared all habits from storage');
      return success;
    } catch (e) {
      print('❌ Error clearing habits: $e');
      return false;
    }
  }
  
  /// CHECK IF HABITS ARE SAVED
  /// 
  /// Returns true if there are habits in storage
  /// Useful for first-time user experience
  /// 
  /// Example:
  /// final hasData = await StorageService.hasStoredHabits();
  static Future<bool> hasStoredHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_habitsKey);
    } catch (e) {
      print('❌ Error checking storage: $e');
      return false;
    }
  }
}

/// USAGE IN YOUR APP:
/// 
/// 1. LOAD HABITS ON APP START (in HabitProvider)
///    Future<void> loadHabits() async {
///      final habits = await StorageService.loadHabits();
///      _habits = habits;
///      notifyListeners();
///    }
/// 
/// 2. SAVE AFTER EVERY CHANGE (in HabitProvider)
///    void addHabit(Habit habit) {
///      _habits.add(habit);
///      StorageService.saveHabits(_habits);  // Auto-save!
///      notifyListeners();
///    }
/// 
/// 3. INITIALIZE ON APP START (in main.dart)
///    void main() async {
///      WidgetsFlutterBinding.ensureInitialized();
///      runApp(const MyApp());
///    }