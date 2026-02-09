
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("السجل", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 4,
        itemBuilder: (context, index) {
          final items = [
            {'title': 'تغيير زيت المحرك', 'date': '25 مايو 2024', 'cost': '350 ريال'},
            {'title': 'فحص الإطارات', 'date': '12 مايو 2024', 'cost': '120 ريال'},
            {'title': 'تغيير فلتر المكيف', 'date': '01 مايو 2024', 'cost': '280 ريال'},
            {'title': 'فحص الفرامل', 'date': '15 ابريل 2024', 'cost': '400 ريال'},
          ];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(items[index]['cost']!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(items[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(items[index]['date']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}