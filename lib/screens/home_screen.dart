import 'package:flutter/material.dart';
import 'package:todo_app/screens/category_detail_screen.dart';
import '../widgets/category_card.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [
    Task(title: 'Buy groceries'),
    Task(title: 'Walk the dog'),
    Task(title: 'Read a book'),
  ];

  void _addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }

  void _toggleTaskDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskBottomSheet(onAdd: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset is true by default, you can omit this line
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "What's up, Saiful!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                 SizedBox(
  height: 110,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      CategoryCard(
        title: 'Business',
        taskCount: 5,
        color: const Color(0xFF6E8AFA),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoryDetailScreen(categoryName: 'Business'),
            ),
          );
        },
      ),
      CategoryCard(
        title: 'Sport',
        taskCount: 2,
        color: const Color(0xFFFC887B),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoryDetailScreen(categoryName: 'Sport'),
            ),
          );
        },
      ),
      CategoryCard(
        title: 'Music',
        taskCount: 3,
        color: const Color(0xFF5FD1C2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoryDetailScreen(categoryName: 'Music'),
            ),
          );
        },
      ),
    ],
  ),
),

                  const SizedBox(height: 30),
                  Text(
                    "Today's Tasks (${tasks.length})",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Flexible(
                    child: tasks.isEmpty
                        ? const Center(child: Text("No tasks yet!"))
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (ctx, index) => TaskItem(
                              task: tasks[index],
                              onToggle: () => _toggleTaskDone(index),
                              onDelete: () => _deleteTask(index),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskSheet,
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF6E8AFA),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
