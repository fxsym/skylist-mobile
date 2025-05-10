import 'package:flutter/material.dart';
import 'package:skylist_mobile/components/todo_status_card.dart';

class TodoStatusSection extends StatelessWidget {
  final int notStartedCount;
  final int inProgressCount;
  final int completedCount;

  const TodoStatusSection({
    super.key,
    required this.notStartedCount,
    required this.inProgressCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        TodoStatusCard(
          title: 'Not Started',
          count: notStartedCount,
          color: Colors.red.shade400,
          image: 'assets/images/not_started.png', // sesuaikan path asset
        ),
        TodoStatusCard(
          title: 'In Progress',
          count: inProgressCount,
          color: Colors.lightBlue.shade400,
          image: 'assets/images/in_progress.png',
        ),
        TodoStatusCard(
          title: 'Completed',
          count: completedCount,
          color: Colors.green.shade400,
          image: 'assets/images/completed.png',
        ),
      ],
    );
  }
}
