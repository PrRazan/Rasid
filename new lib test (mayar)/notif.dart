
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:ui';
import 'main.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedTime = '12 شهر';
  List<String> _selectedTypes = ['عطل', 'الفحص الدوري', 'البنزين'];
  
  late ScrollController _scrollController;

  final List<Map<String, dynamic>> _notificationTemplates = [
    {
      'title': 'تنبيه عطل', 
      'desc': 'تم رصد عطل جديد في المركبة', 
      'icon': 'images/icons/alertIcon.png', 
      'color': const Color.fromARGB(255, 188, 0, 19), 
      'category': 'عطل'
    },
    {
      'title': 'تم الفحص الدوري', 
      'desc': 'اكتمل الفحص الدوري للمركبة', 
      'icon': 'images/icons/checkDoneIcon.png', 
      'color': const Color.fromARGB(255, 35, 135, 29), 
      'category': 'الفحص الدوري'
    },
    {
      'title': 'اقتراب موعد الفحص الدوري', 
      'desc': 'اقترب موعد فحص مركبتك الدوري 7 مارس', 
      'icon': Icons.calendar_today_outlined, 
      'color': Colors.blueAccent, 
      'category': 'الفحص الدوري'
    },
    {
      'title': 'انخفاض في مستوى البنزين', 
      'desc': 'اقترب نفاذ بنزين مركبتك', 
      'icon': 'images/icons/feulIcon.png', 
      'color': const Color.fromARGB(255, 235, 169, 25), 
      'category': 'البنزين'
    },
  ];

  late List<Map<String, dynamic>> _allNotifications;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateRandomNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _generateRandomNotifications() {
    final random = Random();
    final now = DateTime.now();
    
    _allNotifications = List.generate(40, (index) {
      final template = _notificationTemplates[random.nextInt(_notificationTemplates.length)];
      final randomDaysAgo = random.nextInt(365);
      final randomTimestamp = now.subtract(Duration(days: randomDaysAgo, hours: random.nextInt(24)));
      
      return {
        ...template,
        'timestamp': randomTimestamp,
        'dateDisplay': _formatArabicDate(randomTimestamp),
      };
    });
    
    _allNotifications.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
  }

  String _formatArabicDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'م' : 'ص'}';
  }

  bool _isWithinSelectedTimeframe(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp).inDays;
    
    switch (_selectedTime) {
      case 'أسبوع': return diff <= 7;
      case 'شهر': return diff <= 30;
      case '3 أشهر': return diff <= 90;
      case '6 أشهر': return diff <= 180;
      case '9 أشهر': return diff <= 270;
      case '12 شهر': return diff <= 365;
      default: return true;
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E).withOpacity(0.9),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "تصفية التنبيهات",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                          ),
                          _buildGlassCloseButton(() => Navigator.pop(context)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildFilterTitle("الفترة الزمنية"),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['أسبوع', 'شهر', '3 أشهر', '6 أشهر', '9 أشهر', '12 شهر'].map((opt) {
                          bool isSelected = _selectedTime == opt;
                          return _buildGlassChoiceChip(
                            label: opt == 'أسبوع' ? 'آخر أسبوع' : 'آخر $opt',
                            isSelected: isSelected,
                            onTap: () => setModalState(() => _selectedTime = opt),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      _buildFilterTitle("نوع التنبيه"),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['عطل', 'الفحص الدوري', 'البنزين'].map((opt) {
                          bool isSelected = _selectedTypes.contains(opt);
                          return _buildGlassChoiceChip(
                            label: opt,
                            isSelected: isSelected,
                            onTap: () {
                              setModalState(() {
                                if (isSelected) _selectedTypes.remove(opt);
                                else _selectedTypes.add(opt);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildGlassButton(
                              label: "تطبيق",
                              isPrimary: true,
                              onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: _buildGlassButton(
                              label: "إعادة ضبط",
                              isPrimary: false,
                              onPressed: () {
                                setModalState(() {
                                  _selectedTime = '12 شهر';
                                  _selectedTypes = ['عطل', 'الفحص الدوري', 'البنزين'];
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildFilterTitle(String text) {
    return Text(
      text, 
      style: TextStyle(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo', letterSpacing: 0.5)
    );
  }

  Widget _buildGlassCloseButton(VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: const Icon(Icons.close, color: Colors.white60, size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassChoiceChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isSelected ? Colors.white : Colors.white.withOpacity(0.1), width: 1),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white.withOpacity(0.6),
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({required String label, required bool isPrimary, required VoidCallback onPressed}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isPrimary ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isPrimary ? Colors.white : Colors.white.withOpacity(0.15), width: 1.2),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _allNotifications.where((notif) {
      final matchesCategory = _selectedTypes.contains(notif['category']);
      final matchesTime = _isWithinSelectedTimeframe(notif['timestamp'] as DateTime);
      return matchesCategory && matchesTime;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        body: Stack(
          children: [
            // Ambient Glows
            Positioned(top: 80, right: -40, child: _buildGlow(const Color(0xFFBD4A55), 240)),
            Positioned(bottom: 80, left: -40, child: _buildGlow(const Color(0xFF7FBED1), 200)),
            
            // Content Layer
            SafeArea(
              child: Column(
                children: [
                  // Fixed Header at the top
                  _buildCustomCapsuleHeader(context),
                  
                  // Scrollable Area - Restrict top boundary so content never goes behind/above header
                  Expanded(
                    child: filteredNotifications.isEmpty 
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                          physics: const ClampingScrollPhysics(),
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) => _buildNotificationCard(filteredNotifications[index]),
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
            )
          ],
        ),
        child: Row(
          children: [
            _buildCapsuleIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen())),
            ),
            const Expanded(
              child: Text(
                "الاشعارات",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            _buildCapsuleIconButton(
              asset: 'images/icons/fillterIcon.png',
              icon: Icons.tune,
              onTap: _showFilterSheet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapsuleIconButton({String? asset, IconData? icon, required VoidCallback onTap}) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Center(
          child: asset != null 
              ? Image.asset(asset, width: 20, height: 20, color: Colors.white, errorBuilder: (_, __, ___) => Icon(icon, color: Colors.white, size: 20))
              : Icon(icon, color: Colors.white, size: 24),
        ),
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
            blurRadius: 80,
            spreadRadius: 10,
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.03),
            ),
            child: Icon(Icons.notifications_none_rounded, color: Colors.white.withOpacity(0.06), size: 80),
          ),
          const SizedBox(height: 24),
          const Text("لا توجد إشعارات حالياً", style: TextStyle(color: Colors.white38, fontSize: 16, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    final dynamic iconData = item['icon'];
    final color = item['color'] as Color;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconContainer(iconData, color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String, 
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, fontFamily: 'Cairo', color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildTimeTag(item['timestamp']),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['desc'] as String, 
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontFamily: 'Cairo', height: 1.4, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      _buildTimestampRow(item['dateDisplay']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(dynamic iconData, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
      ),
      child: Center(
        child: iconData is IconData
            ? Icon(iconData, color: color, size: 24)
            : Image.asset(
                iconData as String,
                width: 24,
                height: 24,
                color: color,
                errorBuilder: (_, __, ___) => Icon(Icons.info_outline, color: color, size: 24),
              ),
      ),
    );
  }

  Widget _buildTimeTag(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    String timeStr = diff.inHours < 1 ? "الآن" : (diff.inDays == 0 ? "${diff.inHours}س" : "${diff.inDays}ي");
    
    return Text(
      timeStr, 
      style: const TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'Cairo', fontWeight: FontWeight.w900)
    );
  }

  Widget _buildTimestampRow(String dateDisplay) {
    return Row(
      children: [
        Icon(Icons.access_time_rounded, size: 12, color: Colors.white24),
        const SizedBox(width: 6),
        Text(
          dateDisplay, 
          style: const TextStyle(color: Colors.white24, fontSize: 10, fontFamily: 'Cairo', fontWeight: FontWeight.bold)
        ),
      ],
    );
  }
}
