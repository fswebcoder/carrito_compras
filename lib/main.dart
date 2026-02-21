import 'package:carrito_compras/features/products/presentation/bloc/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await di.init();

  runApp(const Micarrito());
}

class Micarrito extends StatelessWidget {
  const Micarrito({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => di.sl<ProductBloc>()..add(const LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => di.sl<CartBloc>()..add(const LoadCart()),
        ),
      ],
      child: MaterialApp(
        title: 'Carrito de Compras',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
