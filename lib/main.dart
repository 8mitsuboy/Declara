import 'package:declara/pages/splash_page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final textTheme = GoogleFonts.mPlusRounded1cTextTheme();

    return MaterialApp(
      title: 'Declara',
      theme: ThemeData(
        colorScheme: colorScheme,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          titleTextStyle: GoogleFonts.mPlusRounded1c(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}
