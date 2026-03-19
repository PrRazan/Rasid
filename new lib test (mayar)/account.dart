import 'package:flutter/material.dart';
import 'dart:ui';
import 'carInfo.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        body: Stack(
          children: [
            // Background Glows
            Positioned(top: -100, right: -100, child: _buildGlow(const Color(0xFF7FBED1), 300)),
            Positioned(bottom: -100, left: -100, child: _buildGlow(const Color(0xFFBD4A55), 250)),
            
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildProfileImage(),
                  const SizedBox(height: 24),
                  const Text(
                    "رزان العمري",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const Text(
                    "razan.omari@example.com",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildSectionHeader("المعلومات الشخصية"),
                        _buildInfoTile("رقم الجوال", "+966 54 123 4567", Icons.phone_iphone, isLtr: true),
                        _buildInfoTile("رقم الهوية", "1125391345", Icons.badge_outlined),
                        _buildInfoTile("تاريخ الميلاد", "2003 - 12 - 10", Icons.cake_outlined),
                        _buildInfoTile("الجنس", "أنثى", Icons.person_outline),
                        const SizedBox(height: 24),
                        _buildSectionHeader("المركبات المسجلة"),
                        _buildCarTile(context, "تويوتا كامري", "أ ب ت | 1234", "images/carsLogo/Toyota-logo.png", year: "2024", color: "أبيض"),
                        _buildCarTile(context, "فورد تيريتوري", "ج ح خ | 5678", "images/carsLogo/ford-logo.png", year: "2023", color: "أسود"),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildCarTile(BuildContext context, String model, String plate, String logoPath, {String year = "2023", String color = "رمادي"}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarInfoScreen(
            model: model,
            plate: plate,
            logoPath: logoPath,
            year: year,
            color: color,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                logoPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_car, color: Colors.white70),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plate,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
              ),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(24),
                child: const Center(
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                ),
              ),
            ),
            const Expanded(
              child: Text(
                "معلومات الحساب",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const CircleAvatar(
        backgroundColor: Color(0xFF404040),
        child: Icon(Icons.person, size: 80, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon, {bool isLtr = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Directionality(
                textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 100,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
