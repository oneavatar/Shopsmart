import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopsmart/core/services/analytics_service.dart';
import 'package:shopsmart/core/services/notification_service.dart';
import 'package:shopsmart/core/services/revenuecat_service.dart';
import 'package:shopsmart/core/theme/app_theme.dart';
import 'package:shopsmart/core/theme/bloc/theme_bloc.dart';
import 'package:shopsmart/core/theme/bloc/theme_state.dart';
import 'package:shopsmart/data/repositories/order_repository.dart';
import 'package:shopsmart/data/repositories/product_repository.dart';
import 'package:shopsmart/features/auth/bloc/auth_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_event.dart';
import 'package:shopsmart/features/auth/repositories/auth_repository.dart';
import 'package:shopsmart/features/cart/bloc/cart_bloc.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';
import 'package:shopsmart/features/order/bloc/order_bloc.dart';
import 'package:shopsmart/features/products/bloc/product_bloc.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_event.dart';
import 'package:shopsmart/firebase_options.dart';
import 'package:shopsmart/routes/app_routes.dart';
import 'package:shopsmart/routes/route_names.dart';
import 'package:shopsmart/core/services/deep_link_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background Message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  Stripe.publishableKey = "pk_test_51BTj7pL9W6VzX0Z2vU5W9b1x7r8y9z0"; // Placeholder key
  
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await RevenueCatService.initialize();
  await MobileAds.instance.initialize();
  await NotificationService().initialize();
  await AnalyticsService.logAppOpen();
  
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const ShopSmart());
}

class ShopSmart extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const ShopSmart({super.key});

  @override
  Widget build(BuildContext context) {
    DeepLinkService().init(navigatorKey);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => ProductRepository()),
        RepositoryProvider(create: (_) => OrderRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>())..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(context.read<ProductRepository>()),
          ),
          BlocProvider(create: (_) => CartBloc()..add(LoadCart())),
          BlocProvider(create: (_) => WishlistBloc()..add(LoadWishlist())),
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(
            create: (context) => OrderBloc(context.read<OrderRepository>()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ShopSmart',
              navigatorObservers: [AnalyticsService.observer],
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              navigatorKey: navigatorKey,
              initialRoute: RouteNames.splash,
              onGenerateRoute: AppRoutes.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
