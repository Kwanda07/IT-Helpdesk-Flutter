import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'create.dart';
import 'my_tickets.dart';
import 'track_ticket.dart';
import 'profile.dart';

// =====================================================
// FLUTTER HOME DASHBOARD
// =====================================================

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final supabase = Supabase.instance.client;

  static const navy = Color(0xFF0F2344);
  static const blue = Color(0xFF2563EB);

  // =====================================================
  // DYNAMIC GREETING
  // =====================================================

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // =====================================================
  // GET LOGGED-IN USER NAME FROM SUPABASE
  // =====================================================

  String getUserName() {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return 'User';
    }

    final metadata = user.userMetadata;

    final name = metadata?['full_name'] ??
        metadata?['name'] ??
        user.email?.split('@').first ??
        'User';

    final firstName = name.toString().trim().split(' ').first;

    return firstName.isEmpty ? 'User' : firstName;
  }

  // =====================================================
  // FETCH RECENT TICKETS FROM SUPABASE
  // =====================================================

  Future<List<Map<String, dynamic>>> _fetchRecentTickets() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    final response = await supabase
        .from('tickets')
        .select(
          'id, reference_number, title, status, created_at',
        )
        .eq('created_by', user.id)
        .order('created_at', ascending: false)
        .limit(5);

    return List<Map<String, dynamic>>.from(response);
  }

  // =====================================================
  // STATUS COLOURS
  // =====================================================

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

  // =====================================================
  // OPEN ANOTHER SCREEN AND REFRESH WHEN RETURNING
  // =====================================================

  Future<void> _openScreen(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // =====================================================
  // DASHBOARD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) return;

          if (index == 1) {
            _openScreen(const MyTicketsScreen());
          } else if (index == 2) {
            _openScreen(const ProfileScreen());
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'My Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),

      // =====================================================
      // MAIN BODY
      // =====================================================

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // =====================================================
                // NAVY HEADER WITH DYNAMIC GREETING
                // =====================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: navy,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getGreeting()}, ${getUserName()} 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'How can we help you today?',
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // =====================================================
                // DASHBOARD CONTENT
                // =====================================================

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // =====================================================
                      // CREATE TICKET
                      // =====================================================

                      _dashboardCard(
                        context,
                        title: 'Create Ticket',
                        subtitle: 'Report a new IT issue',
                        icon: Icons.add_circle_outline,
                        color: blue,
                        isPrimary: true,
                      ),

                      const SizedBox(height: 14),

                      // =====================================================
                      // MY TICKETS
                      // =====================================================

                      _dashboardCard(
                        context,
                        title: 'My Tickets',
                        subtitle: 'View your submitted tickets',
                        icon: Icons.confirmation_number_outlined,
                        color: navy,
                      ),

                      const SizedBox(height: 14),

                      // =====================================================
                      // TRACK TICKET
                      // =====================================================

                      _dashboardCard(
                        context,
                        title: 'Track Ticket',
                        subtitle: 'Check your ticket status',
                        icon: Icons.search,
                        color: navy,
                      ),

                      const SizedBox(height: 26),

                      // =====================================================
                      // RECENT ACTIVITY HEADING
                      // =====================================================

                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // =====================================================
                      // REAL RECENT ACTIVITY FROM SUPABASE
                      // =====================================================

                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchRecentTickets(),
                        builder: (context, snapshot) {
                          // LOADING
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          // ERROR
                          if (snapshot.hasError) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Unable to load recent activity.',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }

                          final tickets = snapshot.data ?? [];

                          // NO TICKETS
                          if (tickets.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No recent activity yet. '
                                'Create a ticket to get started.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }

                          // DISPLAY RECENT TICKETS
                          return Column(
                            children: tickets.map((ticket) {
                              final title =
                                  ticket['title']?.toString() ??
                                      'Untitled Ticket';

                              final status =
                                  ticket['status']?.toString() ??
                                      'Open';

                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10),
                                child: _activityTile(
                                  title: title,
                                  status: status,
                                  statusColor: _statusColor(status),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // REUSABLE DASHBOARD CARD
  // =====================================================

  Widget _dashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: () {
        if (title == 'Create Ticket') {
          _openScreen(const CreateTicketScreen());
        } else if (title == 'My Tickets') {
          _openScreen(const MyTicketsScreen());
        } else if (title == 'Track Ticket') {
          _openScreen(const TrackTicketScreen());
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isPrimary ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isPrimary
              ? null
              : Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: isPrimary ? Colors.white : blue,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isPrimary
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isPrimary
                          ? Colors.white70
                          : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: isPrimary ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // RECENT ACTIVITY CARD
  // =====================================================

  Widget _activityTile({
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.confirmation_number_outlined,
            color: blue,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}