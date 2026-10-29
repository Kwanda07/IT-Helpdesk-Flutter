import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    const navy = Color(0xFF0F2344);
    const blue = Color(0xFF2563EB);

    final email = user?.email ?? 'No email available';

    final fullName =
        user?.userMetadata?['full_name']?.toString() ??
        user?.userMetadata?['name']?.toString() ??
        'IT Helpdesk User';

    // =====================================================
    // LOGOUT FUNCTION
    // =====================================================

    Future<void> logout() async {
      try {
        // Sign out from Supabase
        await supabase.auth.signOut();

        if (!context.mounted) return;

        // Navigate to Login and remove all previous screens
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have logged out successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),

          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [
              const SizedBox(height: 20),

              // =====================================================
              // PROFILE ICON
              // =====================================================

              const CircleAvatar(
                radius: 48,
                backgroundColor: blue,
                child: Icon(
                  Icons.person,
                  size: 55,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // USER NAME
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),

              const SizedBox(height: 8),

              // USER EMAIL
              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // =====================================================
              // ACCOUNT INFORMATION
              // =====================================================

              const Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),

              const SizedBox(height: 14),

              Card(
                color: Colors.white,
                child: Column(
                  children: [
                    // FULL NAME
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: blue,
                      ),
                      title: const Text('Full Name'),
                      subtitle: Text(fullName),
                    ),

                    const Divider(height: 1),

                    // EMAIL ADDRESS
                    ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                        color: blue,
                      ),
                      title: const Text('Email Address'),
                      subtitle: Text(email),
                    ),

                    const Divider(height: 1),

                    // ACCOUNT STATUS
                    ListTile(
                      leading: const Icon(
                        Icons.verified_user_outlined,
                        color: blue,
                      ),
                      title: const Text('Account Status'),
                      subtitle: Text(
                        user == null ? 'Not signed in' : 'Active',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // =====================================================
              // LOGOUT BUTTON
              // =====================================================

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: user == null ? null : logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}