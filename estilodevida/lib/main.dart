import 'dart:ui';

import 'package:estilodevida/home_page.dart';
import 'package:estilodevida/services/app_info/app_info.dart';
import 'package:estilodevida/services/auth_service/auth_service.dart';
import 'package:estilodevida/services/shared_preference/user_preferences.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/events/events.dart';
import 'package:estilodevida/ui/lessons_avalibles.dart';
import 'package:estilodevida/ui/login/login_page.dart';
import 'package:estilodevida/ui/packs/packs.dart';
import 'package:estilodevida/ui/packs/payment_error.dart';
import 'package:estilodevida/ui/packs/payment_pending.dart';
import 'package:estilodevida/ui/packs/payment_success.dart';
import 'package:estilodevida/ui/register_lesson/register_lesson.dart';
import 'package:estilodevida/ui/register_lesson/selected_lesson.dart';
import 'package:estilodevida/ui/user_pack/user_packs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> disableCrashlyticsOnDebug() async {
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.instance.initPrefs();
  AppInfo().init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  disableCrashlyticsOnDebug();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(
      errorDetails,
    );
  };

  PlatformDispatcher.instance.onError = (errorDetails, stack) {
    FirebaseCrashlytics.instance.recordError(
      errorDetails,
      stack,
      fatal: true,
    );
    return true;
  };

  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: AuthService().user,
        ),
      ],
      child: const App(),
    );
  }
}

GoRouter createRouter(User? auth) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/userpacks',
        builder: (_, __) => const PacksScreen(),
      ),
      GoRoute(
        path: '/buypack',
        builder: (_, __) => const PackSelectionScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          // Se obtiene el valor extra, que debe ser de tipo LessonsAvaliblesEnum
          final selectedLesson = state.extra as LessonsAvaliblesEnum?;
          return RegisterLessons(lessson: selectedLesson!);
        },
      ),
      GoRoute(
        path: '/events',
        builder: (_, __) => const Events(),
      ),
      GoRoute(
        path: '/success',
        builder: (_, __) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: '/error',
        builder: (_, __) => const PaymentErrorScreen(),
      ),
      GoRoute(
        path: '/pending',
        builder: (_, __) => const PaymentPendingScreen(),
      ),
      GoRoute(
        path: '/selected',
        builder: (_, __) => const SelectedLessons(),
      ),
    ],
    redirect: (context, state) {
      final bool isLoggedIn = auth != null;
      final bool isLoggingIn = state.uri.toString() == '/login';
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    User? auth = context.watch<User?>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(auth),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(0),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.roboto(
            fontSize: fontTitleSize,
            color: fontTitlesColor,
          ),
          titleLarge: GoogleFonts.roboto(
            fontSize: fontTitleSize,
            color: fontTitlesColor,
          ),
          titleSmall: GoogleFonts.roboto(
            fontSize: fontSubTitleSize,
            color: fontTitlesColor,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: fontBodySize,
          ),
        ),
      ),
    );
  }
}
