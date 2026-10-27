import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(const HelpdeskApp());
}

// APP SETTINGS
class HelpdeskApp extends StatelessWidget {
  const HelpdeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT Helpdesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
// =====================================================
// CATEGORY SELECTION SCREEN
// =====================================================

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0F2344);
    const blue = Color(0xFF2563EB);

    final categories = [
      {'name': 'Hardware', 'icon': Icons.computer},
      {'name': 'Software', 'icon': Icons.apps},
      {'name': 'Network', 'icon': Icons.wifi},
      {'name': 'Account Access', 'icon': Icons.lock_outline},
      {'name': 'Other', 'icon': Icons.help_outline},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Select Category'),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),

          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [
              const Text(
                'What type of issue are you experiencing?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Select the category that best describes your problem.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              ...categories.map((category) {
                final name = category['name'] as String;
                final icon = category['icon'] as IconData;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    leading: Icon(
                      icon,
                      color: blue,
                      size: 30,
                    ),

                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                    ),

                    onTap: () {
                      Navigator.pop(context, name);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}




