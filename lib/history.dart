import 'package:flutter/material.dart';
import 'dart:ui';
import 'accidents.dart';
import 'malfunctions.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            
            const SizedBox(height: 32),
            
            // Stats Section Title
            const Text(
              "أحداث خلال حياة المركبة",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            _buildStatsContainer(),
            
            const SizedBox(height: 48),
            
            // Menu Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildMenuButton(
                    "الحوادث", 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AccidentsScreen()),
                      );
                    },
                  ),
                  _buildMenuButton(
                    "الأعطال", 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MalfunctionsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      decoration: const BoxDecoration(
        color: Color(0xFF607D8B), // Blueish-grey color from image
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Vehicle Info (Left side in image)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "سجل تاريخ المركبة",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 4),
              Text(
                "يارس 2023 - ر ن ن 9590",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          
          // QR Code (Right side in image)
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.qr_code_2, size: 60, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                "MR2883022EP00-002370",
                style: TextStyle(color: Colors.white54, fontSize: 6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          // Row 1: 3 cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard("عدد الأعطال", "5", const Icon(Icons.warning_amber_rounded, color: Colors.white70, size: 24)),
              _buildStatCard("عداد المركبة", "0000", const Icon(Icons.speed_outlined, color: Colors.white70, size: 24)),
              _buildStatCard(
                "عدد الحوادث", 
                "2", 
                SizedBox(
                  width: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Left car - tilted up
                      Transform.translate(
                        offset: const Offset(-7, 2),
                        child: Transform.rotate(
                          angle: 0.15,
                          child: const Icon(Icons.directions_car, color: Colors.white70, size: 16),
                        ),
                      ),
                      // Right car - tilted up and flipped
                      Transform.translate(
                        offset: const Offset(7, 2),
                        child: Transform.rotate(
                          angle: -0.15,
                          child: Transform.flip(
                            flipX: true,
                            child: const Icon(Icons.directions_car, color: Colors.white70, size: 16),
                          ),
                        ),
                      ),
                      // Collision lines (sparks)
                      Positioned(
                        top: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.rotate(
                              angle: -0.4,
                              child: Container(width: 1.5, height: 5, decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(1))),
                            ),
                            const SizedBox(width: 3),
                            Container(width: 1.5, height: 7, decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(1))),
                            const SizedBox(width: 3),
                            Transform.rotate(
                              angle: 0.4,
                              child: Container(width: 1.5, height: 5, decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(1))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: 2 cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard("حالة الفحص الدوري", "سليمة", const Icon(Icons.fact_check_outlined, color: Colors.white70, size: 24)),
              const SizedBox(width: 16),
              _buildStatCard("مرات انتقال الملكية", "2", const Icon(Icons.vpn_key_outlined, color: Colors.white70, size: 24)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Widget icon) {
    return Container(
      width: 85,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24, child: Center(child: icon)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey, 
              fontSize: 8, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo'
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text on the right
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            // Arrow on the left pointing left
            const Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
