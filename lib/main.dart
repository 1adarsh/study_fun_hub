import 'package:flutter/material.dart';

import 'doodle.dart'; // Make sure this import is at the top!
import 'pomodoro.dart'; // Make sure this import is at the top!

void main() {
  runApp(const StudyFunHub());
}

class StudyFunHub extends StatelessWidget {
  const StudyFunHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study & Fun Hub',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepPurpleAccent,
      ),
      home: const AppHub(),
    );
  }
}

class AppHub extends StatefulWidget {
  const AppHub({super.key});

  @override
  State<AppHub> createState() => _AppHubState();
}

class _AppHubState extends State<AppHub> {
  int _selectedIndex = 0;

  // 1. The _engines list MUST live here, inside the state manager!
  final List<Widget> _engines = const [
    AmbientPomodoroRoom(), // The real Study Engine you just built
    DoodleCanvas(), // The doodle canvas
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: isWideScreen
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(
                    color: Colors.deepPurpleAccent,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_rounded),
                      label: Text('Study'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.sports_esports_rounded),
                      label: Text('Fun'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _engines,
                  ),
                ),
              ],
            )
          : IndexedStack(index: _selectedIndex, children: _engines),
      bottomNavigationBar: isWideScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.deepPurpleAccent,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_rounded),
                  label: 'Study Engine',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_esports_rounded),
                  label: 'Fun Engine',
                ),
              ],
            ),
    );
  }
}

// --- PLACEHOLDER SCREENS ---
// 2. StudyEngineScreen is completely deleted. Only the Fun placeholder remains.

class FunEngineScreen extends StatelessWidget {
  const FunEngineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '🎮 Fun Engine',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
