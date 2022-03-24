import 'package:club_app/constants/constants.dart';
import 'package:flutter/material.dart';



Widget bottomNavBar(BuildContext context, {int currentIndex,}) {
  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: colorPrimary,
    ),
    child: BottomNavigationBar(
      backgroundColor: bottomNavigationBackground,
      selectedItemColor: navigationItemSelectedColor,
      unselectedItemColor: navigationItemUnSelectedColor,
      selectedFontSize: 12,
      unselectedFontSize: 10,

      showUnselectedLabels: true,
      currentIndex: currentIndex,
      // onTap: _onTabTapped,
      // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          title: const Text('Events'),
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.local_activity),
        //   title: const Text('Vouchers'),
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_bar),
          title: const Text('Table'),
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.star),
        //   title: const Text('Bidding'),
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: const Text('Cart'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          title: const Text('Menu'),
        )
      ],
    ),
  );
}
