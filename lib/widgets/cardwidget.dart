import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spendhelper/drawer/mydrawer.dart';
import 'package:spendhelper/drawer/bottomnavigation.dart';
import 'package:spendhelper/handler/gsheethandler.dart';
import 'package:carousel_slider/carousel_slider.dart'; 

double defaultRadius = 8.0;
const double _cardWidth = 115;

Future<List> fetchExpenseTotal(column, row, name) async {
  final ss = await gSheetLoader();
  // get worksheet by its title
  var sheet = ss.worksheetByTitle('Overall');
  var creditTotalExpense = await sheet?.values.valueRound(column: column, row: row);
  return Future.value([creditTotalExpense, name]);
}

class CardBasicRoute extends StatefulWidget {
  const CardBasicRoute({super.key});

  @override
  CardBasicRouteState createState() => CardBasicRouteState();
}

class CardBasicRouteState extends State<CardBasicRoute> {
  @override
  TextEditingController dateTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController amtTextController = TextEditingController();
  TextEditingController expenseTypeTextController = TextEditingController();
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }
 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: MyDrawer("Home"),
      bottomNavigationBar: BottomNavigation("Home"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogBox().dialog(
                  context: context,
                  onPressed: () async {
                    // Model model = new Model(
                    //     key: nameTextController.text, value: ageTextController.text);
                    // int? id =   await dbManager.insertData(model) ;
                    // print("data inserted  ${id}" );
                    var date = dateTextController.text;
                    var description = descTextController.text;
                    var amount = amtTextController.text;
                    var expenseType = expenseTypeTextController.text;
                    showLoaderDialog(context);
                    // print(date);
                    // print(description);
                    // print(amount);
                    // print(expenseType);
                    // Logic to call the gheet and update the value
                    final ss = await gSheetLoader();
                    var sheet = ss.worksheetByTitle('Overall');
                    if (date.isNotEmpty && description.isNotEmpty && amount.isNotEmpty && expenseType.isNotEmpty) {
                      if (expenseType == 'Credit') {
                        // get the last value column number
                        var creditDates = await sheet?.values.column(13, fromRow: 2);
                        var targetRow = creditDates!.length + 2;
                        await sheet.values.insertValue(date, column: 13, row: targetRow);
                        await sheet.values.insertValue(description, column: 14, row: targetRow);
                        await sheet.values.insertValue(amount, column: 15, row: targetRow);
                        await sheet.values.insertValue('P', column: 16, row: targetRow);
                      }
                      if (expenseTypeTextController.text == 'Personal') {
                        // get the last value column number
                        var personalDates = await sheet?.values.column(8, fromRow: 2);
                        var targetRow = personalDates!.length + 2;
                        await sheet.values.insertValue(date, column: 8, row: targetRow);
                        await sheet.values.insertValue(description, column: 9, row: targetRow);
                        await sheet.values.insertValue(amount, column: 10, row: targetRow);
                      }
                      if (expenseTypeTextController.text == 'Family') {
                        // get the last value column number
                        var familyDates = await sheet?.values.column(1, fromRow: 2);
                        var targetRow = familyDates!.length + 2;
                        await sheet.values.insertValue(date, column: 1, row: targetRow);
                        await sheet.values.insertValue(description, column: 2, row: targetRow);
                        await sheet.values.insertValue(amount, column: 3, row: targetRow);
                      }
                    }
                 

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        dateTextController.text = "";
                        descTextController.text = "";
                        amtTextController.text = "";
                        expenseTypeTextController.text = "";
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  },
                  textEditingController1: dateTextController,
                  textEditingController2: descTextController,
                  textEditingController3: amtTextController,
                  textEditingController4: expenseTypeTextController,
                );
              });
        }
        ,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.vertical,

        child: Column(
          children: <Widget>[
            CarouselSlider(items: [
                familyExpenseCard(),
                personalExpenseCard(),
                creditExpenseCard()
              ],
              carouselController: _controller,
              options: CarouselOptions(enlargeCenterPage: true, height: 200),
            ),
          ],
        ),
      ),
    );
  }

  Widget familyExpenseCard() {
    return FutureBuilder(
        future: fetchExpenseTotal(4, 2, 'Family Expense'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/familyExpense");
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
                        Color(0xFF846AFF),
                        Color(0xFF755EE8),
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
                            Text(snapshot.data![1],
                                style: MyTextSample.headline(context)!.copyWith(
                                    color: Colors.white,
                                    fontFamily:
                                        "monospace")), //, style: boldTextStyle(color: Colors.white, size: 20)
                            const Spacer(),
                            Stack(
                              children: List.generate(
                                2,
                                (index) => Container(
                                  margin: EdgeInsets.only(
                                      left: (15 * index).toDouble()),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: radius(100),
                                      color: Colors.white54),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(snapshot.data![0],
                        style: TextStyle(fontSize: 24, color: Colors.white))
                  ],
                ),
              )
            );
          }
          // By default show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  Widget personalExpenseCard() {
    return FutureBuilder(
        future: fetchExpenseTotal(11, 2, 'Personal Expense'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return 
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/personalExpense");
              },
              child:  Container(
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
                            Text(snapshot.data![1],
                                style: MyTextSample.headline(context)!.copyWith(
                                    color: Colors.white,
                                    fontFamily:
                                        "monospace")), //, style: boldTextStyle(color: Colors.white, size: 20)
                            const Spacer(),
                            Stack(
                              children: List.generate(
                                2,
                                (index) => Container(
                                  margin: EdgeInsets.only(
                                      left: (15 * index).toDouble()),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: radius(100),
                                      color: Colors.white54),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(snapshot.data![0],
                        style: TextStyle(fontSize: 24, color: Colors.white))
                  ],
                ),
              )
            );
            
          }
          // By default show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  Widget creditExpenseCard() {
    return FutureBuilder(
        future: fetchExpenseTotal(17, 2, 'Credit Card Expense'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/creditExpense");
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
                        Color(0xff0c0c0c),
                        Color.fromARGB(255, 37, 40, 43),
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
                            Text(snapshot.data![1],
                                style: MyTextSample.headline(context)!.copyWith(
                                    color: Colors.white,
                                    fontFamily:
                                        "monospace")), //, style: boldTextStyle(color: Colors.white, size: 20)
                            const Spacer(),
                            Stack(
                              children: List.generate(
                                2,
                                (index) => Container(
                                  margin: EdgeInsets.only(
                                      left: (15 * index).toDouble()),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: radius(100),
                                      color: Colors.white54),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(snapshot.data![0],
                        style: TextStyle(fontSize: 24, color: Colors.white))
                  ],
                ),
              )
            );
          }
          // By default show a loading spinner.
          return const CircularProgressIndicator();
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

showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Updating ..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

class DialogBox  {
  Widget dialog({
    BuildContext? context,
    Function? onPressed,
    TextEditingController? textEditingController1,
    TextEditingController? textEditingController2,
    TextEditingController? textEditingController3,
    TextEditingController? textEditingController4,
  }) {
    return AlertDialog(
      title: Text("Enter Expense Details"),
      content: Container(
        height: 200,
        child: Column(
          children: [
            TextFormField(
              controller: textEditingController1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Enter Date"),
              onFieldSubmitted: (value) {}
            ),
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Enter Description"),
              onFieldSubmitted: (value) {},
            ),
            TextFormField(
              controller: textEditingController3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter Amount"),
              onFieldSubmitted: (value) {},
            ),
           TextField(
              controller: textEditingController4,
              decoration: InputDecoration(
                hintText:'Select Expense Type',
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    textEditingController4?.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    var items = [
                      'Family',
                      'Credit',
                      'Personal'
                    ];
                    return items
                        .map<PopupMenuItem<String>>((String value) {
                      return new PopupMenuItem(
                          child: new Text(value), value: value);
                    }).toList();
                  },
                ),
              ),
            )
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
          child: Text("Save"),
          color: Colors.blue,
        )
      ],
    );
  }
}
