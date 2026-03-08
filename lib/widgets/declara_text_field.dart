import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeclaraTextField extends HookConsumerWidget {
  const DeclaraTextField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.hintExamples,
  });

  final TextEditingController controller;
  final VoidCallback? onSubmitted;
  final List<String>? hintExamples;

  static const _defaultHints = [
    '引っ越したい',
    '結婚式に参加したい',
    '晩御飯を作りたい',
    '水道代を払いたい',
    '年賀状を作りたい',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final hints = hintExamples ?? _defaultHints;

    final hintIndex = useState(0);
    final visible = useState(true);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 3), (_) {
        visible.value = false;
        Future.delayed(const Duration(milliseconds: 400), () {
          hintIndex.value = (hintIndex.value + 1) % hints.length;
          visible.value = true;
        });
      });
      return timer.cancel;
    }, [hints]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmitted?.call(),
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: 'やりたいこと',
            suffixIcon: IconButton(
              onPressed: controller.clear,
              icon: const Icon(Icons.close),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          opacity: visible.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              '例: ${hints[hintIndex.value]}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
