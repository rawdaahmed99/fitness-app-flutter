import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/pages/meals&calories/category_meals_page.dart';
import 'package:meal_plan_final_app/widgets/drawer_widget.dart';

class MealTimesPage extends StatelessWidget {
  const MealTimesPage({super.key});

  final List<Map<String, dynamic>> mealTimes = const [
    {
      'title': 'Breakfast',
      'icon': Icons.free_breakfast,
      'image': 'breakfast.jpg',
      'categories': ['Breakfast', 'Miscellaneous', 'Vegetarian'],
    },
    {
      'title': 'Lunch',
      'icon': Icons.lunch_dining,
      'image': 'launch.jpg',
      'categories': ['Chicken', 'Beef', 'Pasta'],
    },
    {
      'title': 'Dinner',
      'icon': Icons.dinner_dining,
      'image': 'healthy-dinner-recipes.jpg',
      'categories': ['Seafood', 'Goat', 'Lamb'],
    },
    {
      'title': 'Snack',
      'icon': Icons.fastfood,
      'image': 'snack.jpg',
      'categories': ['Dessert', 'Side', 'Starter'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 251),
      appBar: AppBar(
        title: const Text('Meal Times'),
        backgroundColor: const Color.fromARGB(255, 248, 115, 197),
      ),
      drawer: const DrawerWidget(), 
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mealTimes.length,
        itemBuilder: (context, index) {
          final mealTime = mealTimes[index];
          final title = mealTime['title'];
          final icon = mealTime['icon'];
          final image = mealTime['image'];
          final categories = List<String>.from(mealTime['categories']);

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 220,
            child: Stack(
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                // Gradient overlay + content
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                // Text and buttons
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, size: 30, color: Colors.white),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories.map((category) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CategoryMealsPage(category: category),
                                  ),
                                );
                              },
                              child: Chip(
                                backgroundColor: Colors.white.withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                label: Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
