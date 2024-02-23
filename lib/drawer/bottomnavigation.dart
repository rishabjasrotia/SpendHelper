import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation(this.currentPage);

  final int currentPage;

  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF6200EE),
      selectedItemColor: Colors.white,
      currentIndex: this.currentPage, 
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (value) {
        // Respond to item press.
        selectedItem(context, value);
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Personal',
          icon: Icon(Icons.person_sharp),
        ),
        BottomNavigationBarItem(
          label: 'Family',
          icon: Icon(Icons.family_restroom),
        ),
        BottomNavigationBarItem(
          label: 'Credit',
          icon: Icon(Icons.credit_card),
        ),
        BottomNavigationBarItem(
          label: 'Bank',
          icon: Icon(Icons.account_balance),
        ),
      ],
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
      Navigator.pushReplacementNamed(context, "/banking");
      break;
    case 5:
      Navigator.pushReplacementNamed(context, "/banking");
      break;
  }
}

