import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/advisory_page.dart';
import 'pages/alerts_page.dart';
import 'pages/settings_page.dart';
import 'pages/registration_page.dart';
import 'pages/forecast_page.dart';
import 'pages/mandi_page.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const AgroAlertApp());
}

class AgroAlertApp extends StatelessWidget {
  const AgroAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroAlert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainScreen(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    AdvisoryPage(),
    ForecastPage(),
    AlertsPage(),
    MandiPage(),
    RegistrationPage(),
    SettingsPage(),
  ];

  final List<String> _titles = [
    '🌾 AgroAlert',
    '🌱 பயிர் ஆலோசனை',
    '🌤️ 7 நாள் வானிலை',
    '⚠️ Alerts',
    '🏪 மண்டி விலை',
    '📝 விவசாயி பதிவு',
    '⚙️ Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          // Profile Button
          IconButton(
            icon: const Icon(Icons.person,
                color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout,
                color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/login');
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) =>
            setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.agriculture),
              label: 'Advisory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud), label: 'Forecast'),
          BottomNavigationBarItem(
              icon: Icon(Icons.warning), label: 'Alerts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.store), label: 'Mandi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: 'பதிவு'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}