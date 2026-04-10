import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const DsaSimplifierApp());
}

class DsaSimplifierApp extends StatelessWidget {
  const DsaSimplifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        final isDark = mode == ThemeMode.dark;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ));
        return MaterialApp(
          title: 'Logicly',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: _lightTheme(),
          darkTheme: _darkTheme(),
          home: const HomeScreen(),
        );
      },
    );
  }

  ThemeData _lightTheme() => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F2F8),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5B4FE9),
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      );

  ThemeData _darkTheme() => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C6FFF),
          surface: Color(0xFF1A1A24),
        ),
        fontFamily: 'Roboto',
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      );
}
