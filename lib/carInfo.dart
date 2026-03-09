import 'package:flutter/material.dart';

class CarInfoScreen extends StatelessWidget {
  const CarInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "معلومات السيارة",
          style: TextStyle(fontWeight: FontWeight.bold), 
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Ensure the content is aligned left
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
                      "images/carsLogo/Toyota-logo.png", // Ensure correct image path
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _infoItem("الموديل", "يارس"),
                      const SizedBox(width: 120), // Spacing between items
                      _infoItem("السنة", "2023"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Car details
            _detailRow("رقم الهيكل", "MR2BE9B24P0046276"),
            _detailRow("اللون", "رمادي"),
            _detailRow("رقم اللوحة", "رن ن 9590"),
            _detailRow("رقم المركبة التسلسلي", "457289013"),
            _detailRow("تاريخ آخر فحص دوري", "2026 - 1 - 5"),

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
                  style: TextStyle(fontWeight: FontWeight.bold),
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

  // Updated _infoItem to ensure left-aligned text
  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Updated _detailRow to ensure left-aligned text for both label and value
  Widget _detailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start, // Align the content to the left
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 8), // Space between label and value
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
