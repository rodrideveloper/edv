import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/home_view.dart';
import 'package:estilodevida/ui/widgets/drawer_menu.dart';
import 'package:estilodevida/ui/widgets/main_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setUserToCrashlytics();
      checkForUpdate();
    });
  }

  Future<void> setUserToCrashlytics() async {
    final user = context.watch<User?>();
    final ref = FirebaseCrashlytics.instance;

    try {
      if (user != null) {
        ref.setUserIdentifier(user.uid);
      }
    } catch (err, stack) {
      errorHandler(
        err: err,
        stack: stack,
        reason: 'setUserToCrashlytics',
        information: [],
      );
    }
  }

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        final result = await InAppUpdate.startFlexibleUpdate();

        if (result == AppUpdateResult.success) {
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (err, stack) {
      showSnack('Error al actualizar la app');
      errorHandler(
        err: err,
        stack: stack,
        reason: 'Error Update App',
        information: [],
      );
    }
  }

  void showSnack(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = context.watch<User?>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: SizedBox(
        width: size.width * 0.9,
        child: MainButtons(
          user: user,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              purple,
              blue,
            ],
            stops: [
              0.5,
              1.0,
            ],
          ),
        ),
        child: user != null
            ? HomeView(user: user)
            : const CircularProgressIndicator(
                color: purple,
              ),
      ),
    );
  }
}
