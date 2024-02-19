import 'package:flutter/material.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'package:spendhelper/widgets/familyexpense.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendHelper',
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
      routes: {
        '/personalExpense': (context) => const MyHomePage(),
      },
    );
  }
}
