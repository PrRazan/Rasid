import 'package:flutter/material.dart';
import 'dart:ui';

class CarData {
  final String model;
  final String year;
  final String plate;
  final String logoPath;
  final String chassisNumber;
  final String color;
  final String serialNumber;
  final String lastInspection;

  const CarData({
    required this.model,
    required this.year,
    required this.plate,
    required this.logoPath,
    required this.chassisNumber,
    required this.color,
    required this.serialNumber,
    required this.lastInspection,
  });
}

class CarInfoScreen extends StatefulWidget {
  final String model;
  final String year;
  final String plate;
  final String logoPath;
  final String chassisNumber;
  final String color;
  final String serialNumber;
  final String lastInspection;

  const CarInfoScreen({
    super.key,
    this.model = "يارس",
    this.year = "2023",
    this.plate = "رن ن 9590",
    this.logoPath = "images/carsLogo/Toyota-logo.png",
    this.chassisNumber = "MR2BE9B24P0046276",
    this.color = "رمادي",
    this.serialNumber = "457289013",
    this.lastInspection = "2026 - 1 - 5",
  });

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  late CarData _currentCar;

  final List<CarData> _availableCars = [
    const CarData(
      model: "تويوتا كامري",
      year: "2024",
      plate: "أ ب ت | 1234",
      logoPath: "images/carsLogo/Toyota-logo.png",
      chassisNumber: "MR2BE9B24P0046276",
      color: "أبيض",
      serialNumber: "457289013",
      lastInspection: "2026 - 1 - 5",
    ),
    const CarData(
      model: "فورد تيريتوري",
      year: "2023",
      plate: "ج ح خ | 5678",
      logoPath: "images/carsLogo/ford-logo.png",
      chassisNumber: "FT3CE8A15Q1157387",
      color: "أسود",
      serialNumber: "982173045",
      lastInspection: "2025 - 11 - 20",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentCar = CarData(
      model: widget.model,
      year: widget.year,
      plate: widget.plate,
      logoPath: widget.logoPath,
      chassisNumber: widget.chassisNumber,
      color: widget.color,
      serialNumber: widget.serialNumber,
      lastInspection: widget.lastInspection,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "معلومات السيارة",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<CarData>(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            onSelected: (CarData car) {
              setState(() {
                _currentCar = car;
              });
            },
            color: const Color(0xFF1E1E1E).withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            itemBuilder: (BuildContext context) {
              return _availableCars.map((CarData car) {
                return PopupMenuItem<CarData>(
                  value: car,
                  child: Row(
                    children: [
                      Image.asset(car.logoPath, width: 24, height: 24),
                      const SizedBox(width: 12),
                      Text(
                        car.model,
                        style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات السيارة (Car Info)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  // Centered logo
                  Center(
                    child: Image.asset(
                      _currentCar.logoPath,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.directions_car, size: 60, color: Colors.white24),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _infoItem("الموديل", _currentCar.model),
                      const SizedBox(width: 120),
                      _infoItem("السنة", _currentCar.year),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Car details
            _detailRow("رقم الهيكل", _currentCar.chassisNumber),
            _detailRow("اللون", _currentCar.color),
            _detailRow("رقم اللوحة", _currentCar.plate),
            _detailRow("رقم المركبة التسلسلي", _currentCar.serialNumber),
            _detailRow("تاريخ آخر فحص دوري", _currentCar.lastInspection),

            // License Card with ExpansionTile
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: const Color.fromARGB(80, 255, 255, 255).withOpacity(0.1),
              child: ExpansionTile(
                title: const Text(
                  "رخصة القيادة",
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
                leading: const Icon(Icons.arrow_drop_down),
                children: [
                  _detailRow("رقم الهوية/الإقامة", "1125391345"),
                  _detailRow("الاسم", "رزان العمري"),
                  _detailRow("تاريخ الميلاد", "2003 - 12 - 10"),
                  _detailRow("النوع", "خاص"),
                  _detailRow("تاريخ الانتهاء", "2028 - 7 - 5"),
                  _detailRow("تاريخ الإصدار", "2023 - 1 - 5"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Cairo')),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        ],
      ),
    );
  }
}
