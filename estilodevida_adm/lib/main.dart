// import 'package:estilodevida_adm/firebase_options.dart';
// import 'package:estilodevida_adm/home_page.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:flutter/material.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Formulario en Flutter Web',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

import 'package:estilodevida_adm/firebase_options.dart';
import 'package:estilodevida_adm/ui/register_lesson/register_lesson.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

const purple = Color(0xFF81327D);
const blue = Color(0xFF3155A1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Estilo de Vida Admin',
      // Aquí definimos el tema principal de la app
      theme: ThemeData(
        // Color principal que usará la AppBar, switches, sliders, etc.
        primaryColor: purple,

        // Alternativa: usar colorScheme para más control
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: purple,
          secondary: blue,
        ),

        // Color de fondo de todas las pantallas
        scaffoldBackgroundColor: Colors.white,

        // Estilo para la AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: purple,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),

        // Estilo para los ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: blue, // color de relleno
            foregroundColor: Colors.white, // color del texto
          ),
        ),

        // Estilo para los TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: purple, // texto e íconos
          ),
        ),

        // Estilo para los Checkbox, Radio, Switch, etc.
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(purple),
        ),

        // Estilo para los TextFormField, TextField, etc.
        inputDecorationTheme: const InputDecorationTheme(
          // Borde principal
          border: OutlineInputBorder(
            borderSide: BorderSide(color: purple),
          ),
          // Borde cuando está "enabled" (sin focus)
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: purple),
          ),
          // Borde cuando está en "focus"
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: purple),
          ),
          // Color del label
          labelStyle: TextStyle(color: purple),
        ),
      ),
      home: const RegisterLessonListScreen(),
    );
  }
}
