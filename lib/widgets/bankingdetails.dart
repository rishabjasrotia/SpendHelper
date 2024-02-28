import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spendhelper/drawer/mydrawer.dart';
import 'package:spendhelper/drawer/bottomnavigation.dart';
import 'package:spendhelper/handler/gsheethandler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

double defaultRadius = 8.0;
const double _cardWidth = 115;
const double _banksCount = 4;

Future<Map> fetchBankDetails() async {
  final ss = await gSheetLoader();
  var sheet = ss.worksheetByTitle('Overall');
  const startcolumn = 29;
  var row = 1;
  var bankDetails = {};
  var bankDates = await sheet?.values.column(28, fromRow: 2);
  var lastRow = bankDates!.length + 1;

  for (int i = 0; i < _banksCount; i++) {
    var column = startcolumn + i;
    var bankName = await sheet?.values.value(column: column, row: row);
    var currentBal = await sheet?.values.value(column: column, row: lastRow);
    bankDetails[bankName] = currentBal;
  }

  return Future.value(bankDetails);
}

updateGsheetBankDetails(data, bankIndex, bankName, bankBalance) async {
  final ss = await gSheetLoader();
  var sheet = ss.worksheetByTitle('Overall');
  const startcolumn = 29;
  var bankDates = await sheet?.values.column(28, fromRow: 2);
  var lastRow = bankDates!.length + 1;
  var lastDate = bankDates[bankDates.length - 1];

  //Google Data to Epoch base conversion
  var epoch = new DateTime(1899, 12, 30);
  lastDate = DateFormat('MM/dd/yyyy').format(epoch.add(new Duration(days: int.parse(lastDate)))).toString();

  // Current Date
  DateTime now = new DateTime.now();
  var currentDate = DateFormat('MM/dd/yyyy').format(new DateTime(now.year, now.month, now.day)).toString();
  if (currentDate == lastDate) {
    lastRow = lastRow;
  }else {
    lastRow = lastRow + 1;
  }

  //Update Data field with new balance
  data[bankName] = bankBalance.toString();
  final updateData = data.values.toList(); 
  await sheet.values.insertValue(currentDate, column: (startcolumn - 1), row: lastRow);
  // Update Gsheet with bank balance
  var column = 0;
  for (int i = 0; i < updateData.length; i++) {
    column = startcolumn + i;
    await sheet.values.insertValue(updateData[i], column: column, row: lastRow);
  }

  // Update the Total Field also.
  column = column + 1;
  var formulaVal = '=SUM(AC' + lastRow.toString() + '+AD' + lastRow.toString() + '+AE' + lastRow.toString() + '+AF' + lastRow.toString() + ')';
  await sheet.values.insertValue(formulaVal, column: column, row: lastRow);

}

class BankingRoute extends StatefulWidget {
  const BankingRoute({super.key});

  @override
  BankingRouteRouteState createState() => BankingRouteRouteState();
}

class BankingRouteRouteState extends State<BankingRoute> {
  @override
  TextEditingController bankNameTextController = TextEditingController();
  TextEditingController bankBalTextController = TextEditingController();
  TextEditingController bankIndexTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Details'),
      ),
      drawer: MyDrawer("Bank"),
      bottomNavigationBar: BottomNavigation(4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: double.maxFinite,
              child: bankingDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget bankingDetails() {
    return FutureBuilder(
        future: fetchBankDetails(),
        builder: (context, snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [Container(height: 25), getInkWell(snapshot.data, index)],
                );
              },
            );
          }
          // By default show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  getInkWell(data, index) {
    final bankName = data.keys.elementAt(index);
    final currentBalance = data[bankName];

    return InkWell(
      onTap: () {
        updateBankDetails(data, index, bankName, currentBalance);
      },
      child: Container(
        height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff283593),
                Color(0xff1976d2),
                Colors.purpleAccent,
                Colors.amber,
              ],
            ),
            borderRadius: radius(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(bankName,
                        style: MyTextSample.headline(context)!.copyWith(
                            color: Colors.white,
                            fontFamily:
                                "monospace")), //, style: boldTextStyle(color: Colors.white, size: 20)
                    const Spacer(),
                    Stack(
                      children: List.generate(
                        2,
                        (index) => Container(
                          margin:
                              EdgeInsets.only(left: (15 * index).toDouble()),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: radius(100), color: Colors.white54),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Text(currentBalance,
                style: TextStyle(fontSize: 24, color: Colors.white))
          ],
        ),
      ),
    );
  }

  updateBankDetails(data, index, bankName, currentBalance) {
    bankBalTextController.text = currentBalance;
    bankIndexTextController.text = index.toString();
    bankNameTextController.text = bankName;
    showDialog(
    context: context,
    builder: (context) {
      return DialogBox().dialog(
        context: context,
        onPressed: () async {
          var bankName = bankNameTextController.text;
          var bankBalance = bankBalTextController.text;
          var bankIndex = bankIndexTextController.text;
          showLoaderDialog(context);

          // Logic to call the gheet and update the value
          updateGsheetBankDetails(data, bankIndex, bankName, bankBalance);
          final ss = await gSheetLoader();
          var sheet = ss.worksheetByTitle('Overall');

          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              bankNameTextController.text = "";
              bankBalTextController.text = "";
              bankIndexTextController.text = "";

            });
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        },
        textEditingController1: bankNameTextController,
        textEditingController2: bankBalTextController,
        textEditingController3: bankIndexTextController,
        index: index,
        bankName: bankName,
        currentBalance: currentBalance
      );
    });
  }
}

/// returns Radius
BorderRadius radius([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? defaultRadius));
}

/// returns Radius
Radius radiusCircular([double? radius]) {
  return Radius.circular(radius ?? defaultRadius);
}

class MyColorsSample {
  static const Color primary = Color(0xFF12376F);
  static const Color primaryDark = Color(0xFF0C44A3);
  static const Color primaryLight = Color(0xFF43A3F3);
  static const Color green = Colors.green;
  static Color black = const Color(0xFF000000);
  static const Color accent = Color(0xFFFF4081);
  static const Color accentDark = Color(0xFFF50057);
  static const Color accentLight = Color(0xFFFF80AB);
  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);
  static const Color transparent = Color(0x00f7f7f7);
}

class MyTextSample {
  static TextStyle? display4(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle? subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(letterSpacing: 1);
  }

  static TextStyle? subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7), child: Text("Updating ...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class DialogBox {
  Widget dialog({
    BuildContext? context,
    Function? onPressed,
    TextEditingController? textEditingController1,
    TextEditingController? textEditingController2,
    TextEditingController? textEditingController3,
    index, 
    bankName, 
    currentBalance
  }) {
    return AlertDialog(
      title: Text("Update Bank Balance"),
      content: Container(
        height: 100,
        child: Column(
          children: [
            TextFormField(
                controller: textEditingController1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: bankName),
                readOnly: true,
                onFieldSubmitted: (value) {}
            ),
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: currentBalance),
              onFieldSubmitted: (value) {},
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context!).pop();
          },
          color: Colors.blue,
          child: Text(
            "Cancel",
          ),
        ),
        MaterialButton(
          onPressed: () {
            onPressed!();
          },
          child: Text("Update"),
          color: Colors.blue,
        )
      ],
    );
  }
}
