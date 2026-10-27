import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // NAVY HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(
                            24, 65, 24, 65,
                          ),
                          color: AppColors.navy,
                          child: Column(
                            children: [
                              if (showBackButton)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.support_agent,
                                  color: Colors.white,
                                  size: 38,
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // WHITE CONTENT SECTION
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            transform: Matrix4.translationValues(
                              0, -25, 0,
                            ),
                            padding: const EdgeInsets.fromLTRB(
                              24, 32, 24, 24,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                child,

                                const Spacer(),

                                const SizedBox(height: 36),

                                const Text(
                                  'For Staff & Departmental Support',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
