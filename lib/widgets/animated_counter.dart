import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedCounter extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const AnimatedCounter({
    super.key,
    required this.value,
    required this.label,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              value.toString(),
              textStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}