import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/home_view.dart';
import 'package:estilodevida/ui/widgets/drawer_menu.dart';
import 'package:estilodevida/ui/widgets/main_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
