
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "الإعدادات", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "المعلومات الشخصية", 
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                items: [
                  _SettingsInfoItem(label: "الاسم", value: "اسم المستخدم", icon: Icons.person_outline),
                  _SettingsInfoItem(label: "رقم الجوال", value: "0500000000", icon: Icons.phone_android),
                  _SettingsInfoItem(label: "البريد الإلكتروني", value: "user@example.com", icon: Icons.mail_outline),
                ]
              ),
              const SizedBox(height: 32),
              const Text(
                "إعدادات الحساب", 
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                items: [
                  _SettingsInfoItem(label: "تغيير كلمة المرور", icon: Icons.lock_outline, showArrow: true),
                  _SettingsInfoItem(label: "اللغة", value: "العربية", icon: Icons.language, showArrow: true),
                ]
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "راصد v1.0.0",
                  style: TextStyle(color: Colors.white12, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<_SettingsInfoItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: Colors.white70, size: 22),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          if (item.value != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.value!, 
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (item.showArrow)
                      const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
                  ],
                ),
              ),
              if (idx < items.length - 1)
                Divider(color: Colors.white.withOpacity(0.05), height: 1, indent: 70),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsInfoItem {
  final String label;
  final String? value;
  final IconData icon;
  final bool showArrow;
  _SettingsInfoItem({required this.label, this.value, required this.icon, this.showArrow = false});
}