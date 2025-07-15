import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  String savedNote = '';

  void _saveNote() {
    setState(() {
      savedNote = _noteController.text.trim();
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
                  const Text(
                    'Saved Note:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
