import 'package:flutter/material.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'package:spendhelper/drawer/mydrawer.dart';
import 'package:spendhelper/handler/gsheethandler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

Future<List<Data>> fetchData() async {
  
  final ss = await gSheetLoader();
  // get worksheet by its title
  var sheet = ss.worksheetByTitle('Overall');

  // Family Expense Columns
  var familyDates = await sheet?.values.column(1, fromRow: 2);
  var familyDescription = await sheet?.values.column(2, fromRow: 2);
  var familyAmount = await sheet?.values.column(3, fromRow: 2);

  //Google Data to Epoch base conversion
  var epoch = new DateTime(1899, 12, 30);

  List jsonResponse = [];
  for (var i = familyDates!.length - 1; i > 0; i--) {
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

class FamilyExpense extends StatelessWidget {
  const FamilyExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Family Expense List'),
        ),
        drawer: MyDrawer("Family"),
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
