//
// import 'package:flutter/material.dart';
// import 'screens/main_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Shopping App',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: const Color(0xFF315C81),
//         scaffoldBackgroundColor: const Color(0xFFF8F9FB),
//         fontFamily: 'Roboto',
//       ),
//       home: const MainScreen(),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/main_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF315C81),
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}
