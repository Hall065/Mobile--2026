import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/chamados_screen.dart';
import 'screens/estoque_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite FFI for desktop platforms
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await initializeDateFormatting('pt_BR', null);
  runApp(const ManutencaoPredialApp());
}

class ManutencaoPredialApp extends StatelessWidget {
  const ManutencaoPredialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manutenção Predial - SENAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;
        final userName = args?['userName'] as String?;

        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            );
          case '/cadastro':
            return MaterialPageRoute(
              builder: (_) => const CadastroScreen(),
            );
          case '/dashboard':
            return MaterialPageRoute(
              builder: (_) => DashboardScreen(userName: userName),
            );
          case '/chamados':
            return MaterialPageRoute(
              builder: (_) => ChamadosScreen(userName: userName),
            );

          case '/estoque':
            return MaterialPageRoute(
              builder: (_) => EstoqueScreen(userName: userName),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            );
        }
      },
    );
  }
}
