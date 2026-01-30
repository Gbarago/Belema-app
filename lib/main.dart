import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart'; // Import ApiClient
import 'injection_container.dart' as di;
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/bank/bank_bloc.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/set_pin_screen.dart';
import 'presentation/screens/transfer_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Setup Session Timeout Listener
  final apiClient = di.sl<ApiClient>();
  apiClient.authErrorStream.listen((_) {
    di.sl<AuthBloc>().add(LogoutRequested());
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);

    if (navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Session Timed Out'),
          content: const Text('Your session has expired. Please log in again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatus())),
        BlocProvider(create: (_) => di.sl<BankBloc>()),
      ],
      child: MaterialApp(
        title: 'Belema Bank',
        navigatorKey: navigatorKey, // Attach key
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFF1CB954),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1CB954),
            brightness: Brightness.light,
            surface: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/set-pin': (context) => const SetPinScreen(),
          '/transfer': (context) => const TransferScreen(),
        },
      ),
    );
  }
}
