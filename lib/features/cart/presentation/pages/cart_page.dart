import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_event.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_state.dart';
import 'package:carrito_compras/features/cart/presentation/widgets/cart_sliver_app_bar.dart';
import 'package:carrito_compras/features/cart/presentation/widgets/cart_empty_state.dart';
import 'package:carrito_compras/features/cart/presentation/widgets/cart_error_state.dart';
import 'package:carrito_compras/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:carrito_compras/features/cart/presentation/widgets/checkout_bar.dart';
import 'package:carrito_compras/features/checkout/presentation/pages/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

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
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              );
            }
            if (state is CartError) {
              return _buildErrorState(context, state.message);
            }
            if (state is CartLoaded) {
              if (state.isEmpty) {
                return _buildEmptyCart(context);
              }
              return _buildCartContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return CustomScrollView(
      slivers: [
        CartSliverAppBar(
          itemCount: 0,
          onBack: () => Navigator.of(context).pop(),
        ),
        SliverFillRemaining(
          child: CartErrorState(
            message: message,
            onRetry: () => context.read<CartBloc>().add(const LoadCart()),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CartSliverAppBar(
          itemCount: 0,
          onBack: () => Navigator.of(context).pop(),
        ),
        SliverFillRemaining(
          child: CartEmptyState(
            onViewProducts: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              CartSliverAppBar(
                itemCount: state.items.length,
                onBack: () => Navigator.of(context).pop(),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CartItemCard(item: state.items[index])
                          .animate(delay: Duration(milliseconds: index * 60))
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: 0.1, end: 0, duration: 300.ms),
                    );
                  }, childCount: state.items.length),
                ),
              ),
            ],
          ),
        ),
        CheckoutBar(
          totalItems: state.totalItems,
          totalPrice: state.totalPrice,
          onCheckout: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CheckoutPage()));
          },
        ),
      ],
    );
  }
}
