// privacy_policy_widget.dart
import 'package:flutter/material.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF3),
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFFFF3),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: October 31, 2025',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'At Linly, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.',
              style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
            ),
            SizedBox(height: 24),

            _SectionTitle(title: '1. Information We Collect'),
            _SectionContent(
              content:
              '• Personal Information: Name, email, and profile details when you create an account.\n'
                  '• Usage Data: Content you view, search history, and interaction patterns.\n'
                  '• Device Information: Device type, OS version, and unique identifiers.\n'
                  '• Location Data: Approximate location (if enabled) to improve recommendations.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '2. How We Use Your Information'),
            _SectionContent(
              content:
              '• To provide and improve our services (personalized content, recommendations).\n'
                  '• To communicate with you (updates, notifications, support).\n'
                  '• To analyze usage and enhance user experience.\n'
                  '• To comply with legal obligations.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '3. Data Sharing'),
            _SectionContent(
              content:
              'We do not sell your personal data. We may share information with:\n'
                  '• Service providers (hosting, analytics, payment processors).\n'
                  '• Legal authorities when required by law.\n'
                  '• In case of merger or acquisition.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '4. Your Rights'),
            _SectionContent(
              content:
              '• Access, update, or delete your personal data.\n'
                  '• Opt out of personalized recommendations.\n'
                  '• Request data export.\n'
                  '• Withdraw consent at any time.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '5. Data Security'),
            _SectionContent(
              content:
              'We use industry-standard encryption and security measures to protect your data. However, no system is 100% secure, and we cannot guarantee absolute security.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '6. Third-Party Links'),
            _SectionContent(
              content:
              'Our app may contain links to third-party websites. We are not responsible for their privacy practices.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '7. Children’s Privacy'),
            _SectionContent(
              content:
              'Linly is not intended for children under 13. We do not knowingly collect data from children.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '8. Changes to This Policy'),
            _SectionContent(
              content:
              'We may update this policy from time to time. We will notify you of significant changes via email or in-app notification.',
            ),

            SizedBox(height: 20),

            _SectionTitle(title: '9. Contact Us'),
            _SectionContent(
              content:
              'If you have questions about this Privacy Policy, contact us at:\n'
                  'Email: privacy@linly.app\n'
                  'Address: Dhaka, Bangladesh',
            ),

            SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                'Linly © 2025. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Section Title
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

// Reusable Section Content
class _SectionContent extends StatelessWidget {
  final String content;
  const _SectionContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 14,
          height: 1.7,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}