import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'category.dart';

// =====================================================
// CREATE TICKET SCREEN
// =====================================================

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() =>
      _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedPriority;

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // =====================================================
  // SUBMIT TICKET TO SUPABASE
  // =====================================================

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please log in before creating a ticket.',
          ),
        ),
      );
      return;
    }

    final categoryIds = {
      'Hardware': 1,
      'Software': 2,
      'Network': 3,
      'Account Access': 4,
      'Email': 5,
      'Other': 6,
    };

    try {
      await supabase.from('tickets').insert({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category_id': categoryIds[_selectedCategory],
        'priority': _selectedPriority,
        'created_by': user.id,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on PostgrestException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Database error: ${error.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit ticket: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================
  // BUILD SCREEN
  // =====================================================

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0F2344);
    const blue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: Colors.white,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Create Ticket',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              // FIX: Automatically update validation errors
              // when users correct their information.
              autovalidateMode:
                  AutovalidateMode.onUserInteraction,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // =====================================================
                  // CATEGORY
                  // =====================================================

                  const Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  FormField<String>(
                    initialValue: _selectedCategory,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },

                    builder: (field) {
                      return InkWell(
                        onTap: () async {
                          final selected =
                              await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CategorySelectionScreen(),
                            ),
                          );

                          if (!mounted) return;

                          if (selected != null) {
                            setState(() {
                              _selectedCategory = selected;
                            });

                            // Update category field validation.
                            field.didChange(selected);
                          }
                        },

                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            errorText: field.errorText,
                            suffixIcon:
                                const Icon(Icons.chevron_right),
                          ),

                          child: Text(
                            field.value ?? 'Select Category',
                            style: TextStyle(
                              color: field.value == null
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // PRIORITY
                  // =====================================================

                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedPriority,

                    decoration: const InputDecoration(
                      hintText: 'Select Priority',
                      border: OutlineInputBorder(),
                    ),

                    items: _priorities.map((priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    },

                    validator: (value) {
                      if (value == null) {
                        return 'Please select a priority';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // ISSUE TITLE
                  // =====================================================

                  const Text(
                    'Issue Title',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _titleController,

                    decoration: const InputDecoration(
                      hintText: 'Enter issue title',
                      border: OutlineInputBorder(),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter an issue title';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // DESCRIPTION
                  // =====================================================

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,

                    decoration: const InputDecoration(
                      hintText: 'Describe your issue in detail',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please describe the issue';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // =====================================================
                  // SUBMIT BUTTON
                  // =====================================================

                  SizedBox(
                    height: 50,

                    child: ElevatedButton(
                      onPressed: _submitTicket,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),

                      child: const Text(
                        'Submit Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: blue,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Profile screen is coming soon.',
                ),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}