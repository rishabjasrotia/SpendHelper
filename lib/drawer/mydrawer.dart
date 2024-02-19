import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer(this.currentPage);

  final String currentPage;
  
  @override
  Widget build(BuildContext context){
    return Drawer(
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
            title: const Text('Personal Expense'),
            onTap: () {
              selectedItem(context, 1);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Credit Expense'),
            onTap: () {
              selectedItem(context, 2);
            },
          ),
        ],
      ),
    );
  }
}

void selectedItem(BuildContext context, int index) {
  // Navigator.of(context).pop();
  switch (index) {
    case 1:
      Navigator.pushReplacementNamed(context, "/personalExpense");
      break;
    case 2:
      Navigator.pushReplacementNamed(context, "/creditExpense");
      break;
  }
}
