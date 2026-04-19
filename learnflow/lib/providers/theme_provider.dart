/// lib/providers/theme_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => false);

enum AppLocale { thai, english }

final localeProvider = StateProvider<AppLocale>((ref) => AppLocale.thai);

final globalLoadingProvider = StateProvider<bool>((ref) => false);

final globalErrorProvider = StateProvider<String?>((ref) => null);

void setLoading(WidgetRef ref, bool loading) {
  ref.read(globalLoadingProvider.notifier).state = loading;
}

void showError(WidgetRef ref, String message) {
  ref.read(globalErrorProvider.notifier).state = message;
  Future.delayed(Duration(seconds: 3), () {
    ref.read(globalErrorProvider.notifier).state = null;
  });
}

void clearError(WidgetRef ref) {
  ref.read(globalErrorProvider.notifier).state = null;
}
