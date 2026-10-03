import 'package:flutter/material.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/sos_floating_button.dart';
import 'package:psicoapp/screens/home_screen.dart';
import 'package:psicoapp/screens/journal_screen.dart';
import 'package:psicoapp/screens/challenges_screen.dart';
import 'package:psicoapp/screens/tools_screen.dart';
import 'package:psicoapp/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onNavigateToJournal: () => _onTabTapped(1),
        onNavigateToChallenges: () => _onTabTapped(2),
        onNavigateToTools: () => _onTabTapped(3),
      ),
      const JournalScreen(),
      const ChallengesScreen(),
      const ToolsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      floatingActionButton: const SosFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          indicatorColor: AppTheme.primaryLight,
          elevation: 0,
          backgroundColor: Colors.white,
          height: 68,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primaryColor),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded, color: AppTheme.primaryColor),
              label: 'Diario',
            ),
            NavigationDestination(
              icon: Icon(Icons.center_focus_strong_outlined),
              selectedIcon: Icon(Icons.center_focus_strong_rounded, color: AppTheme.primaryColor),
              label: 'Retos',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded, color: AppTheme.primaryColor),
              label: 'Herramientas',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryColor),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
