import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';

class PaymentSuccessPage extends StatelessWidget {
  final double total;
  final String email;
  final int itemCount;

  const PaymentSuccessPage({
    super.key,
    required this.total,
    required this.email,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SuccessIcon(),
                const SizedBox(height: 32),
                _SuccessTitle()
                    .animate(delay: 400.ms)
                    .fadeIn()
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 12),
                _SuccessSubtitle(
                  itemCount: itemCount,
                ).animate(delay: 500.ms).fadeIn(),
                const SizedBox(height: 24),
                _PaymentDetails(
                  total: total,
                  email: email,
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 40),
                _ContinueShoppingButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.success,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: AppTheme.success.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
        )
        .animate()
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 300.ms);
  }
}

class _SuccessTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '¡Pago exitoso!',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

class _SuccessSubtitle extends StatelessWidget {
  final int itemCount;

  const _SuccessSubtitle({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tu pedido de $itemCount ${itemCount == 1 ? 'producto' : 'productos'} ha sido procesado',
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
      textAlign: TextAlign.center,
    );
  }
}

class _PaymentDetails extends StatelessWidget {
  final double total;
  final String email;

  const _PaymentDetails({required this.total, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total pagado',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: AppTheme.textHint,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Confirmación enviada a $email',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ContinueShoppingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueShoppingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Seguir comprando'),
      ),
    );
  }
}
