import 'package:flutter/material.dart';

class CustomLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomLoginButton({super.key, required this.onPressed,required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ปรับขนาดให้เต็ม
      height: 50, // ปรับความสูงให้เหมาะสม
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // สีพื้นหลัง
          foregroundColor: Colors.white, // สีตัวอักษร
          padding: const EdgeInsets.symmetric(vertical: 14), // กำหนด Padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // ✅ ขอบมน
          ),
          elevation: 6, // ✅ เพิ่มเงาให้ปุ่มดูนูน
          shadowColor: Colors.blueAccent.withValues(alpha: (0.8 * 255).toDouble()),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18, // ✅ ขนาดตัวอักษรพอดี
            fontWeight: FontWeight.bold, // ✅ ตัวหนาให้ดูแข็งแรง
            letterSpacing: 1.2, // ✅ เพิ่มช่องไฟเล็กน้อย
          ),
        ),
      ),
    );
  }
}
