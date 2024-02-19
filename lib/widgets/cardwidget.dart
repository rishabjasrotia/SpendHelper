import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spendhelper/drawer/mydrawer.dart';
import 'package:spendhelper/handler/gsheethandler.dart';

double defaultRadius = 8.0;
const double _cardWidth = 115;

Future<List> fetchFutureTotal() async {
  final ss = await gSheetLoader();
  // get worksheet by its title
  var sheet = ss.worksheetByTitle('Overall');
  var familyTotalExpense = await sheet?.values.value(column: 4, row: 2);
  return Future.value([familyTotalExpense, 'Family Expense']);
}

class CardBasicRoute extends StatefulWidget {
  const CardBasicRoute({super.key});

  @override
  CardBasicRouteState createState() => CardBasicRouteState();
}

class CardBasicRouteState extends State<CardBasicRoute> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: MyDrawer("Home"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //color: Colors.teal[800],
                    color: MyColorsSample.primary,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "Family Exepnse\n",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 0.5,
                          height: 0,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 15,
                            ),
                            const Text(
                              "March 19, 2023",
                              style: TextStyle(color: Colors.white),
                            ),
                            const Spacer(),
                            IconButton(
                              icon:
                                  const Icon(Icons.event, color: Colors.white),
                              onPressed: () {},
                            ),
                            Container(
                              width: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 2),
                Expanded(
                  flex: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    color: MyColorsSample.primary,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 15,
                            ),
                            const Text(
                              "Call",
                              style: TextStyle(color: Colors.white),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.white),
                              onPressed: () {},
                            ),
                            Container(
                              width: 4,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text(
                            "John Smith \nTek",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 10),
            //..................................................................gradient card view
            gradientCardSample(),
          ],
        ),
      ),
     
    );
  }

  Widget gradientCardSample() {
    return FutureBuilder(
      future: fetchFutureTotal(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          return Container(
            height: 200,
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
                              margin: EdgeInsets.only(left: (15 * index).toDouble()),
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
                Text(snapshot.data![0],
                  style: TextStyle(fontSize: 24, color: Colors.white))
              ],
            ),
          );
        }
         // By default show a loading spinner.
        return const CircularProgressIndicator();
      }
    );
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
