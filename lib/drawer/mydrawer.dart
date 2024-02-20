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
            title: const Text('Home'),
            onTap: () {
              selectedItem(context, 0);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_sharp,
            ),
            title: const Text('Personal Expense'),
            onTap: () {
              selectedItem(context, 1);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.family_restroom,
            ),
            title: const Text('Family Expense'),
            onTap: () {
              selectedItem(context, 2);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.credit_card,
            ),
            title: const Text('Credit Expense'),
            onTap: () {
              selectedItem(context, 3);
            },
          ),    
          ListTile(
            leading: Icon(
              Icons.credit_card,
            ),
            title: const Text('Settings'),
            onTap: () {
              selectedItem(context, 4);
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
    case 0:
      Navigator.pushReplacementNamed(context, "/home");
      break;
    case 1:
      Navigator.pushReplacementNamed(context, "/personalExpense");
      break;
    case 2:
      Navigator.pushReplacementNamed(context, "/familyExpense");
      break;
    case 3:
      Navigator.pushReplacementNamed(context, "/creditExpense");
      break;
    case 4:
      Navigator.pushReplacementNamed(context, "/settings");
      break;
  }
}
