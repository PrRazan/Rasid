import 'package:flutter/material.dart';
import 'dart:ui';
import 'login_screen.dart';
import 'notisetting.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true;
  String _language = 'العربية';
  String _dateType = 'ميلادي';
  int _fontSizeIndex = 2;

  // Translation map for the settings page
  final Map<String, Map<String, String>> _translations = {
    'العربية': {
      'title': 'الإعدادات',
      'profile_name': 'رزان العمري',
      'notifications': 'الإشعارات',
      'accessibility': 'سهولة الاستخدام',
      'dark_mode': 'المظهر الداكن',
      'language': 'اللغة',
      'font_size': 'حجم الخط',
      'date': 'التاريخ',
      'my_account': 'حسابي',
      'change_password': 'تغيير كلمة المرور',
      'delete_account': 'حذف الحساب',
      'about_rasid': 'حول راصد',
      'faq': 'الأسئلة الشائعة',
      'contact_us': 'تواصل معنا',
      'logout': 'تسجيل الخروج',
      'hijri': 'هجري',
      'gregorian': 'ميلادي',
      'close': 'إغلاق',
      'confirm': 'تأكيد',
      'cancel': 'إلغاء',
      'delete_confirm_msg': 'هل أنت متأكد من حذف الحساب؟ لا يمكن التراجع عن هذا الإجراء.',
      'password_change_msg': 'تم إرسال رابط تعيين كلمة المرور إلى بريدك الإلكتروني.',
      'faq_title': 'الأسئلة الشائعة',
      'faq_content': '1. كيف أستخدم راصد؟\nيمكنك البدء بإضافة سيارتك في الصفحة الرئيسية.\n\n2. كيف أتتبع سيارتي؟\nمن خلال قسم الخريطة، يمكنك رؤية موقع سيارتك الحالي.\n\n3. هل بياناتي آمنة؟\nنعم، نحن نستخدم أعلى معايير التشفير لحماية بياناتك.',
      'contact_title': 'تواصل معنا',
      'contact_msg': 'يمكنك التواصل معنا عبر البريد الإلكتروني: support@rasid.com',
    },
    'English': {
      'title': 'Settings',
      'profile_name': 'Razan Al-Omari',
      'notifications': 'Notifications',
      'accessibility': 'Accessibility',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'font_size': 'Font Size',
      'date': 'Date',
      'my_account': 'My Account',
      'change_password': 'Change Password',
      'delete_account': 'Delete Account',
      'about_rasid': 'About Rasid',
      'faq': 'FAQ',
      'contact_us': 'Contact Us',
      'logout': 'Logout',
      'hijri': 'Hijri',
      'gregorian': 'Gregorian',
      'close': 'Close',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'delete_confirm_msg': 'Are you sure you want to delete your account? This action cannot be undone.',
      'password_change_msg': 'A password reset link has been sent to your email.',
      'faq_title': 'Frequently Asked Questions',
      'faq_content': '1. How to use Rasid?\nYou can start by adding your car on the home page.\n\n2. How to track my car?\nThrough the map section, you can see your car\'s current location.\n\n3. Is my data safe?\nYes, we use the highest encryption standards to protect your data.',
      'contact_title': 'Contact Us',
      'contact_msg': 'You can reach us via email at: support@rasid.com',
    }
  };

  String _t(String key) => _translations[_language]?[key] ?? key;

  double get _fontSizeMultiplier => 0.75 + (_fontSizeIndex * 0.125);

  void _showDialog(String title, String content, {bool isDestructive = false}) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title, style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontFamily: 'Cairo', fontSize: 20 * _fontSizeMultiplier)),
          content: Text(content, style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87, fontFamily: 'Cairo', fontSize: 16 * _fontSizeMultiplier)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isDestructive) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }
              },
              child: Text(
                _t('close'),
                style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.blueAccent, fontFamily: 'Cairo', fontSize: 14 * _fontSizeMultiplier),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final subTextColor = _isDarkMode ? Colors.white38 : Colors.black38;
    final containerColor = _isDarkMode ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03);
    final borderColor = _isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08);

    return Directionality(
      textDirection: _language == 'العربية' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // Background Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
                      _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Back Button
                    Align(
                      alignment: _language == 'العربية' ? Alignment.topRight : Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: textColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Profile Section
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC4C4C4).withOpacity(0.3),
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor, width: 1.5),
                            ),
                            child: Icon(Icons.person, size: 70, color: textColor.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _t('profile_name'),
                            style: TextStyle(
                              fontSize: 24 * _fontSizeMultiplier,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Main Settings Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notifications
                          _buildGlassTile(
                            label: _t('notifications'),
                            icon: Icons.notifications_none,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen())),
                            trailing: Icon(
                              Icons.chevron_left,
                              color: textColor.withOpacity(0.5),
                            ),
                            textColor: textColor,
                            containerColor: containerColor,
                            borderColor: borderColor,
                          ),
                          
                          const SizedBox(height: 24),
                          _buildSectionLabel(_t('accessibility'), subTextColor),
                          const SizedBox(height: 8),
                          _buildGlassSection([
                            _buildSettingItem(
                              label: _t('dark_mode'),
                              icon: Icons.dark_mode_outlined,
                              trailing: Switch(
                                value: _isDarkMode,
                                onChanged: (val) => setState(() => _isDarkMode = val),
                                activeColor: Colors.white,
                                activeTrackColor: Colors.blue.withOpacity(0.5),
                              ),
                              textColor: textColor,
                            ),
                            _buildDivider(borderColor),
                            _buildSettingItem(
                              label: _t('language'),
                              icon: Icons.language,
                              trailing: _buildLanguageSelector(),
                              textColor: textColor,
                            ),
                            _buildDivider(borderColor),
                            _buildSettingItem(
                              label: _t('font_size'),
                              icon: Icons.text_fields,
                              trailing: _buildFontSizeSelector(textColor),
                              textColor: textColor,
                            ),
                            _buildDivider(borderColor),
                            _buildSettingItem(
                              label: _t('date'),
                              icon: Icons.calendar_today_outlined,
                              trailing: _buildDateTypeSelector(),
                              textColor: textColor,
                            ),
                          ], containerColor, borderColor),
                          
                          const SizedBox(height: 24),
                          _buildSectionLabel(_t('my_account'), subTextColor),
                          const SizedBox(height: 8),
                          _buildGlassSection([
                            _buildSettingItem(
                              label: _t('change_password'),
                              icon: Icons.lock_outline,
                              onTap: () => _showDialog(_t('change_password'), _t('password_change_msg')),
                              textColor: textColor,
                            ),
                            _buildDivider(borderColor),
                            _buildSettingItem(
                              label: _t('delete_account'),
                              icon: Icons.person_remove_outlined,
                              onTap: () => _showDialog(_t('delete_account'), _t('delete_confirm_msg'), isDestructive: true),
                              textColor: textColor,
                            ),
                          ], containerColor, borderColor),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionLabel(_t('about_rasid'), subTextColor),
                    const SizedBox(height: 8),
                    _buildGlassSection([
                      _buildSettingItem(
                        label: _t('faq'),
                        icon: Icons.help_outline,
                        onTap: () => _showDialog(_t('faq_title'), _t('faq_content')),
                        textColor: textColor,
                      ),
                      _buildDivider(borderColor),
                      _buildSettingItem(
                        label: _t('contact_us'),
                        icon: Icons.headset_mic_outlined,
                        onTap: () => _showDialog(_t('contact_title'), _t('contact_msg')),
                        textColor: textColor,
                      ),
                    ], containerColor, borderColor),
                    
                    const SizedBox(height: 40),
                    // Logout Button
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: borderColor),
                        ),
                        child: Center(
                          child: Text(
                            _t('logout'),
                            style: TextStyle(color: const Color(0xFFBD4A55), fontSize: 18 * _fontSizeMultiplier, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12 * _fontSizeMultiplier, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
      ),
    );
  }

  Widget _buildGlassTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
    required Color textColor,
    required Color containerColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18 * _fontSizeMultiplier,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildGlassSection(List<Widget> children, Color containerColor, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required String label,
    IconData? icon,
    Widget? trailing,
    VoidCallback? onTap,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor.withOpacity(0.7), size: 22),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16 * _fontSizeMultiplier,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(color: color, height: 1, indent: 16, endIndent: 16);
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleOption("English", _language == "English", () => setState(() => _language = "English")),
          _buildToggleOption("العربية", _language == "العربية", () => setState(() => _language = "العربية")),
        ],
      ),
    );
  }

  Widget _buildDateTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleOption(_t('hijri'), _dateType == "هجري", () => setState(() => _dateType = "هجري")),
          _buildToggleOption(_t('gregorian'), _dateType == "ميلادي", () => setState(() => _dateType = "ميلادي")),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (_isDarkMode ? Colors.white : Colors.black) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? (_isDarkMode ? Colors.black : Colors.white) : (_isDarkMode ? Colors.white54 : Colors.black54),
            fontSize: 12 * _fontSizeMultiplier,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeSelector(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        bool isSelected = _fontSizeIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _fontSizeIndex = index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 2,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isSelected ? textColor : textColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "A",
                  style: TextStyle(
                    color: isSelected ? textColor : textColor.withOpacity(0.2),
                    fontSize: 10 + (index * 2),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
