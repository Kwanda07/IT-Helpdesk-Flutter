import 'package:flutter/material.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0F2344);

    final categories = [
      'Hardware',
      'Software',
      'Network',
      'Account Access',
      'Other',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Select Category'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1),
        itemBuilder: (context, index) {
          final category = categories[index];

          return ListTile(
            title: Text(category),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context, category);
            },
          );
        },
      ),
    );
  }
}