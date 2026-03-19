import 'package:flutter/material.dart';
import 'dart:ui';

class Accident {
  final String id;
  final String date;
  final DateTime dateTime;

  Accident({required this.id, required this.date, required this.dateTime});
}

class AccidentsScreen extends StatefulWidget {
  final String model;
  final String year;
  final String plate;

  const AccidentsScreen({
    super.key,
    this.model = "Toyota",
    this.year = "2023",
    this.plate = "ر ن ن 9590",
  });

  @override
  State<AccidentsScreen> createState() => _AccidentsScreenState();
}

class _AccidentsScreenState extends State<AccidentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isAscending = false; // Default to newest first (descending)
  
  final List<Accident> _allAccidents = [
    Accident(id: "RD1367285278", date: "2025 - 7 - 3", dateTime: DateTime(2025, 7, 3)),
    Accident(id: "RS9653745920", date: "2025 - 3 - 5", dateTime: DateTime(2025, 3, 5)),
    Accident(id: "RG2736490163", date: "2023 - 3 - 23", dateTime: DateTime(2023, 3, 23)),
  ];

  final List<Accident> _yarisAccidents = [
    Accident(id: "RD1367285278", date: "2025 - 7 - 3", dateTime: DateTime(2025, 7, 3)),
    Accident(id: "RS9653745920", date: "2025 - 3 - 5", dateTime: DateTime(2025, 3, 5)),
  ];

  final List<Accident> _fordAccidents = [
    Accident(id: "RG2736490163", date: "2023 - 3 - 23", dateTime: DateTime(2023, 3, 23)),
  ];

  List<Accident> _currentCarAccidents = [];
  List<Accident> _filteredAccidents = [];

  @override
  void initState() {
    super.initState();
    _initializeCarData();
    _searchController.addListener(_onSearchChanged);
  }

  void _initializeCarData() {
    if (widget.model.contains("يارس")) {
      _currentCarAccidents = List.from(_yarisAccidents);
    } else if (widget.model.contains("فورد")) {
      _currentCarAccidents = List.from(_fordAccidents);
    } else if (widget.model.contains("تويوتا كامري")) {
      _currentCarAccidents = [];
    } else {
      _currentCarAccidents = List.from(_allAccidents);
    }
    _filteredAccidents = List.from(_currentCarAccidents);
    _sortAccidents();
  }

  @override
  void didUpdateWidget(AccidentsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model) {
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
      _filteredAccidents = _currentCarAccidents
          .where((accident) => accident.id.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
      _sortAccidents();
    });
  }

  void _sortAccidents() {
    _filteredAccidents.sort((a, b) {
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

  void _toggleSort() {
    setState(() {
      _isAscending = !_isAscending;
      _sortAccidents();
    });
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
              // Header Section
              _buildHeader(context),
              
              const SizedBox(height: 24),
              
              // Search and Filter Section
              _buildSearchSection(),
              
              const SizedBox(height: 24),
              
              // Accidents List
              Expanded(
                child: _filteredAccidents.isEmpty 
                  ? const Center(child: Text("لا توجد نتائج", style: TextStyle(color: Colors.white54, fontFamily: 'Cairo')))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const ClampingScrollPhysics(),
                      itemCount: _filteredAccidents.length,
                      itemBuilder: (context, index) {
                        final accident = _filteredAccidents[index];
                        return _buildAccidentCard(accident.id, accident.date);
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
                "الحوادث",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(width: 48), // Spacer to balance the back button
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
          // Search Bar on the right (start in RTL)
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
                  hintText: "ابحث برقم الحادث",
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 14, fontFamily: 'Cairo'),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Search Icon
          Icon(Icons.search, color: Colors.white.withOpacity(0.5), size: 28),
          const SizedBox(width: 16),
          // Filter Icon on the left (end in RTL)
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
                        _sortAccidents();
                      }),
                      _buildFilterChip("الأقدم أولاً", _isAscending, (selected) {
                        setModalState(() => _isAscending = true);
                        setState(() => _isAscending = true);
                        _sortAccidents();
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

  Widget _buildAccidentCard(String id, String date) {
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
          // Vehicle Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.plate,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              Row(
                children: [
                  Text(
                    widget.year,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.model,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Accident ID Row
          _buildDetailRow("رقم الحادث", id),
          const SizedBox(height: 12),
          // Accident Date Row
          _buildDetailRow("تاريخ الحادث", date),
          const SizedBox(height: 16),
          // Details Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showAccidentReport(context, id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.05),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Text(
                "تفاصيل الحادث",
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAccidentReport(BuildContext context, String id) {
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
              const Text("تقرير الحادث", style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white54)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildReportRow("رقم الحادث", id),
                _buildReportRow("الموقع", "الرياض - حي النرجس"),
                _buildReportRow("نوع الحادث", "تصادم بسيط"),
                _buildReportRow("نسبة الخطأ", "0%"),
                const SizedBox(height: 16),
                const Text("وصف الحادث:", style: TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'Cairo')),
                const SizedBox(height: 8),
                const Text(
                  "اصطدام من الخلف عند إشارة المرور، تضرر الصدام الخلفي بشكل بسيط.",
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
                  child: const Center(child: Icon(Icons.image_outlined, color: Colors.white24, size: 48)),
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
