import 'package:flutter/material.dart';
import 'package:spendhelper/src/gsheets.dart';
import 'package:spendhelper/drawer/mydrawer.dart';
import 'package:spendhelper/drawer/bottomnavigation.dart';
import 'package:spendhelper/handler/gsheethandler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

Future<List<Data>> fetchData() async {
  
  final ss = await gSheetLoader();
  // get worksheet by its title
  var sheet = ss.worksheetByTitle('Overall');

  // Family Expense Columns
  var personalDates = await sheet?.values.column(8, fromRow: 2);
  var personalDescription = await sheet?.values.column(9, fromRow: 2);
  var personalAmount = await sheet?.values.column(10, fromRow: 2);

  //Google Data to Epoch base conversion
  var epoch = new DateTime(1899, 12, 30);

  List jsonResponse = [];
  for (var i = personalDates!.length - 1; i > 0; i--) {
    // TO DO
    var internal = {
      'date':
          epoch.add(new Duration(days: int.parse(personalDates[i]))).toString(),
      'desc': personalDescription?[i],
      'amt': personalAmount?[i],
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

class PersonalExpense extends StatelessWidget {
  const PersonalExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Personal Expense List'),
        ),
        drawer: MyDrawer("Personal"),
        bottomNavigationBar: BottomNavigation("Personal"),
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
