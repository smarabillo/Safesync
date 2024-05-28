import './menu_items/agencies_page.dart';
import './menu_items/information_page.dart';
import './menu_items/quickcall_page.dart';

import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1375E8),
      ),
      body: GridView.count(
      padding: EdgeInsets.all(10),
      crossAxisCount: 3, // 2 columns
      childAspectRatio: 1,
      children: [
      _MenuItem(
      icon: Icons.business,
      label: 'Agencies',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgenciesPage()),
        );
      },
      color: Colors.red,
    ),
    _MenuItem(
      icon: Icons.info,
      label: 'Information',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InformationPage()),
        );
      },
      color: Colors.orange,
    ),
    _MenuItem(
      icon: Icons.phone,
      label: 'Quick Call',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuickCallPage()),
        );
      },
      color: Colors.green,
    ),
  ],
)
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center, // <--- Add this
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}