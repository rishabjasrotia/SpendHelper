import 'package:flutter/material.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'package:spendhelper/widgets/bankingdetails.dart';
import 'package:spendhelper/widgets/cardwidget.dart';
import 'package:spendhelper/widgets/creditexpense.dart';
import 'package:spendhelper/widgets/familyexpense.dart';
import 'package:spendhelper/widgets/personalexpense.dart';
import 'package:spendhelper/widgets/settingpage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

void main() async {
  // Initialize FFI
  if (kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else if(defaultTargetPlatform == TargetPlatform.macOS){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
        '/home': (context) => const CardBasicRoute(),
        '/settings': (context) =>  SettingPage(),
        '/banking': (context) =>  const BankingRoute(),
      },
    );
  }
}
