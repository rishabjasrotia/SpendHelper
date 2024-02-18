import 'package:flutter/material.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

void main() async {
  // init GSheets

  runApp(const MainApp());
}

Future<List<Data>> fetchData() async {
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

  // get worksheet by its title
  var sheet = ss.worksheetByTitle('Overall');

  // Family Expense Columns
  var familyDates = await sheet?.values.column(1, fromRow: 2);
  var familyDescription = await sheet?.values.column(2, fromRow: 2);
  var familyAmount = await sheet?.values.column(3, fromRow: 2);

  //Google Data to Epoch base conversion
  var epoch = new DateTime(1899, 12, 30);

  List jsonResponse = [];
  for (var i = 0; i < familyDates!.length; i++) {
    // TO DO
    var internal = {
      'date':
          epoch.add(new Duration(days: int.parse(familyDates[i]))).toString(),
      'desc': familyDescription?[i],
      'amt': familyAmount?[i],
    };
    jsonResponse.add(internal);
  }
  return jsonResponse.map((data) => Data.fromJson(data)).toList();
}

class Data {
  final String date;
  final String amt;
  final String desc;

  Data({required this.date, required this.amt, required this.desc});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      date: json['date'],
      amt: json['amt'],
      desc: json['desc'],
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Expense',
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
      routes: {
        '/personalExpense': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Family Expense List'),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('SpendHelper'),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: const Text('Page 1'),
                onTap: () {
                  selectedItem(context, 1);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.train,
                ),
                title: const Text('Page 2'),
                onTap: () {
                  selectedItem(context, 2);
                },
              ),
            ],
          ),
        ),
        body: const MyStatefulWidget());
  }
}

void selectedItem(BuildContext context, int index) {
  // Navigator.of(context).pop();
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, "/personalExpense");
      break;
    case 1:
      Navigator.pushReplacementNamed(context, "/personalExpense");
      break;
    case 2:
      Navigator.pushReplacementNamed(context, "/personalExpense");
      break;
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: DataTable(
              border: TableBorder.all(width: 1),
              columnSpacing: 30,
              columns: const [
                DataColumn(label: Text('Date'), numeric: true),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Amount'), numeric: true),
              ],
              rows: List.generate(
                snapshot.data!.length,
                (index) {
                  var data = snapshot.data![index];
                  return DataRow(cells: [
                    DataCell(
                      Text(data.date.toString()),
                    ),
                    DataCell(
                      Text(data.desc.toString()),
                    ),
                    DataCell(
                      Text(data.amt.toString()),
                    ),
                  ]);
                },
              ).toList(),
              showBottomBorder: true,
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
