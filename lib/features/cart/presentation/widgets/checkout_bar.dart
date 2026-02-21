import 'package:flutter/material.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';

class CheckoutBar extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final VoidCallback onCheckout;

  const CheckoutBar({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SummaryRow(
                label: 'Subtotal ($totalItems items)',
                value: '\$${totalPrice.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 4),
              const _SummaryRow(
                label: 'Envío',
                value: 'Gratis',
                valueColor: AppTheme.success,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppTheme.divider),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primary,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _CheckoutButton(onPressed: onCheckout),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: valueColor != null ? FontWeight.w600 : null,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CheckoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 18),
            SizedBox(width: 8),
            Text(
              'Proceder al pago',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
