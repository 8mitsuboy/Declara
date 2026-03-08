import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingView extends HookWidget {
  const LoadingView({super.key, required this.message});

  final String message;

  static const _hints = [
    'やるべきことを洗い出しています...',
    'あなたの宣言を分析中...',
    '具体的なタスクに分解しています...',
  ];

  @override
  Widget build(BuildContext context) {
    final hintIndex = useState(0);
    final opacity = useState(1.0);

    useEffect(() {
      var isMounted = true;

      Future<void> cycle() async {
        while (isMounted) {
          await Future.delayed(const Duration(seconds: 2));
          if (!isMounted) break;
          opacity.value = 0.0;
          await Future.delayed(const Duration(milliseconds: 300));
          if (!isMounted) break;
          hintIndex.value = (hintIndex.value + 1) % _hints.length;
          opacity.value = 1.0;
        }
      }

      cycle();
      return () => isMounted = false;
    }, const []);

    final pulseController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );
    useEffect(() {
      pulseController.repeat(reverse: true);
      return null;
    }, const []);

    final pulseAnimation = useAnimation(
      Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
      ),
    );

    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: AlwaysStoppedAnimation(pulseAnimation),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: opacity.value,
            duration: const Duration(milliseconds: 300),
            child: Text(
              _hints[hintIndex.value],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
