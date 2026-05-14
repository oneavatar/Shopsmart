import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shopsmart/core/services/notification_service.dart';
import 'package:shopsmart/core/services/revenuecat_service.dart';
import 'package:shopsmart/core/theme/app_theme.dart';
import 'package:shopsmart/core/theme/bloc/theme_bloc.dart';
import 'package:shopsmart/core/theme/bloc/theme_state.dart';
import 'package:shopsmart/data/repositories/order_repository.dart';
import 'package:shopsmart/data/repositories/product_repository.dart';
import 'package:shopsmart/features/auth/bloc/auth_bloc.dart';
import 'package:shopsmart/features/auth/repositories/auth_repository.dart';
import 'package:shopsmart/features/cart/bloc/cart_bloc.dart';
import 'package:shopsmart/features/order/bloc/order_bloc.dart';
import 'package:shopsmart/features/products/bloc/product_bloc.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:shopsmart/firebase_options.dart';
import 'package:shopsmart/routes/app_routes.dart';
import 'package:shopsmart/routes/route_names.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background Message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RevenueCatService.initialize();
  await MobileAds.instance.initialize();
  await NotificationService().initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(ShopSmart());
}

class ShopSmart extends StatelessWidget {
  const ShopSmart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),

        RepositoryProvider(create: (_) => ProductRepository()),

        RepositoryProvider(create: (_) => OrderRepository()),
      ],

      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),

          BlocProvider(
            create: (context) => ProductBloc(context.read<ProductRepository>()),
          ),

          BlocProvider(create: (_) => CartBloc()),

          BlocProvider(create: (_) => WishlistBloc()),

          BlocProvider(create: (_) => ThemeBloc()),

          BlocProvider(
            create: (context) => OrderBloc(context.read<OrderRepository>()),
          ),
        ],

        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,

              title: 'ShopSmart AI',

              theme: AppTheme.lightTheme,

              darkTheme: AppTheme.darkTheme,
              
              themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,

              initialRoute: RouteNames.login,

              onGenerateRoute: AppRoutes.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
