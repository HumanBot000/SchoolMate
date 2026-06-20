import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_mate/pages/home/home/start.dart';
import 'package:school_mate/pages/home/homework/Homework.dart';
import 'package:school_mate/pages/home/marks/Grades.dart';
import 'package:school_mate/pages/home/schedule/start.dart';
import 'package:school_mate/pages/settings/SettingsPage.dart';
import 'package:school_mate/pages/settings/setup.dart';
import 'package:school_mate/pages/userAuth/emailVerification.dart';
import 'package:school_mate/pages/userAuth/userAuthentication.dart';
import 'package:school_mate/pages/userAuth/authenticationFlow.dart' as auth_ui;
import 'package:school_mate/main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  observers: [navigatorTreeObserver],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthenticationPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => auth_ui.build(context),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return EmailVerificationPage(email: email);
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => SetupPage(
        afterSelectionRoute: MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const ScheduleNavigationIntersection(),
    ),
    GoRoute(
      path: '/homework',
      builder: (context, state) => const HomeworkPage(),
    ),
    GoRoute(
      path: '/marks',
      builder: (context, state) => const MarksPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
