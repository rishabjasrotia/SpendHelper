import 'package:flutter/painting.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spendhelper/handler/dbmanager.dart';

class Environment {
  static const PROJECT_ID = String.fromEnvironment('PROJECT_ID', defaultValue: '');
  static const PRIVATE_KEY_ID = String.fromEnvironment('PRIVATE_KEY_ID', defaultValue: '');
  static const PRIVATE_KEY = String.fromEnvironment('PRIVATE_KEY', defaultValue: '');
  static const CLIENT_EMAIL = String.fromEnvironment('CLIENT_EMAIL', defaultValue: '');
  static const CLIENT_ID = String.fromEnvironment('CLIENT_ID', defaultValue: '');
  static const CLIENT_X509 = String.fromEnvironment('CLIENT_X509', defaultValue: '');
  static const SPREADSHEET_ID = String.fromEnvironment('SPREADSHEET_ID', defaultValue: '');
}


gSheetLoader() async {
  await dotenv.load(fileName: ".env");

  var project_id = dotenv.env['PROJECT_ID'];
  var private_key_id = dotenv.env['PRIVATE_KEY_ID'];
  var private_key = dotenv.env['PRIVATE_KEY'];
  var client_email = dotenv.env['CLIENT_EMAIL'];
  var client_id = dotenv.env['CLIENT_ID'];
  var client_x509_cert_url = dotenv.env['CLIENT_X509'];
  var _spreadsheetId = dotenv.env['SPREADSHEET_ID'].toString();

  final DbManager dbManager = new DbManager();
  var dbKeys = await dbManager.getData();
  List.generate(dbKeys.length, (i) {
    // print(dbKeys[i]['id']);
    if (dbKeys[i]['key'] == 'SPREADSHEET_ID') {
      _spreadsheetId = dbKeys[i]['value'].toString();
    }
    if (dbKeys[i]['key'] == 'PROJECT_ID') {
      project_id = dbKeys[i]['value'].toString();
    }
    if (dbKeys[i]['key'] == 'PRIVATE_KEY_ID') {
      private_key_id = dbKeys[i]['value'].toString();
    }
    if (dbKeys[i]['key'] == 'CLIENT_EMAIL') {
      client_email = dbKeys[i]['value'].toString();
    }
    if (dbKeys[i]['key'] == 'CLIENT_ID') {
      client_id = dbKeys[i]['value'].toString();
    }
    if (dbKeys[i]['key'] == 'CLIENT_X509') {
      client_x509_cert_url = dbKeys[i]['value'].toString();
    }
    if (dbKeys[i]['key'] == 'PRIVATE_KEY') {
      private_key = dbKeys[i]['value'].toString();
    }
  });

  var _credentials = r'''
  {
    "type": "service_account",
    "project_id": "'''
      '''$project_id'''
      r'''",
    "private_key_id": "'''
      '''$private_key_id'''
      r'''",
    "private_key": "'''
      '''$private_key'''
      r'''",
    "client_email": "'''
      '''$client_email'''
      r'''",
    "client_id": "'''
      '''$client_id'''
      r'''",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "'''
      '''$client_x509_cert_url'''
      r'''",
    "universe_domain": "googleapis.com"
  }
  ''';

  // const credentials = creds;
  final gsheets = GSheets(_credentials);
    // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(_spreadsheetId);
  return ss;
}
