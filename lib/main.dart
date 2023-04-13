import 'package:crypto_app/views/io.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Crypto App',
      debugShowCheckedModeBanner: false,
      home: IO(),
    );
  }
}
