import 'package:carrito_compras/core/theme/app_theme.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_state.dart';
import 'package:carrito_compras/features/cart/presentation/pages/cart_page.dart';
import 'package:carrito_compras/features/products/presentation/bloc/product_bloc.dart';
import 'package:carrito_compras/features/products/presentation/bloc/product_event.dart';
import 'package:carrito_compras/features/products/presentation/bloc/product_state.dart';
import 'package:carrito_compras/features/products/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<String> _categories = [
    'Todos',
    "men's clothing",
    "women's clothing",
    'jewelery',
    'electronics',
  ];

  String _selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadProductsIfNeeded();
  }

  void _loadProductsIfNeeded() {
    final state = context.read<ProductBloc>().state;
    if (state is ProductInitial) {
      context.read<ProductBloc>().add(const LoadProducts());
    }
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
    final filterCategory = category == 'Todos' ? null : category;
    context.read<ProductBloc>().add(FilterByCategory(filterCategory));
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
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [_HomeAppBar()],
          body: Column(
            children: [
              CategoryFilter(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
              Expanded(child: _ProductsGrid()),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.primary,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppTheme.primary,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Prueba Carrito 🛒',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Descubre productos increíbles',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [_CartButton()],
    );
  }
}

/// Botón del carrito con contador animado.
class _CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final itemCount = state is CartLoaded ? state.totalItems : 0;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CartPage())),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child:
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            itemCount > 99 ? '99+' : itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ).animate().scale(
                          duration: 200.ms,
                          curve: Curves.elasticOut,
                        ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading || state is ProductInitial) {
          return const ProductsShimmerGrid();
        }
        if (state is ProductError) {
          return ProductsErrorState(
            message: state.message,
            onRetry: () =>
                context.read<ProductBloc>().add(const LoadProducts()),
          );
        }
        if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return const ProductsEmptyState();
          }
          return _buildProductsList(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProductsList(BuildContext context, ProductLoaded state) {
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () async {
        context.read<ProductBloc>().add(const RefreshProducts());
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.62,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: state.products[index])
                  .animate(delay: Duration(milliseconds: index * 40))
                  .fadeIn(duration: 300.ms)
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 300.ms,
                    curve: Curves.easeOut,
                  );
            },
          );
        },
      ),
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }
}
