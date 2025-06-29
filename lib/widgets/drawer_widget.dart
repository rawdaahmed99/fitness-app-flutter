import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
        
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 247, 168, 207), 
            ),
            child: Text(
              "Meal Planner",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ),

        
          _buildDrawerItem(context, Icons.home, "Home", '/'),
          _buildDrawerItem(context, Icons.favorite, "Favorites", '/favorites'),
          _buildDrawerItem(context, Icons.history, "History", '/history'),
          _buildDrawerItem(context, Icons.local_fire_department, "Calories", '/calories'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 247, 168, 207)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
