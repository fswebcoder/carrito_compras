import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/core/utils/credit_card_validator.dart';
import 'package:carrito_compras/core/widgets/app_text_field.dart';
import 'package:carrito_compras/core/widgets/credit_card_field.dart';
import 'package:carrito_compras/core/widgets/expiry_date_field.dart';
import 'package:carrito_compras/core/widgets/cvv_field.dart';
import 'package:carrito_compras/features/checkout/presentation/widgets/section_header.dart';
import 'package:carrito_compras/features/checkout/presentation/widgets/mock_credit_card.dart';

class PaymentForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final bool isProcessing;
  final double totalPrice;
  final VoidCallback onSubmit;

  const PaymentForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.isProcessing,
    required this.totalPrice,
    required this.onSubmit,
  });

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  CardType _cardType = CardType.unknown;

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.person_outline_rounded,
                  title: 'Información de contacto',
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: widget.nameController,
                  label: 'Nombre completo',
                  icon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: widget.emailController,
                  label: 'Correo electrónico',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Campo requerido';
                    if (!v.contains('@')) return 'Correo inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: widget.addressController,
                  label: 'Dirección de envío',
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 24),

                const SectionHeader(
                  icon: Icons.credit_card_rounded,
                  title: 'Datos de pago',
                ),
                const SizedBox(height: 16),
                MockCreditCard(cardType: _cardType),
                const SizedBox(height: 16),
                CreditCardField(
                  controller: widget.cardNumberController,
                  onCardTypeChanged: (type) {
                    setState(() => _cardType = type);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ExpiryDateField(
                        controller: widget.expiryController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CvvField(
                        controller: widget.cvvController,
                        cardType: _cardType,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _PayButton(
                  isProcessing: widget.isProcessing,
                  totalPrice: widget.totalPrice,
                  onPressed: widget.onSubmit,
                ),
                const SizedBox(height: 12),
                const _SecurePaymentBadge(),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}

class _PayButton extends StatelessWidget {
  final bool isProcessing;
  final double totalPrice;
  final VoidCallback onPressed;

  const _PayButton({
    required this.isProcessing,
    required this.totalPrice,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isProcessing ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Procesando pago...', style: TextStyle(fontSize: 16)),
                ],
              )
            : Text(
                'Pagar \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _SecurePaymentBadge extends StatelessWidget {
  const _SecurePaymentBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_rounded, size: 14, color: AppTheme.textHint),
        const SizedBox(width: 4),
        Text(
          'Pago seguro y encriptado',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textHint),
        ),
      ],
    );
  }
}
