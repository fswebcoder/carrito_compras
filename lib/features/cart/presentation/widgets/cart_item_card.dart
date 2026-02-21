import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_event.dart';
import 'package:carrito_compras/features/cart/presentation/widgets/quantity_stepper.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('cart-item-${item.product.id}'),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => _onDismissed(context),
      child: _CardContent(item: item),
    );
  }

  void _onDismissed(BuildContext context) {
    context.read<CartBloc>().add(RemoveProductFromCart(item.product.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.product.title.split(' ').take(3).join(' ')} eliminado',
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: AppTheme.primaryLight,
          onPressed: () {},
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Deseas quitar "${item.product.title.split(' ').take(4).join(' ')}..." del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppTheme.error,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
          SizedBox(height: 4),
          Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final CartItem item;

  const _CardContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImage(imageUrl: item.product.image),
            const SizedBox(width: 14),
            Expanded(child: _ProductDetails(item: item)),
            _DeleteButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 80,
        color: AppTheme.primarySurface,
        padding: const EdgeInsets.all(8),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.primary,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFFCCCCDD),
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final CartItem item;

  const _ProductDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${item.product.price.toStringAsFixed(2)} c/u',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            QuantityStepper(
              quantity: item.quantity,
              onIncrease: () => context.read<CartBloc>().add(
                IncreaseQuantity(item.product.id),
              ),
              onDecrease: () => context.read<CartBloc>().add(
                DecreaseQuantity(item.product.id),
              ),
            ),
            const Spacer(),
            Text(
              '\$${item.subtotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final CartItem item;

  const _DeleteButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirmed = await _confirmDelete(context);
        if (confirmed == true && context.mounted) {
          context.read<CartBloc>().add(RemoveProductFromCart(item.product.id));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppTheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            size: 16,
            color: AppTheme.error,
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Deseas quitar "${item.product.title.split(' ').take(4).join(' ')}..." del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
