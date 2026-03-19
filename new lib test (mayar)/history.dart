import 'package:flutter/material.dart';
import 'dart:ui';
import 'accidents.dart';
import 'malfunctions.dart';
import 'periodic_inspection.dart';

class CarHistory {
  final String model;
  final String year;
  final String plate;
  final String malfunctions;
  final String odometer;
  final String accidents;
  final String inspectionStatus;
  final String ownershipTransfers;
  final String qrCode;

  CarHistory({
    required this.model,
    required this.year,
    required this.plate,
    required this.malfunctions,
    required this.odometer,
    required this.accidents,
    required this.inspectionStatus,
    required this.ownershipTransfers,
    required this.qrCode,
  });
}

final List<CarHistory> userCars = [
  CarHistory(
    model: "تويوتا كامري",
    year: "2024",
    plate: "أ ب ت | 1234",
    malfunctions: "3",
    odometer: "12500",
    accidents: "0",
    inspectionStatus: "سليمة",
    ownershipTransfers: "1",
    qrCode: "TC2024-1234-CAMRY",
  ),
  CarHistory(
    model: "فورد تيريتوري",
    year: "2023",
    plate: "ج ح خ | 5678",
    malfunctions: "1",
    odometer: "8200",
    accidents: "1",
    inspectionStatus: "سليمة",
    ownershipTransfers: "1",
    qrCode: "FT2023-5678-TERR",
  ),
  CarHistory(
    model: "يارس",
    year: "2023",
    plate: "ر ن ن | 9590",
    malfunctions: "5",
    odometer: "45000",
    accidents: "2",
    inspectionStatus: "سليمة",
    ownershipTransfers: "2",
    qrCode: "MR2883022EP00-002370",
  ),
];

class HistoryScreen extends StatefulWidget {
  final bool isToyota;
  const HistoryScreen({super.key, required this.isToyota});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late CarHistory _selectedCar;

  @override
  void initState() {
    super.initState();
    _selectedCar = widget.isToyota ? userCars[0] : userCars[1];
  }

  @override
  void didUpdateWidget(HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isToyota != widget.isToyota) {
      setState(() {
        _selectedCar = widget.isToyota ? userCars[0] : userCars[1];
      });
    }
  }

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
                        MaterialPageRoute(
                          builder: (context) => AccidentsScreen(
                            model: _selectedCar.model,
                            year: _selectedCar.year,
                            plate: _selectedCar.plate,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    "الأعطال", 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MalfunctionsScreen(
                            carModel: _selectedCar.model,
                            carYear: _selectedCar.year,
                            carPlate: _selectedCar.plate,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    "الفحص الدوري", 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PeriodicInspectionScreen(
                            carModel: _selectedCar.model,
                            carYear: _selectedCar.year,
                            carPlate: _selectedCar.plate,
                          ),
                        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "سجل تاريخ المركبة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_selectedCar.model} ${_selectedCar.year} - ${_selectedCar.plate}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
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
              Text(
                _selectedCar.qrCode,
                style: const TextStyle(color: Colors.white54, fontSize: 6),
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
              _buildStatCard("عدد الأعطال", _selectedCar.malfunctions, const Icon(Icons.warning_amber_rounded, color: Colors.white70, size: 24)),
              _buildStatCard("عداد المركبة", _selectedCar.odometer, const Icon(Icons.speed_outlined, color: Colors.white70, size: 24)),
              _buildStatCard(
                "عدد الحوادث", 
                _selectedCar.accidents, 
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
              _buildStatCard("حالة الفحص الدوري", _selectedCar.inspectionStatus, const Icon(Icons.fact_check_outlined, color: Colors.white70, size: 24)),
              const SizedBox(width: 16),
              _buildStatCard("مرات انتقال الملكية", _selectedCar.ownershipTransfers, const Icon(Icons.vpn_key_outlined, color: Colors.white70, size: 24)),
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