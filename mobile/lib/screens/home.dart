import 'package:flutter/material.dart';
import 'create.dart';
import 'my_tickets.dart';
import 'track_ticket.dart';
import 'profile.dart';

// =====================================================
// FLUTTER HOME DASHBOARD
// =====================================================

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0F2344);
    const blue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) return;

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyTicketsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
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
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'My Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // NAVY HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: navy,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning, Thabo 👋',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'How can we help you today?',
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // DASHBOARD CONTENT
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // CREATE TICKET
                      _dashboardCard(
                        context,
                        title: 'Create Ticket',
                        subtitle: 'Report a new IT issue',
                        icon: Icons.add_circle_outline,
                        color: blue,
                        isPrimary: true,
                      ),

                      const SizedBox(height: 14),

                      // MY TICKETS
                      _dashboardCard(
                        context,
                        title: 'My Tickets',
                        subtitle: 'View your submitted tickets',
                        icon: Icons.confirmation_number_outlined,
                        color: navy,
                      ),

                      const SizedBox(height: 14),

                      // TRACK TICKET
                      _dashboardCard(
                        context,
                        title: 'Track Ticket',
                        subtitle: 'Check your ticket status',
                        icon: Icons.search,
                        color: navy,
                      ),

                      const SizedBox(height: 26),

                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // EXAMPLE ACTIVITY
                      _activityTile(
                        title: 'Laptop screen flickering',
                        status: 'In Progress',
                        statusColor: Colors.orange,
                      ),

                      const SizedBox(height: 10),

                      _activityTile(
                        title: 'Printer connection issue',
                        status: 'Resolved',
                        statusColor: Colors.green,
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

  // REUSABLE DASHBOARD CARD
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTicketScreen(),
            ),
          );
        } else if (title == 'My Tickets') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyTicketsScreen(),
            ),
          );
        } else if (title == 'Track Ticket') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TrackTicketScreen(),
            ),
          );
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
              color: isPrimary ? Colors.white : blueColor(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isPrimary ? Colors.white : Colors.black87,
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

  Color blueColor() {
    return const Color(0xFF2563EB);
  }

  // RECENT ACTIVITY CARD
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
            color: Color(0xFF2563EB),
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