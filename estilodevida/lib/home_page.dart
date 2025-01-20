import 'package:estilodevida/error_handler.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/home_view.dart';
import 'package:estilodevida/ui/widgets/background_waves.dart';
import 'package:estilodevida/ui/widgets/drawer_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 5),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          DancingWavesBackground(),
          user != null
              ? HomeView(user: user)
              : const Center(child: CircularProgressIndicator(color: purple)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push('/register'),
        backgroundColor: purple,
        elevation: 8,
        child: const Icon(
          Icons.qr_code_scanner,
          size: 36,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        notchMargin: 12,
        shape: const CircularNotchedRectangle(),
        elevation: 4,
        color: Colors.white,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => GoRouter.of(context).push('/buypack'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.shopping_cart,
                          color: _selectedIndex == 0 ? purple : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          'Comprar Pack',
                          style: TextStyle(
                            color: _selectedIndex == 0 ? purple : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.event,
                          color: _selectedIndex == 2 ? purple : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          'Eventos',
                          style: TextStyle(
                            color: _selectedIndex == 2 ? purple : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
