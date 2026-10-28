import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchTickets() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Please log in to view your tickets.');
    }

    final response = await supabase
        .from('tickets')
        .select('reference_number, title, priority, status, created_at')
        .eq('created_by', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        backgroundColor: const Color(0xFF102A43),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Unable to load tickets: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final tickets = snapshot.data ?? [];

          if (tickets.isEmpty) {
            return const Center(
              child: Text('You have not submitted any tickets yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];

              final title = ticket['title']?.toString() ?? 'Untitled';
              final reference =
                  ticket['reference_number']?.toString() ?? 'Pending';
              final priority =
                  ticket['priority']?.toString() ?? 'Medium';
              final status = ticket['status']?.toString() ?? 'Open';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.confirmation_number_outlined,
                    color: Color(0xFF102A43),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '$reference\nPriority: $priority',
                  ),
                  isThreeLine: true,
                  trailing: Chip(
                    label: Text(status),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}