import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_layout.dart';
import 'home.dart';
import 'register.dart';
// LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
  if (_formKey.currentState!.validate()) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeDashboard(),
      ),
    );
  }
}

  void _openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'IT Helpdesk',
      subtitle: 'Your support system, made simple',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sign in to your account',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            const Text('Email Address'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null ||
                    !RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),
            const Text('Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Login'),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _openRegister,
                child: const Text(
                  "Don't have an account? Register",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}