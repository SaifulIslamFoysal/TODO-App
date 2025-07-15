import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

// Task Model
class Task {
  final String title;
  bool isDone;

  Task({required this.title, this.isDone = false});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(title: json['title'], isDone: json['isDone']);
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];
  static const String taskStorageKey = 'task_list';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskData = prefs.getString(taskStorageKey);

    if (taskData != null) {
      final List<dynamic> jsonList = jsonDecode(taskData);
      setState(() {
        tasks.clear();
        tasks.addAll(jsonList.map((e) => Task.fromJson(e)));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString =
        jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(taskStorageKey, jsonString);
  }

  void _addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
    _saveTasks();
  }

  void _toggleDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add New Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter task'),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _addTask(value.trim());
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _openCategoryPage(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(categoryName: categoryName),
      ),
    );
  }

  Widget _buildCategoryCard(String title, int count, Color color) {
    return GestureDetector(
      onTap: () => _openCategoryPage(title),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text('$count tasks',
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskSheet,
        backgroundColor: const Color(0xFF6E8AFA),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "What's up, Saiful!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryCard(
                        'Business', 5, const Color(0xFF6E8AFA)),
                    _buildCategoryCard('Sport', 2, const Color(0xFFFC887B)),
                    _buildCategoryCard('Music', 3, const Color(0xFF5FD1C2)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Today's Tasks (${tasks.length})",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(child: Text("No tasks yet!"))
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (ctx, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: Key(task.title + index.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _deleteTask(index),
                            background: Container(
                              padding: const EdgeInsets.only(right: 20),
                              alignment: Alignment.centerRight,
                              color: Colors.redAccent,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _toggleDone(index),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: task.isDone
                                              ? const Color(0xFF6E8AFA)
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        color: task.isDone
                                            ? const Color(0xFF6E8AFA)
                                            : Colors.white,
                                      ),
                                      child: task.isDone
                                          ? const Icon(Icons.check,
                                              size: 16, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      task.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        decoration: task.isDone
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: task.isDone
                                            ? Colors.grey
                                            : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Category Notes Screen
class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  String savedNote = '';

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedNote = prefs.getString(widget.categoryName) ?? '';
    });
  }

  Future<void> _saveNote() async {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.categoryName, note);

    setState(() {
      savedNote = note;
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Notes'),
        backgroundColor: const Color(0xFF6E8AFA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your notes here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E8AFA),
              ),
              child: const Text('Save Note'),
            ),
            const SizedBox(height: 30),
            if (savedNote.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saved Note:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(savedNote),
                ],
              )
          ],
        ),
      ),
    );
  }
}
