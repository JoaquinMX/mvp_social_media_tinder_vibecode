import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../features/onboarding/presentation/onboarding_flow.dart';

class GroupSwipeApp extends StatelessWidget {
  const GroupSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Group Swipe',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const OnboardingFlow(),
    );
  }
}
