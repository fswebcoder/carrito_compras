import 'package:flutter/material.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  bool get _isMultiline => maxLines > 1;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: _isMultiline ? TextInputType.multiline : keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      style: const TextStyle(
        fontSize: 14,
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: icon != null ? _buildIcon() : null,
        alignLabelWithHint: _isMultiline,
      ),
    );
  }

  Widget _buildIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 8, top: _isMultiline ? 14 : 0),
      child: Align(
        alignment: _isMultiline ? Alignment.topCenter : Alignment.center,
        widthFactor: 1,
        heightFactor: _isMultiline ? null : 1,
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
    );
  }
}
