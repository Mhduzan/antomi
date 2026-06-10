// lib/widgets/animated_counter.dart
import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const AnimatedCounter({super.key, required this.value, required this.label, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: value),
          duration: const Duration(milliseconds: 800),
          builder: (_, val, __) => Text(
            val.toString(),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}
