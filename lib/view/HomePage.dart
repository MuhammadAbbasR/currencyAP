import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import 'Calculator.dart';
import 'Conversion.dart';
import 'Favourite.dart';
import 'History.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    CurrencyConverterPage(),
    FavoritesPage(),
    HistoryPage(),
    CalculatorPage()

  ];

  void setScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.black,
        barItems: [
          BarItem(title: "Home", icon: Icons.swap_horiz),
          BarItem(title: "Favourites", icon: Icons.star),
          BarItem(title: "History", icon: Icons.history),
          BarItem(title: "Stats", icon: Icons.show_chart),
        ],
        selectedIndex: _selectedIndex,
        onButtonPressed: setScreen,
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        iconSize: 30,
      ),
    );
  }
}
