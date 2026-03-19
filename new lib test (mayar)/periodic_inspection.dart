import 'package:flutter/material.dart';
import 'dart:ui';

class Inspection {
  final String id;
  final String date;
  final DateTime dateTime;
  final String result;
  final String expiryDate;
  final String center;

  Inspection({
    required this.id, 
    required this.date, 
    required this.dateTime,
    required this.result,
    required this.expiryDate,
    required this.center,
  });
}

class PeriodicInspectionScreen extends StatefulWidget {
  final String carModel;
  final String carYear;
  final String carPlate;

  const PeriodicInspectionScreen({
    super.key,
    required this.carModel,
    required this.carYear,
    required this.carPlate,
  });

  @override
  State<PeriodicInspectionScreen> createState() => _PeriodicInspectionScreenState();
}

class _PeriodicInspectionScreenState extends State<PeriodicInspectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isAscending = false; 
  
  final List<Inspection> _allInspections = [
    Inspection(
      id: "INS-882736", 
      date: "2024 - 5 - 28", 
      dateTime: DateTime(2024, 5, 28),
      result: "ناجح",
      expiryDate: "2025 - 5 - 28",
      center: "مركز الفحص الفني الدوري - الرياض",
    ),
    Inspection(
      id: "INS-771625", 
      date: "2023 - 5 - 20", 
      dateTime: DateTime(2023, 5, 20),
      result: "ناجح",
      expiryDate: "2024 - 5 - 20",
      center: "مركز الفحص الفني الدوري - الرياض",
    ),
    Inspection(
      id: "INS-660514", 
      date: "2022 - 5 - 15", 
      dateTime: DateTime(2022, 5, 15),
      result: "ناجح",
      expiryDate: "2023 - 5 - 15",
      center: "مركز الفحص الفني الدوري - الرياض",
    ),
  ];

  // Mock data for other cars
  final List<Inspection> _camryInspections = [
    Inspection(
      id: "INS-993847", 
      date: "2025 - 1 - 10", 
      dateTime: DateTime(2025, 1, 10),
      result: "ناجح",
      expiryDate: "2026 - 1 - 10",
      center: "مركز الفحص الفني الدوري - جدة",
    ),
  ];

  final List<Inspection> _accentInspections = [
    Inspection(
      id: "INS-112233", 
      date: "2024 - 11 - 15", 
      dateTime: DateTime(2024, 11, 15),
      result: "ناجح",
      expiryDate: "2025 - 11 - 15",
      center: "مركز الفحص الفني الدوري - الدمام",
    ),
  ];

  List<Inspection> _currentCarInspections = [];
  List<Inspection> _filteredInspections = [];

  @override
  void initState() {
    super.initState();
    _initializeCarData();
    _searchController.addListener(_onSearchChanged);
  }

  void _initializeCarData() {
    if (widget.carModel.contains("كامري")) {
      _currentCarInspections = List.from(_camryInspections);
    } else if (widget.carModel.contains("فورد")) {
      _currentCarInspections = List.from(_accentInspections);
    } else if (widget.carModel.contains("يارس")) {
      _currentCarInspections = List.from(_allInspections);
    } else {
      _currentCarInspections = List.from(_allInspections);
    }
    _filteredInspections = List.from(_currentCarInspections);
    _sortInspections();
  }

  @override
  void didUpdateWidget(PeriodicInspectionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.carModel != widget.carModel) {
      _initializeCarData();
      _applyFilters();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredInspections = _currentCarInspections
          .where((inspection) => inspection.id.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
      _sortInspections();
    });
  }

  void _sortInspections() {
    _filteredInspections.sort((a, b) {
      if (_isAscending) {
        return a.dateTime.compareTo(b.dateTime);
      } else {
        return b.dateTime.compareTo(a.dateTime);
      }
    });
  }

  bool _isFilterActive() {
    return _isAscending != false || _searchController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSearchSection(),
              const SizedBox(height: 24),
              Expanded(
                child: _filteredInspections.isEmpty 
                  ? const Center(child: Text("لا توجد نتائج", style: TextStyle(color: Colors.white54, fontFamily: 'Cairo')))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const ClampingScrollPhysics(),
                      itemCount: _filteredInspections.length,
                      itemBuilder: (context, index) {
                        final inspection = _filteredInspections[index];
                        return _buildInspectionCard(inspection);
                      },
                    ),
              ),
            ],
          ),
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
                "الفحص الدوري",
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

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Cairo'),
                decoration: const InputDecoration(
                  hintText: "ابحث برقم الفحص",
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 14, fontFamily: 'Cairo'),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.search, color: Colors.white.withOpacity(0.5), size: 28),
          const SizedBox(width: 16),
          InkWell(
            onTap: _showFilterBottomSheet,
            borderRadius: BorderRadius.circular(14),
            child: Icon(
              Icons.filter_alt_outlined, 
              color: Colors.white.withOpacity(0.5), 
              size: 28
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "تصفية النتائج",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                      ),
                      if (_isFilterActive())
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isAscending = false;
                              _searchController.clear();
                              _applyFilters();
                            });
                            setModalState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text("إعادة تعيين", style: TextStyle(color: Colors.blueAccent, fontFamily: 'Cairo')),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("الترتيب حسب التاريخ", style: TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Cairo')),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip("الأحدث أولاً", !_isAscending, (selected) {
                        setModalState(() => _isAscending = false);
                        setState(() => _isAscending = false);
                        _sortInspections();
                      }),
                      _buildFilterChip("الأقدم أولاً", _isAscending, (selected) {
                        setModalState(() => _isAscending = true);
                        setState(() => _isAscending = true);
                        _sortInspections();
                      }),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontFamily: 'Cairo', fontSize: 12),
      backgroundColor: Colors.white.withOpacity(0.05),
      selectedColor: Colors.white,
      checkmarkColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
    );
  }

  Widget _buildInspectionCard(Inspection inspection) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.carPlate,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: inspection.result == "ناجح" ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  inspection.result,
                  style: TextStyle(
                    color: inspection.result == "ناجح" ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow("رقم الفحص", inspection.id),
          const SizedBox(height: 12),
          _buildDetailRow("تاريخ الفحص", inspection.date),
          const SizedBox(height: 12),
          _buildDetailRow("تاريخ الانتهاء", inspection.expiryDate),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showInspectionDetails(context, inspection),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.05),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Text(
                "تفاصيل الفحص",
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInspectionDetails(BuildContext context, Inspection inspection) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("تقرير الفحص الدوري", style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white54)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildReportRow("رقم الفحص", inspection.id),
                _buildReportRow("المركز", inspection.center),
                _buildReportRow("النتيجة", inspection.result),
                _buildReportRow("تاريخ الفحص", inspection.date),
                _buildReportRow("تاريخ الانتهاء", inspection.expiryDate),
                const SizedBox(height: 16),
                const Text("ملاحظات الفحص:", style: TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'Cairo')),
                const SizedBox(height: 8),
                const Text(
                  "المركبة سليمة من الناحية الفنية، تم فحص المحرك والفرامل والأنوار بنجاح.",
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Center(child: Icon(Icons.fact_check_outlined, color: Colors.white24, size: 48)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'Cairo')),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'Cairo'),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }
}
