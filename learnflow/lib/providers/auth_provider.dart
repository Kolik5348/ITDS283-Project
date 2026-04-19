/// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = await ref.watch(authStateProvider.future);
  
  if (user == null) return null;

  return null;
});

final isLoginLoadingProvider = StateProvider<bool>((ref) => false);

final authErrorProvider = StateProvider<String?>((ref) => null);
