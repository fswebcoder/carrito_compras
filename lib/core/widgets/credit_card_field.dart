import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/core/utils/credit_card_validator.dart';

class CreditCardField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(CardType)? onCardTypeChanged;

  const CreditCardField({
    super.key,
    required this.controller,
    this.validator,
    this.onCardTypeChanged,
  });

  @override
  State<CreditCardField> createState() => _CreditCardFieldState();
}

class _CreditCardFieldState extends State<CreditCardField> {
  CardType _cardType = CardType.unknown;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final newType = CreditCardValidator.detectCardType(widget.controller.text);
    if (newType != _cardType) {
      setState(() => _cardType = newType);
      widget.onCardTypeChanged?.call(newType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _CardNumberFormatter(),
        LengthLimitingTextInputFormatter(19),
      ],
      style: const TextStyle(
        fontSize: 14,
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
      decoration: const InputDecoration(
        labelText: 'Número de tarjeta',
        hintText: '•••• •••• •••• ••••',
        prefixIcon: Icon(
          Icons.credit_card_rounded,
          color: AppTheme.primary,
          size: 20,
        ),
      ),
      validator: widget.validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }

    final cleanNumber = value.replaceAll(' ', '');

    if (cleanNumber.length < 13) {
      return 'Número incompleto';
    }

    if (!CreditCardValidator.isValidCardNumber(cleanNumber)) {
      return 'Número de tarjeta inválido';
    }

    return null;
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) {
      text = text.substring(0, 16);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
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
