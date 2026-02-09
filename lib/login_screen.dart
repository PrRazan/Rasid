
import 'package:flutter/material.dart';
import 'dart:ui';
import 'main.dart';

enum AuthView { login, signup, forgotId, forgotOtp, forgotReset }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isExpanded = false;
  AuthView _currentView = AuthView.login;
  bool _agreedToTerms = false;
  double _dragOffset = 0;
  bool _codeResent = false;

  void _toggleExpanded(bool expand) {
    setState(() {
      _isExpanded = expand;
      _dragOffset = 0;
    });
  }

  void _setView(AuthView view) {
    setState(() {
      _currentView = view;
      // Reset resend state when switching views
      if (view != AuthView.forgotOtp) {
        _codeResent = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const double containerWidth = 378;
    const double expandedHeight = 520; 
    const double collapsedHeight = 160; 
    
    double currentHeight;
    if (_isExpanded) {
      currentHeight = (expandedHeight - _dragOffset).clamp(collapsedHeight, expandedHeight);
    } else {
      currentHeight = (collapsedHeight - _dragOffset).clamp(collapsedHeight, expandedHeight);
    }

    final double containerTopEdge = screenHeight - currentHeight;
    final bool hideText = containerTopEdge < (screenHeight * 0.75);

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Stack(
        children: [
          // Background Glows
          Positioned(bottom: -60, left: -60, child: _buildGlow(const Color(0xFF7FBED1), 250)),
          Positioned(bottom: -60, right: -60, child: _buildGlow(const Color(0xFFBD4A55), 230)),
          Positioned(bottom: -110, left: screenWidth * 0.2, child: _buildGlow(const Color(0xFF7FBED1), 230)),
          Positioned(bottom: -70, left: -40, child: _buildGlow(const Color(0xFFDEDE84), 210)),

          Positioned(
            top: screenHeight * 0.55,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: hideText ? 0 : 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: const [
                    Text("نظام موثوق لسجل مركبتك", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 16),
                    Text("يمكنك راصد من الاطلاع على سجل مركبتك، بما يشمل قراءات، وسجلات الصيانة، والأعطال، مع ضمان سلامة البيانات والتحقق من صحتها.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
                  ],
                ),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: _dragOffset == 0 ? const Duration(milliseconds: 600) : Duration.zero,
            curve: Curves.fastOutSlowIn,
            top: -50 - ((currentHeight - collapsedHeight) / (expandedHeight - collapsedHeight) * 50),
            left: 0,
            right: 0,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 100),
              scale: 2.0,
              child: Center(
                child: Image.asset("images/loginCar.png", height: screenHeight * 0.35, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_car, size: 100, color: Colors.grey)),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: (screenWidth - containerWidth) / 2,
            child: GestureDetector(
              onVerticalDragUpdate: (details) => setState(() => _dragOffset += details.primaryDelta!),
              onVerticalDragEnd: (details) {
                if (_isExpanded) {
                  if (_dragOffset > 70) _toggleExpanded(false);
                  else setState(() => _dragOffset = 0);
                } else {
                  if (_dragOffset < -70) _toggleExpanded(true);
                  else setState(() => _dragOffset = 0);
                }
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: AnimatedContainer(
                    duration: _dragOffset == 0 ? const Duration(milliseconds: 500) : Duration.zero,
                    curve: Curves.easeOutCubic,
                    width: containerWidth,
                    height: currentHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E).withOpacity(0.85),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: currentHeight - 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(width: 45, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10))),
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset("images/RasidLogo.png", height: 60, errorBuilder: (context, error, stackTrace) => const Text("راصـــد", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4))),
                                  ),
                                ],
                              ),
                              if (_isExpanded || currentHeight > 300) _buildContentByView(),
                              if (_isExpanded || currentHeight > 300) 
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_getSubmitText(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70)),
                                      const SizedBox(width: 20),
                                      _buildGlassCircularButton(onPressed: _handleSubmit),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCircularButton({required VoidCallback onPressed}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white, size: 22),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildContentByView() {
    switch (_currentView) {
      case AuthView.login:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildTextField("بطاقة الأحوال/الاقامة", "أدخل رقم الأحوال/الاقامة", isRequired: true),
            const SizedBox(height: 25),
            _buildTextField("كلمة المرور", "************", isPassword: true, isRequired: true),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => _setView(AuthView.forgotId), child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: Colors.white54, fontSize: 13)))),
            const SizedBox(height: 10),
            Align(alignment: Alignment.center, child: TextButton(onPressed: () => _setView(AuthView.signup), child: const Text("ليس لديك حساب؟ تسجيل جديد", style: TextStyle(color: Color(0xFF7FBED1), fontSize: 14)))),
          ],
        );
      case AuthView.signup:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildTextField("بطاقة الأحوال/الاقامة", "أدخل رقم الأحوال/الاقامة", isRequired: true),
            const SizedBox(height: 25),
            _buildTextField("كلمة المرور", "************", isPassword: true),
            const SizedBox(height: 25),
            _buildTextField("تأكيد كلمة المرور", "************", isPassword: true),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(color: _agreedToTerms ? Colors.blueAccent.withOpacity(0.8) : Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white24)),
                    child: _agreedToTerms ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 12),
                  const Text("أوافق على الشروط والأحكام", style: TextStyle(fontSize: 16, color: Colors.white70)),
                  const Text(" *", style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(alignment: Alignment.center, child: TextButton(onPressed: () => _setView(AuthView.login), child: const Text("لديك حساب؟ تسجيل دخول", style: TextStyle(color: Color(0xFF7FBED1), fontSize: 14)))),
          ],
        );
      case AuthView.forgotId:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("استعادة كلمة المرور", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 30),
            _buildTextField("بطاقة الأحوال/الاقامة", "أدخل رقم الأحوال/الاقامة لإستعادة الحساب", isRequired: true),
            const SizedBox(height: 40),
            Align(alignment: Alignment.center, child: TextButton(onPressed: () => _setView(AuthView.login), child: const Text("العودة لتسجيل الدخول", style: TextStyle(color: Colors.white54, fontSize: 14)))),
          ],
        );
      case AuthView.forgotOtp:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("التحقق من الهوية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            const Text("تم إرسال رمز التحقق إلى الرقم المسجل المرتبط ببطاقة الأحوال ********54", style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
            const SizedBox(height: 35),
            Row(children: const [Text("رمز التحقق (OTP)", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text(" *", style: TextStyle(color: Colors.redAccent, fontSize: 14))]),
            const SizedBox(height: 16),
            _buildOTPFields(),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center, 
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _codeResent = true;
                  });
                }, 
                child: Text(
                  "إعادة إرسال الرمز", 
                  style: TextStyle(
                    color: _codeResent ? Colors.grey : const Color(0xFF7FBED1), 
                    fontSize: 14
                  )
                )
              )
            ),
          ],
        );
      case AuthView.forgotReset:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("تعيين كلمة مرور جديدة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 30),
            _buildTextField("كلمة المرور الجديدة", "************", isPassword: true, isRequired: true),
            const SizedBox(height: 25),
            _buildTextField("تأكيد كلمة المرور", "************", isPassword: true, isRequired: true),
            const SizedBox(height: 40),
          ],
        );
    }
  }

  String _getSubmitText() {
    switch (_currentView) {
      case AuthView.login: return "تسجيل الدخول";
      case AuthView.signup: return "تسجيل جديد";
      case AuthView.forgotId: return "أرسل";
      case AuthView.forgotOtp: return "تحقق";
      case AuthView.forgotReset: return "تحديث";
    }
  }

  void _handleSubmit() {
    switch (_currentView) {
      case AuthView.login:
      case AuthView.signup:
      case AuthView.forgotReset:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
        break;
      case AuthView.forgotId: _setView(AuthView.forgotOtp); break;
      case AuthView.forgotOtp: _setView(AuthView.forgotReset); break;
    }
  }

  Widget _buildGlow(Color color, double size) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: size * 0.8, spreadRadius: size * 0.1)]));
  }

  Widget _buildTextField(String label, String hint, {bool isRequired = false, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), if (isRequired) const Text(" *", style: TextStyle(color: Colors.redAccent, fontSize: 14))]),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 17), cursorColor: Colors.white,
          decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white24, fontSize: 14), enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38, width: 1.5)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)), contentPadding: const EdgeInsets.symmetric(vertical: 8), isDense: true),
        ),
      ],
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 55,
          child: TextField(
            autofocus: index == 0,
            onChanged: (value) { if (value.length == 1 && index < 3) FocusScope.of(context).nextFocus(); else if (value.isEmpty && index > 0) FocusScope.of(context).previousFocus(); },
            keyboardType: TextInputType.number, maxLength: 1, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(counterText: "", enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 2)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.5)), isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 8)),
          ),
        );
      }),
    );
  }
}