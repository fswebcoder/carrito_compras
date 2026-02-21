import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/core/utils/credit_card_validator.dart';

class CvvField extends StatelessWidget {
  final TextEditingController controller;
  final CardType cardType;
  final String? Function(String?)? validator;

  const CvvField({
    super.key,
    required this.controller,
    this.cardType = CardType.unknown,
    this.validator,
  });

  int get _maxLength => cardType == CardType.amex ? 4 : 3;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_maxLength),
      ],
      style: const TextStyle(
        fontSize: 14,
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'CVV',
        hintText: cardType == CardType.amex ? '••••' : '•••',
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppTheme.primary,
          size: 20,
        ),
      ),
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    if (!CreditCardValidator.isValidCvv(value, cardType)) {
      return 'CVV inválido';
    }

    return null;
  }
}
