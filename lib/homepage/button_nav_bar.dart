// import 'package:flutter/material.dart';

// class _BottomNavBar extends StatefulWidget {
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<_BottomNavBar> {
//   int _currentIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, '/home');
//         break;
//       case 1:
//         Navigator.pushNamed(context, '/journaling');
//         break;
//       case 2:
//         Navigator.pushNamed(context, '/mood_tracking');
//         break;
//       case 3:
//         Navigator.pushNamed(context, '/analysis');
//         break;
//       case 4:
//         Navigator.pushNamed(context, '/settings');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return BottomNavigationBar(
//       currentIndex: _currentIndex,
//       onTap: _onItemTapped,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'Journal'),
//         BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.track_changes), label: 'Analysis'),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//       ],
//       selectedItemColor: Colors.purple,
//       unselectedItemColor: Colors.grey,
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//       iconSize: isSmallScreen ? 20 : 24,
//     );
//   }
// }


import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/journaling');
        break;
      case 2:
        Navigator.pushNamed(context, '/mood_tracking');
        break;
      case 3:
        Navigator.pushNamed(context, '/analysis');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'Journal'),
        BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
        BottomNavigationBarItem(
            icon: Icon(Icons.track_changes), label: 'Analysis'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: isSmallScreen ? 20 : 24,
    );
  }
}