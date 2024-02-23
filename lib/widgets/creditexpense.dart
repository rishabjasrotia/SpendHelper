import 'package:flutter/material.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'package:spendhelper/drawer/mydrawer.dart';
import 'package:spendhelper/drawer/bottomnavigation.dart';
import 'package:spendhelper/handler/gsheethandler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'dart:async';

Future<List<Data>> fetchData() async {
  
  final ss = await gSheetLoader();
  // get worksheet by its title
  var sheet = ss.worksheetByTitle('Overall');

  // Family Expense Columns
  var creditDates = await sheet?.values.column(13, fromRow: 2);
  var creditDescription = await sheet?.values.column(14, fromRow: 2);
  var creditAmount = await sheet?.values.column(15, fromRow: 2);
  var creditType = await sheet?.values.column(16, fromRow: 2);

  //Google Data to Epoch base conversion
  var epoch = new DateTime(1899, 12, 30);

  List jsonResponse = [];
  for (var i = creditDates!.length - 1; i > 0; i--) {
    // TO DO
    var internal = {
      'date':
          DateFormat('MM/dd/yyyy').format(epoch.add(new Duration(days: int.parse(creditDates[i])))).toString(),
      'desc': creditDescription?[i],
      'amt': creditAmount?[i],
      'type': creditType?[i],
    };
    jsonResponse.add(internal);
  }
  return jsonResponse.map((data) => Data.fromJson(data)).toList();
}

class Data {
  final String date;
  final String amt;
  final String desc;
  final String type;

  Data({required this.date, required this.amt, required this.desc, required this.type});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      date: json['date'],
      amt: json['amt'],
      desc: json['desc'],
      type: json['type'],
    );
  }
}

class CreditExpense extends StatelessWidget {
  const CreditExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Credit Expense List'),
        ),
        drawer: MyDrawer("Credit"),
        bottomNavigationBar: BottomNavigation(3),
        body: const MyStatefulWidget());
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
              columnSpacing: 30,
              columns: const [
                DataColumn(label: Text('Date'), numeric: true),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Amount'), numeric: true),
                DataColumn(label: Text('Type')),
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
                    DataCell(
                      Text(data.type.toString()),
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
