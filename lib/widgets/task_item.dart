import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.title), // ✅ Unique key per task
      direction: DismissDirection.endToStart, // ✅ Swipe left to delete
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete(); // ✅ Trigger delete when swiped
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "${task.title}" deleted')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // ✅ Checkbox to toggle done
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: task.isDone ? const Color(0xFF6E8AFA) : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: task.isDone ? const Color(0xFF6E8AFA) : Colors.grey,
                    width: 2,
                  ),
                ),
                child: task.isDone
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            // ✅ Task title
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isDone ? Colors.grey : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
