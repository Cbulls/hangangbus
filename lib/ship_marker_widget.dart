import 'package:flutter/material.dart';

class ShipMarkerWidget extends StatelessWidget {
  final String name;

  const ShipMarkerWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0064B0),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0064B0).withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.directions_boat, color: Colors.white, size: 24),
    );
  }
}
