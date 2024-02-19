import 'package:flutter/material.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'package:spendhelper/widgets/cardwidget.dart';
import 'package:spendhelper/widgets/creditexpense.dart';
import 'package:spendhelper/widgets/familyexpense.dart';
import 'package:spendhelper/widgets/personalexpense.dart';
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
      home: const CardBasicRoute(),
      routes: {
        '/personalExpense': (context) => const PersonalExpense(),
        '/creditExpense': (context) => const CreditExpense(),
        '/familyExpense': (context) => const FamilyExpense(),
      },
    );
  }
}
