import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrackTicketScreen extends StatefulWidget {
  const TrackTicketScreen({super.key});

  @override
  State<TrackTicketScreen> createState() => _TrackTicketScreenState();
}

class _TrackTicketScreenState extends State<TrackTicketScreen> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchTickets() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Please log in to track your tickets.');
    }

    final response = await supabase
        .from('tickets')
        .select('reference_number, title, priority, status, created_at')
        .eq('created_by', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  int _statusStep(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 0;
      case 'in progress':
        return 1;
      case 'resolved':
        return 2;
      case 'closed':
        return 3;
      default:
        return 0;
    }
  }

  Widget _buildProgress(String status) {
    final currentStep = _statusStep(status);

    const stages = [
      'Open',
      'In Progress',
      'Resolved',
      'Closed',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ticket Progress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(stages.length, (index) {
            final completed = index <= currentStep;

            return Expanded(
              child: Column(
                children: [
                  Icon(
                    completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: completed ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stages[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Track Ticket'),
        backgroundColor: const Color(0xFF0F2344),
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
              child: Text(
                'Unable to load tickets: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final tickets = snapshot.data ?? [];

          if (tickets.isEmpty) {
            return const Center(
              child: Text('You have no tickets to track.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];

              final title =
                  ticket['title']?.toString() ?? 'Untitled';

              final reference =
                  ticket['reference_number']?.toString() ?? 'Pending';

              final status =
                  ticket['status']?.toString() ?? 'Open';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(reference),
                      const SizedBox(height: 12),
                      Chip(
                        label: Text(status),
                        backgroundColor: _statusColor(status)
                            .withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                          color: _statusColor(status),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProgress(status),
                    ],
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