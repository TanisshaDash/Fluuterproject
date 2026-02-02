/// HOME SCREEN (MAIN UI)
/// 
/// This is the main screen users see when they open the app.
/// It displays the list of habits and allows users to add new ones.
/// 
/// WHAT IT DOES:
/// - Shows all habits in a scrollable list
/// - Each habit shows a checkbox, name, description
/// - Has a floating action button (+) to add new habits
/// - Shows a message when no habits exist yet
/// 
/// WHY WE NEED IT:
/// - This is the primary interface for viewing and interacting with habits
/// - Provides easy access to add, complete, and manage habits
/// 
/// STRUCTURE:
/// - HomeScreen: Main widget with the overall page layout
/// - HabitCard: Individual card for each habit (reusable component)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../widgets/widgets.dart';  // Import all our custom widgets!
import 'habit_detail_screen.dart';  // Import the detail screen

/// HOMESCREEN WIDGET
/// This is NOW a StatefulWidget so we can load habits when the screen first appears
/// All state is still managed by HabitProvider
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load habits AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR: Top bar with title
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        elevation: 0,  // No shadow under the app bar
      ),
      
      // BODY: Main content area
      // Consumer<HabitProvider> watches the provider and rebuilds when it changes
      body: Consumer<HabitProvider>(
        // 'builder' is called whenever HabitProvider.notifyListeners() is called
        // habitProvider = the current state of HabitProvider
        builder: (context, habitProvider, child) {
          // LOADING STATE: Show loading indicator while habits are being loaded
          if (habitProvider.isLoading) {
            return const LoadingWidget(message: 'Loading your habits...');
          }
          
          // EMPTY STATE: Show message if no habits exist
          // NOW USING OUR CUSTOM EmptyState WIDGET!
          if (habitProvider.habits.isEmpty) {
            return EmptyState(
              icon: Icons.check_circle_outline,
              title: 'No habits yet!',
              message: 'Start building better habits today.\nTap the + button to create your first habit.',
              actionText: 'Add First Habit',
              onAction: () => _showAddHabitDialog(context),
            );
          }

          // HABIT LIST: Show all habits in a scrollable list
          return ListView.builder(
            itemCount: habitProvider.habits.length,  // Number of items in the list
            padding: const EdgeInsets.all(16),
            // itemBuilder is called once for each habit to build its widget
            itemBuilder: (context, index) {
              final habit = habitProvider.habits[index];
              return HabitCard(habit: habit);  // Create a card for this habit
            },
          );
        },
      ),
      
      // FLOATING ACTION BUTTON: The circular + button at bottom right
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// SHOW ADD HABIT DIALOG
  /// 
  /// Displays a popup dialog where users can enter a new habit's details
  /// NOW USING CustomTextField for better styling and validation!
  /// 
  /// HOW IT WORKS:
  /// 1. Creates text controllers to capture user input
  /// 2. Shows an AlertDialog with custom text fields
  /// 3. When user taps "Add", creates a new Habit and adds it to the provider
  /// 4. Closes the dialog
  void _showAddHabitDialog(BuildContext context) {
    // Text controllers manage the text in the input fields
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        
        // CONTENT: The input fields
        // NOW USING OUR CustomTextField WIDGETS!
        content: Column(
          mainAxisSize: MainAxisSize.min,  // Only take up as much space as needed
          children: [
            // NAME INPUT - Using CustomTextField
            CustomTextField(
              controller: nameController,
              label: 'Habit Name',
              hint: 'e.g., Exercise, Read, Meditate',
              isRequired: true,  // Shows red asterisk
              prefixIcon: const Icon(Icons.label_outline, size: 20),
            ),
            
            const SizedBox(height: 16),  // Spacing between fields
            
            // DESCRIPTION INPUT - Using CustomTextField
            CustomTextField(
              controller: descriptionController,
              label: 'Description',
              hint: 'Add details... (optional)',
              maxLines: 3,  // Allow multiple lines
              prefixIcon: const Icon(Icons.notes, size: 20),
            ),
          ],
        ),
        
        // ACTION BUTTONS: Cancel and Add
        actions: [
          // CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),  // Close dialog
            child: const Text('Cancel'),
          ),
          
          // ADD BUTTON - Using CustomButton
          CustomButton(
            text: 'Add Habit',
            icon: Icons.add,
            onPressed: () {
              // Only add if name is not empty
              if (nameController.text.trim().isNotEmpty) {
                // Create a new Habit object
                final habit = Habit(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),  // Unique ID using timestamp
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null  // Set to null if description is empty
                      : descriptionController.text.trim(),
                  createdAt: DateTime.now(),
                );
                
                // Add the habit to our provider
                // context.read doesn't listen for changes, just performs an action
                context.read<HabitProvider>().addHabit(habit);
                Navigator.pop(context);  // Close the dialog
              }
            },
          ),
        ],
      ),
    );
  }
}

/// HABIT CARD WIDGET
/// 
/// Displays a single habit as a card with:
/// - Checkbox to mark complete/incomplete
/// - Habit name and description
/// - Menu button for options (delete, etc.)
/// 
/// This is a reusable component - we create one for each habit in the list
class HabitCard extends StatelessWidget {
  final Habit habit;  // The habit data to display

  const HabitCard({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if this habit is completed today
    final isCompleted = habit.isCompletedToday();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),  // Space between cards
      child: InkWell(
        // TAP ANYWHERE ON CARD TO VIEW DETAILS
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailScreen(habit: habit),
            ),
          );
        },
        child: ListTile(
          // LEADING: Checkbox on the left side
          leading: Checkbox(
            value: isCompleted,
            onChanged: (_) {
              // When checkbox is tapped, toggle completion status
              context.read<HabitProvider>().toggleHabitCompletion(habit.id);
            },
            shape: const CircleBorder(),  // Make checkbox circular
          ),
          
          // TITLE: Habit name
          title: Text(
            habit.name,
            style: TextStyle(
              // Strike through text if completed
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          // SUBTITLE: Description (only shown if it exists)
          subtitle: habit.description != null
              ? Text(habit.description!)
              : null,  // Don't show subtitle if no description
          
          // TRAILING: Three-dot menu button on the right
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptions(context),
          ),
        ),
      ),
    );
  }

  /// SHOW OPTIONS MENU
  /// 
  /// Displays a bottom sheet with options for this habit
  /// NOW USING showDeleteConfirmation for safer deletion!
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => Wrap(
        children: [
          // DELETE OPTION
          // Now with confirmation dialog!
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              // IMPORTANT: Get provider BEFORE closing bottom sheet
              final provider = context.read<HabitProvider>();
              
              // Close the bottom sheet first
              Navigator.pop(sheetContext);
              
              // Show confirmation dialog using our custom widget!
              final confirmed = await showDeleteConfirmation(
                context,
                itemName: habit.name,
              );
              
              // Only delete if user confirmed
              if (confirmed) {
                provider.deleteHabit(habit.id);
              }
            },
          ),
          // You could add more options here like:
          // - Edit
          // - View Details
          // - Archive
          // - Duplicate
        ],
      ),
    );
  }
}