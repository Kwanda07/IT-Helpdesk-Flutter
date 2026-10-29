import 'package:flutter/material.dart';

class TicketDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailsScreen({
    super.key,
    required this.ticket,
  });

  // Format the date into South African date and time.
  String _formatDate(dynamic value) {
    if (value == null) return 'Not available';

    try {
      final date = DateTime.parse(value.toString())
          .toUtc()
          .add(const Duration(hours: 2));

      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

      final day = date.day;
      final month = months[date.month - 1];
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$day $month $year, $hour:$minute';
    } catch (e) {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0F2344);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _detailCard('Reference Number', ticket['reference_number']),
          _detailCard('Issue Title', ticket['title']),
          _detailCard('Description', ticket['description']),
          _detailCard('Priority', ticket['priority']),
          _detailCard('Status', ticket['status']),
          _detailCard(
            'Date Created',
            _formatDate(ticket['created_at']),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(String label, dynamic value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value?.toString() ?? 'Not available',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}