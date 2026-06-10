import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class PriceCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final double amount;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const PriceCard({
    super.key,
    required this.label,
    required this.sublabel,
    required this.amount,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  String formatRupiah(double value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  sublabel,
                  style: TextStyle(
                    color: color.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatRupiah(amount),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceDisplay extends StatelessWidget {
  final double hargaCash;
  final double hargaBonNormal;
  final double hargaBonWajib;

  const PriceDisplay({
    super.key,
    required this.hargaCash,
    required this.hargaBonNormal,
    required this.hargaBonWajib,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PriceCard(
          label: 'CASH',
          sublabel: 'Pembayaran tunai',
          amount: hargaCash,
          color: AppTheme.cashColor,
          bgColor: AppTheme.cashLight,
          icon: Icons.payments_outlined,
        ),
        const SizedBox(height: 10),
        PriceCard(
          label: 'BON NORMAL',
          sublabel: 'Pembayaran bon biasa',
          amount: hargaBonNormal,
          color: AppTheme.bonNormalColor,
          bgColor: AppTheme.bonNormalLight,
          icon: Icons.receipt_long_outlined,
        ),
        const SizedBox(height: 10),
        PriceCard(
          label: 'BON WAJIB',
          sublabel: 'Pembayaran bon wajib',
          amount: hargaBonWajib,
          color: AppTheme.bonWajibColor,
          bgColor: AppTheme.bonWajibLight,
          icon: Icons.assignment_outlined,
        ),
      ],
    );
  }
}
