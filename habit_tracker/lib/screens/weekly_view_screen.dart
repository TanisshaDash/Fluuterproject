import 'package:flutter/material.dart';
import '../widgets/weekly_habits_view.dart';

class WeeklyViewScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const WeeklyViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly View'),
        elevation: 0,
      ),
      body: const WeeklyHabitsView(),
    );
  }
}