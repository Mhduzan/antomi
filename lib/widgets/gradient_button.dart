// import 'package:flutter/material.dart';
// import '../utils/theme.dart';

// class GradientButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final LinearGradient? gradient;
//   final IconData? icon;
//   final bool isLoading;
//   final double width;

//   const GradientButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.gradient,
//     this.icon,
//     this.isLoading = false,
//     this.width = double.infinity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       decoration: BoxDecoration(
//         gradient: gradient ?? AppTheme.primaryGradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: AppTheme.softShadow,
//       ),
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (icon != null) ...[
//                     Icon(icon, color: Colors.white),
//                     const SizedBox(width: 12),
//                   ],
//                   Text(
//                     text,
//                     style: AppTheme.buttonText.copyWith(color: Colors.white),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }