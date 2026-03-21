import 'package:flutter/material.dart';
import 'pages/SplashScreen.dart';
import 'pages/OnboardingScreen.dart';
import 'pages/LoginPage.dart';
import 'pages/RegisterPage.dart';
import 'pages/ForgotPasswordPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LearnFlow',
      initialRoute: '/splash',
      routes: {
        '/splash':          (context) => const SplashScreen(),
        '/onboarding':      (context) => const OnboardingScreen(),
        '/':                (context) => const LoginPage(),
        '/register':        (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}