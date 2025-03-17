import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const BannerButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.blueAccent.withOpacity(0.6), blurRadius: 10),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
