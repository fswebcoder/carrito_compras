import 'package:flutter/material.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/core/utils/credit_card_validator.dart';

class MockCreditCard extends StatelessWidget {
  final CardType cardType;

  const MockCreditCard({super.key, this.cardType = CardType.unknown});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '•••• •••• •••• ••••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Titular de la tarjeta',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
            const Spacer(),
            _CardTypeBadge(cardType: cardType),
          ],
        ),
      ),
    );
  }
}

class _CardTypeBadge extends StatelessWidget {
  final CardType cardType;

  const _CardTypeBadge({required this.cardType});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: cardType == CardType.unknown
          ? Container(
              key: const ValueKey('unknown'),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(21),
              ),
              child: const Icon(
                Icons.credit_card,
                color: Colors.white,
                size: 22,
              ),
            )
          : Container(
              key: ValueKey(cardType),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _getLabel(),
                style: TextStyle(
                  color: _getBrandColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
    );
  }

  String _getLabel() {
    switch (cardType) {
      case CardType.visa:
        return 'VISA';
      case CardType.mastercard:
        return 'MC';
      case CardType.amex:
        return 'AMEX';
      case CardType.discover:
        return 'DISC';
      case CardType.unknown:
        return '';
    }
  }

  Color _getBrandColor() {
    switch (cardType) {
      case CardType.visa:
        return const Color(0xFF1A1F71);
      case CardType.mastercard:
        return const Color(0xFFEB001B);
      case CardType.amex:
        return const Color(0xFF006FCF);
      case CardType.discover:
        return const Color(0xFFFF6000);
      case CardType.unknown:
        return Colors.grey;
    }
  }
}
