
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:ui';
import 'login_screen.dart';
import 'notif.dart';
import 'map.dart';
import 'history.dart';
import 'carInfo.dart';
import 'settings.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const RasedApp(),
    ),
  );
}

class RasedApp extends StatelessWidget {
  const RasedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rased Car Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B1B1B),
        fontFamily: 'Tajawal',
        primaryColor: Colors.white,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardPage(onNavigateToMap: () => _onTabTapped(3)),
      const CarInfoScreen(),
      const HistoryScreen(),
      const MapScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(42),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E).withOpacity(0.7),
              borderRadius: BorderRadius.circular(42),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.home_filled, "الرئيسية", 0),
                _navItem(Icons.directions_car_filled, "السيارة", 1),
                _navItem(Icons.description_outlined, "السجل", 2),
                _navItem(Icons.map_outlined, "المراكز", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  final VoidCallback onNavigateToMap;

  const DashboardPage({super.key, required this.onNavigateToMap});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isToyota = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<int>(
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    } else if (value == 2) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }
                  },
                  offset: const Offset(0, 50),
                  color: const Color(0xFF1E1E1E).withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.person_outline, size: 20, color: Colors.white70),
                          SizedBox(width: 12),
                          Text("الملف الشخصي", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: const [
                          Icon(Icons.logout, size: 20, color: Colors.redAccent),
                          SizedBox(width: 12),
                          Text("تسجيل الخروج", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF404040),
                            radius: 20,
                            child: Icon(Icons.person, color: Colors.grey, size: 24),
                          ),
                          Positioned(
                            right: 28,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Text("اسم المستخدم", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
                      child: _headerIcon(Icons.notifications_none),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                      child: _headerIcon(Icons.settings_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          Container(
            width: 200,
            child: PopupMenuButton<bool>(
              onSelected: (val) => setState(() => _isToyota = val),
              offset: const Offset(0, 48),
              color: const Color(0xFF1E1E1E).withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              itemBuilder: (context) => [
                PopupMenuItem<bool>(
                  value: true,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 190, 
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("أ ب ت", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const Text("|", style: TextStyle(color: Colors.white24, fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text("1 2 3 4", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        if (_isToyota) const Icon(Icons.check, size: 16, color: Colors.green),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<bool>(
                  value: false,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 190,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("ج ح خ", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const Text("|", style: TextStyle(color: Colors.white24, fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text("5 6 7 8", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        if (!_isToyota) const Icon(Icons.check, size: 16, color: Colors.green),
                      ],
                    ),
                  ),
                ),
              ],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_isToyota ? "أ ب ت" : "ج ح خ", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const Text("|", style: TextStyle(color: Colors.white24, fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(_isToyota ? "1 2 3 4" : "5 6 7 8", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
          // PIXEL PERFECT CAR LOGO (166x104) AND STATUS DOT (Adjusted for longer space and larger size)
          Container(
            width: 166,
            height: 104,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _isToyota ? "images/carsLogo/Toyota-logo.png" : "images/carsLogo/ford-logo.png",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_car, size: 60),
                  ),
                ),
                Positioned(
                  left: -14, // Moved further left for longer space (originally 6)
                  top: 83, // Vertical position maintained
                  child: Container(
                    width: 15, // Size increased by 2 (originally 13)
                    height: 15, // Size increased by 2 (originally 13)
                    decoration: BoxDecoration(
                      color: const Color(0xFF91FF00), 
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1B1B1B), width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _statCard("البنزين", "1.00L", "images/icons/feulIcon.png")),
                const SizedBox(width: 16),
                Expanded(child: _statCard("قراءة العداد", "0000", "images/icons/milageIcon.png")),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CarInfoScreen())),
                  icon: const Icon(Icons.chevron_left, color: Colors.white54, size: 28, textDirection: TextDirection.ltr),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionLabel("الاشعارات"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
              child: _malfunctionBanner(),
            ),
          ),
          
          const SizedBox(height: 24),
          _sectionLabel("سجل السيارة"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _maintenanceTimeline(context),
          ),
          
          const SizedBox(height: 24),
          _sectionLabel("مراكز الصيانة"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _mapSection(widget.onNavigateToMap),
          ),
          
          const SizedBox(height: 12), 
        ],
      ),
    );
  }

  static Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16, 
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  static Widget _headerIcon(IconData icon) {
    return Icon(icon, color: Colors.grey.shade500, size: 28);
  }

  static Widget _statCard(String label, String value, String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 95,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1), overflow: TextOverflow.ellipsis),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis),
              Image.asset(imagePath, width: 22, height: 22, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _malfunctionBanner() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), bottomLeft: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), bottomLeft: Radius.circular(28)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6, color: Colors.grey.shade700.withOpacity(0.5)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 27), 
                          child: Image.asset('images/icons/alertIcon.png', width: 24, height: 30, fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("تنبيه عطل", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                            SizedBox(height: 4),
                            Text("تم رصد عطل جديد في المركبة", style: TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _maintenanceTimeline(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            children: [
              const _TimelineItem(
                title: "فحص دوري", 
                status: "اكتمل", 
                date: "مايو 28, 10:24 ص", 
                color: Color(0xFF10B981), 
                icon: Icons.check,
                showLine: true,
              ),
              const SizedBox(height: 40),
              _TimelineItem(
                title: "نظام الفرامل (ABS)", 
                status: "غير مكتمل", 
                date: "مايو 29, 02:15 م", 
                color: const Color(0xFFDEDE84), 
                icon: Icons.warning_amber_outlined,
                showLine: false,
                showMore: true,
                onMorePressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _mapSection(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 220, 
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Stack(
              children: [
                Image.network(
                  "https://snazzy-maps-cdn.azureedge.net/assets/46331-invisibilizacion1.png?v=20170626084601",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.6),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black54.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Text(
                      "انقر لعرض الورش المعتمدة",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String status;
  final String date;
  final Color color;
  final IconData icon;
  final bool showLine;
  final bool showMore;
  final VoidCallback? onMorePressed;

  const _TimelineItem({
    required this.title, 
    required this.status, 
    required this.date, 
    required this.color, 
    required this.icon,
    required this.showLine,
    this.showMore = false,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              if (showLine)
                Positioned(
                  top: 44,
                  bottom: -60,
                  width: 2,
                  child: Container(color: Colors.white12),
                ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: icon == Icons.priority_high 
                    ? Text("!", style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 26))
                    : Icon(icon, color: color, size: 24),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.white)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(height: 8),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                if (showMore) ...[
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: onMorePressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text("المزيد", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_left, size: 20, color: Colors.grey, textDirection: TextDirection.ltr),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}