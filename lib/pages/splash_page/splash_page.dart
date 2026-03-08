import 'package:declara/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 900),
    );

    final titleAnim = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    final taglineAnim = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    useEffect(() {
      controller.forward();

      Future.delayed(const Duration(milliseconds: 2000), () {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomePage(title: 'Declara'),
              transitionsBuilder: (_, animation, __, child) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      });

      return null;
    }, []);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: titleAnim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(titleAnim),
                child: Text(
                  'Declara',
                  style: GoogleFonts.mPlusRounded1c(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeTransition(
              opacity: taglineAnim,
              child: Text(
                '宣言するだけ。',
                style: GoogleFonts.mPlusRounded1c(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
