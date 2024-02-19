import 'package:spendhelper/src/gsheets.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

gSheetLoader() async {
  await dotenv.load(fileName: ".env");

  var project_id = dotenv.env['PROJECT_ID'];
  var private_key_id = dotenv.env['PRIVATE_KEY_ID'];
  var private_key = dotenv.env['PRIVATE_KEY'];
  var client_email = dotenv.env['CLIENT_EMAIL'];
  var client_id = dotenv.env['CLIENT_ID'];
  var client_x509_cert_url = dotenv.env['CLIENT_X509'];

  var _spreadsheetId = dotenv.env['SPREADSHEET_ID'].toString();

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
