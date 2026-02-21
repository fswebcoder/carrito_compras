import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/core/utils/credit_card_validator.dart';

class ExpiryDateField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const ExpiryDateField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _ExpiryDateFormatter(),
        LengthLimitingTextInputFormatter(5),
      ],
      style: const TextStyle(
        fontSize: 14,
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        labelText: 'MM/AA',
        hintText: '12/26',
        prefixIcon: Icon(
          Icons.calendar_today_outlined,
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

    if (value.length < 5) {
      return 'Incompleto';
    }

    if (!CreditCardValidator.isValidExpiry(value)) {
      return 'Fecha inválida';
    }

    return null;
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
