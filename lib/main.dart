import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rent_on/screens/auth_wrapper.dart';
import 'package:rent_on/screens/home/landing_home_screen.dart';
import 'package:rent_on/screens/owner/add_listing_screen.dart';
import 'package:rent_on/screens/renter/electronics_screen.dart';

import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/item_details_wrapper.dart';
import 'screens/owner/owner_dashboard.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/renter/home_screen.dart';
import 'screens/utils/theme.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(RentOnApp());
}

class RentOnApp extends StatelessWidget {
  RentOnApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(path: '/home', builder: (context, state) => const LandingHomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) =>  const SignupScreen()),
      GoRoute(path: '/renter/home', builder: (context, state) =>  HomeScreen()),
      GoRoute(path: '/owner/dashboard', builder: (context, state) =>  OwnerDashboard()),
      GoRoute(path: '/profile', builder: (context, state) =>  ProfileScreen()),
      GoRoute(path: '/owner/add-listing', builder: (context, state) => const AddListingScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthWrapper(),),
      GoRoute(path: '/electronics', builder: (context, state) => const ElectronicsScreen()),


      GoRoute(
        path: '/item/:id',
        builder: (context, state) {
          final itemId = state.pathParameters['id']!;
          return ItemDetailsWrapper(itemId: itemId);
        },
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) {
          final itemId = state.uri.queryParameters['itemId']!;
          return BookingScreen(itemId: itemId);
        },
      ),
    ],
    errorBuilder: (context, state) =>
    const Scaffold(body: Center(child: Text('Page Not Found'))),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            title: 'RentOn',
            theme: AppTheme.darkTheme,
            routerConfig: _router,
            restorationScopeId: 'rentonApp',
          );
        },
      ),
    );
  }
}
