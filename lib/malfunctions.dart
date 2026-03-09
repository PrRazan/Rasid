import 'package:flutter/material.dart';

class Malfunction {
  final String title;
  final String status;
  final bool isFixed;
  final String? faultDate;
  final String? description;
  final String? fixDate;
  final String type;
  bool isExpanded;

  Malfunction({
    required this.title,
    required this.status,
    required this.isFixed,
    required this.type,
    this.faultDate,
    this.description,
    this.fixDate,
    this.isExpanded = false,
  });
}

class MalfunctionsScreen extends StatefulWidget {
  const MalfunctionsScreen({super.key});

  @override
  State<MalfunctionsScreen> createState() => _MalfunctionsScreenState();
}

class _MalfunctionsScreenState extends State<MalfunctionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'الكل';
  String _typeFilter = 'الكل';
  String _sortOrder = 'الأحدث';

  final List<Malfunction> _allMalfunctions = [
    Malfunction(
      title: "عطل في البطارية",
      status: "لم يتم إصلاحه",
      isFixed: false,
      type: "البطارية",
      faultDate: "2026 - 2 - 15",
      description: "ضعف في جهد البطارية وتآكل في الأقطاب",
    ),
    Malfunction(
      title: "عطل نظام الفرامل",
      status: "لم يتم إصلاحه",
      isFixed: false,
      type: "الفرامل",
      faultDate: "2026 - 3 - 1",
      description: "تآكل في فحمات الفرامل الأمامية وحاجة لتغيير الزيت",
    ),
    Malfunction(
      title: "عطل في المحرك",
      status: "تم إصلاحه",
      isFixed: true,
      type: "المحرك",
      faultDate: "2025 - 9 - 29",
      description: "احتراق غير منتظم في أحد سلندرات المحرك",
      fixDate: "2025 - 10 - 3",
      isExpanded: false,
    ),
    Malfunction(
      title: "عطل ناقل الحركة",
      status: "تم إصلاحه",
      isFixed: true,
      type: "ناقل الحركة",
      faultDate: "2025 - 11 - 12",
      description: "تأخر في استجابة ناقل الحركة عند التبديل",
      fixDate: "2025 - 11 - 15",
    ),
    Malfunction(
      title: "عطل نظام التشغيل",
      status: "تم إصلاحه",
      isFixed: true,
      type: "التشغيل",
      faultDate: "2026 - 1 - 20",
      description: "خلل في حساس التشغيل الذكي",
      fixDate: "2026 - 1 - 22",
    ),
  ];

  List<Malfunction> _filteredMalfunctions = [];

  @override
  void initState() {
    super.initState();
    _filteredMalfunctions = List.from(_allMalfunctions);
    _searchController.addListener(_onSearchChanged);
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
      _filteredMalfunctions = _allMalfunctions.where((m) {
        final matchesSearch = m.title.contains(_searchController.text) || 
                             (m.description?.contains(_searchController.text) ?? false);
        
        final matchesStatus = _statusFilter == 'الكل' || 
                             (_statusFilter == 'تم إصلاحه' && m.isFixed) ||
                             (_statusFilter == 'لم يتم إصلاحه' && !m.isFixed);
        
        final matchesType = _typeFilter == 'الكل' || m.type == _typeFilter;

        return matchesSearch && matchesStatus && matchesType;
      }).toList();

      // Apply Sorting
      _filteredMalfunctions.sort((a, b) {
        if (a.faultDate == null || b.faultDate == null) return 0;
        
        // Simple date parsing for "YYYY - M - D"
        List<int> parseDate(String d) => d.split(' - ').map((s) => int.parse(s.trim())).toList();
        final dateA = parseDate(a.faultDate!);
        final dateB = parseDate(b.faultDate!);

        for (int i = 0; i < 3; i++) {
          if (dateA[i] != dateB[i]) {
            return _sortOrder == 'الأحدث' 
                ? dateB[i].compareTo(dateA[i]) 
                : dateA[i].compareTo(dateB[i]);
          }
        }
        return 0;
      });
    });
  }

  bool _isFilterActive() {
    return _statusFilter != 'الكل' || 
           _typeFilter != 'الكل' || 
           _sortOrder != 'الأحدث' || 
           _searchController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final currentCount = _allMalfunctions.where((m) => !m.isFixed).length;
    final fixedCount = _allMalfunctions.where((m) => m.isFixed).length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              _buildHeader(context),
              
              const SizedBox(height: 16),
              
              // Stats Section
              _buildStatsSection(currentCount.toString(), fixedCount.toString()),
              
              const SizedBox(height: 24),
              
              // Search and Filter Section
              _buildSearchSection(),
              
              const SizedBox(height: 24),
              
              // Malfunctions List
              Expanded(
                child: _filteredMalfunctions.isEmpty 
                  ? const Center(child: Text("لا توجد نتائج", style: TextStyle(color: Colors.white54, fontFamily: 'Cairo')))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const ClampingScrollPhysics(),
                      itemCount: _filteredMalfunctions.length,
                      itemBuilder: (context, index) {
                        return _buildMalfunctionItem(_filteredMalfunctions[index]);
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
                "الأعطال",
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

  Widget _buildStatsSection(String current, String fixed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              "الأعطال الحالية",
              current,
              Icons.warning_amber_rounded,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              "أعطال تم إصلاحها",
              fixed,
              Icons.rule_folder_outlined, // Closest to warning with checkmark
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
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
                  hintText: "ابحث عن عطل",
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
            child: Icon(Icons.filter_alt_outlined, color: Colors.white.withOpacity(0.5), size: 28),
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
                              _statusFilter = 'الكل';
                              _typeFilter = 'الكل';
                              _sortOrder = 'الأحدث';
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
                      _buildFilterChip("الأحدث", _sortOrder == "الأحدث", (selected) {
                        setModalState(() => _sortOrder = "الأحدث");
                        setState(() => _sortOrder = "الأحدث");
                        _applyFilters();
                      }),
                      _buildFilterChip("الأقدم", _sortOrder == "الأقدم", (selected) {
                        setModalState(() => _sortOrder = "الأقدم");
                        setState(() => _sortOrder = "الأقدم");
                        _applyFilters();
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("حسب الحالة", style: TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Cairo')),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip("تم إصلاحه", _statusFilter == "تم إصلاحه", (selected) {
                        setModalState(() => _statusFilter = selected ? "تم إصلاحه" : "الكل");
                        setState(() => _statusFilter = _statusFilter);
                        _applyFilters();
                      }),
                      _buildFilterChip("لم يتم إصلاحه", _statusFilter == "لم يتم إصلاحه", (selected) {
                        setModalState(() => _statusFilter = selected ? "لم يتم إصلاحه" : "الكل");
                        setState(() => _statusFilter = _statusFilter);
                        _applyFilters();
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("حسب النوع", style: TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Cairo')),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          _typeFilter == 'الكل' ? "اختر النوع" : _typeFilter,
                          style: TextStyle(color: _typeFilter == 'الكل' ? Colors.white38 : Colors.white, fontSize: 14, fontFamily: 'Cairo'),
                        ),
                        leading: const Icon(Icons.build_outlined, color: Colors.white38),
                        iconColor: Colors.white38,
                        collapsedIconColor: Colors.white38,
                        children: [
                          _buildTypeItem("البطارية", setModalState),
                          _buildTypeItem("الفرامل", setModalState),
                          _buildTypeItem("المحرك", setModalState),
                          _buildTypeItem("ناقل الحركة", setModalState),
                          _buildTypeItem("التشغيل", setModalState),
                        ],
                      ),
                    ),
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

  Widget _buildTypeItem(String type, StateSetter setModalState) {
    final isSelected = _typeFilter == type;
    return ListTile(
      title: Text(type, style: TextStyle(color: isSelected ? Colors.greenAccent : Colors.white70, fontFamily: 'Cairo', fontSize: 14)),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.greenAccent, size: 18) : null,
      onTap: () {
        setModalState(() => _typeFilter = type);
        setState(() => _typeFilter = type);
        _applyFilters();
      },
    );
  }

  Widget _buildMalfunctionItem(Malfunction item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                item.isExpanded = !item.isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item.status,
                    style: TextStyle(
                      color: item.isFixed ? Colors.greenAccent : Colors.orangeAccent,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    item.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ),
          if (item.isExpanded && item.faultDate != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  _buildDetailRow("تاريخ العطل", item.faultDate!),
                  const SizedBox(height: 12),
                  _buildDescriptionRow("وصف العطل", item.description!),
                  if (item.fixDate != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow("تاريخ الإصلاح", item.fixDate!),
                  ],
                ],
              ),
            ),
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

  Widget _buildDescriptionRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }
}
