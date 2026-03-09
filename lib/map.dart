import 'dart:ui';
import 'package:flutter/material.dart';

class Workshop {
  final String name;
  final String distance;
  final String rating;

  Workshop({required this.name, required this.distance, required this.rating});
}

enum ServiceType { maintenance, inspection }

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Workshop? _selectedWorkshop;
  bool _isDropdownOpen = false;
  ServiceType _selectedService = ServiceType.maintenance;

  final List<Workshop> _maintenanceCenters = [
    Workshop(name: 'مركز بترومين الرياض', distance: '3.2 كم', rating: '★★★★☆'),
    Workshop(
      name: 'ورشة العضيب لصيانة السيارات',
      distance: '5.7 كم',
      rating: '★★★★★',
    ),
    Workshop(
      name: 'مركز صيانة الرمال الحديثة',
      distance: '1.5 كم',
      rating: '★★★☆☆',
    ),
    Workshop(name: 'المركز الفني بجدة', distance: '8.4 كم', rating: '★★★★☆'),
    Workshop(
      name: 'مركز الناغي لصيانة الـ BMW',
      distance: '12.1 كم',
      rating: '★★★★★',
    ),
  ];

  final List<Workshop> _inspectionCenters = [
    Workshop(
      name: 'مركز الفحص الدوري - الرياض',
      distance: '2.1 كم',
      rating: '★★★★☆',
    ),
    Workshop(
      name: 'الفحص الدوري - الرمال',
      distance: '4.3 كم',
      rating: '★★★★★',
    ),
    Workshop(
      name: 'مركز الفحص الدوري - الشفا',
      distance: '6.0 كم',
      rating: '★★★☆☆',
    ),
    Workshop(
      name: 'محطة الفحص الدوري - جدة',
      distance: '9.5 كم',
      rating: '★★★★☆',
    ),
  ];

  List<Workshop> get _currentCenters =>
      _selectedService == ServiceType.maintenance
      ? _maintenanceCenters
      : _inspectionCenters;

  String get _dropdownHint => _selectedService == ServiceType.maintenance
      ? 'اختر مركز صيانة'
      : 'اختر مركز فحص دوري';

  String get _headerTitle => _selectedService == ServiceType.maintenance
      ? 'مراكز الصيانة المعتمدة'
      : 'مراكز الفحص الدوري المعتمدة';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        body: Stack(
          children: [
            Positioned(
              top: 100,
              left: -50,
              child: _buildGlow(const Color(0xFF7FBED1), 200),
            ),
            Positioned(
              bottom: 100,
              right: -50,
              child: _buildGlow(const Color(0xFFBD4A55), 180),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildCustomCapsuleHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildServiceSwitcher(),
                          const SizedBox(height: 16),
                          _buildGlassDropdown(),
                          if (_isDropdownOpen) _buildGlassDropdownList(),
                          const SizedBox(height: 16),
                          _buildGlassInfoCard(),
                          const SizedBox(height: 24),
                          _buildGlassMapView(),
                        ],
                      ),
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

  Widget _buildCustomCapsuleHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Row(
          children: [
            const SizedBox(width: 48), // keeps the title centered
            Expanded(
              child: Text(
                _headerTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(width: 48), // balance the layout
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSwitchItem(
              title: 'الفحص الدوري',
              isSelected: _selectedService == ServiceType.inspection,
              onTap: () {
                setState(() {
                  _selectedService = ServiceType.inspection;
                  _selectedWorkshop = null;
                  _isDropdownOpen = false;
                });
              },
            ),
          ),
          Expanded(
            child: _buildSwitchItem(
              title: 'الصيانة',
              isSelected: _selectedService == ServiceType.maintenance,
              onTap: () {
                setState(() {
                  _selectedService = ServiceType.maintenance;
                  _selectedWorkshop = null;
                  _isDropdownOpen = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3A3A3A) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? Colors.white.withOpacity(0.14)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown() {
    return GestureDetector(
      onTap: () => setState(() => _isDropdownOpen = !_isDropdownOpen),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedWorkshop?.name ?? _dropdownHint,
                  style: TextStyle(
                    color: _selectedWorkshop != null
                        ? Colors.white
                        : Colors.white54,
                    fontSize: 14,
                    fontWeight: _selectedWorkshop != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontFamily: 'Cairo',
                  ),
                ),
                Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdownList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _currentCenters.length,
              itemBuilder: (context, index) {
                final ws = _currentCenters[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedWorkshop = ws;
                      _isDropdownOpen = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index != _currentCenters.length - 1
                            ? BorderSide(color: Colors.white.withOpacity(0.05))
                            : BorderSide.none,
                      ),
                    ),
                    child: Text(
                      ws.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassInfoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            children: [
              _infoRow(
                _selectedService == ServiceType.maintenance
                    ? "اسم المركز"
                    : "اسم محطة الفحص",
                _selectedWorkshop?.name ?? "-",
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.05), height: 1),
              const SizedBox(height: 12),
              _infoRow("المسافة", _selectedWorkshop?.distance ?? "-"),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.05), height: 1),
              const SizedBox(height: 12),
              _infoRow(
                "التقييم",
                _selectedWorkshop?.rating ?? "-",
                valueColor: Colors.amberAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassMapView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: MapPainter())),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _selectedWorkshop != null
                          ? const Color(0xFFBD4A55)
                          : Colors.white38,
                      size: 48,
                      shadows: [
                        if (_selectedWorkshop != null)
                          BoxShadow(
                            color: const Color(0xFFBD4A55).withOpacity(0.5),
                            blurRadius: 15,
                          ).toShadow(),
                      ],
                    ),
                    Container(
                      width: 24,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(
          "$label : ",
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.white,
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
            color: color.withOpacity(0.08),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on BoxShadow {
  Shadow toShadow() {
    return Shadow(color: color, blurRadius: blurRadius, offset: offset);
  }
}
