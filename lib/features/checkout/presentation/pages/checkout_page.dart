import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_event.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_state.dart';
import 'package:carrito_compras/features/checkout/presentation/pages/payment_success_page.dart';
import 'package:carrito_compras/features/checkout/presentation/widgets/checkout_app_bar.dart';
import 'package:carrito_compras/features/checkout/presentation/widgets/checkout_empty_state.dart';
import 'package:carrito_compras/features/checkout/presentation/widgets/order_summary_card.dart';
import 'package:carrito_compras/features/checkout/presentation/widgets/payment_form.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is! CartLoaded || state.isEmpty) {
              return _buildEmptyState();
            }
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        CheckoutAppBar(
          title: 'Checkout',
          onBack: () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: CheckoutEmptyState(
            onGoToCatalog: () =>
                Navigator.of(context).popUntil((r) => r.isFirst),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(CartLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return Column(
          children: [
            CheckoutAppBar(
              title: 'Checkout',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: isWide
                  ? _buildWideLayout(state)
                  : _buildMobileLayout(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMobileLayout(CartLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          OrderSummaryCard(
            items: state.items,
            totalItems: state.totalItems,
            totalPrice: state.totalPrice,
          ),
          const SizedBox(height: 16),
          _buildPaymentForm(state),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWideLayout(CartLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(child: _buildPaymentForm(state)),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: OrderSummaryCard(
                items: state.items,
                totalItems: state.totalItems,
                totalPrice: state.totalPrice,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm(CartLoaded state) {
    return PaymentForm(
      formKey: _formKey,
      nameController: _nameController,
      emailController: _emailController,
      addressController: _addressController,
      cardNumberController: _cardNumberController,
      expiryController: _expiryController,
      cvvController: _cvvController,
      isProcessing: _isProcessing,
      totalPrice: state.totalPrice,
      onSubmit: () => _processPayment(state),
    );
  }

  Future<void> _processPayment(CartLoaded state) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    context.read<CartBloc>().add(const ClearCartEvent());

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PaymentSuccessPage(
          total: state.totalPrice,
          email: _emailController.text,
          itemCount: state.items.length,
        ),
      ),
    );
  }
}
