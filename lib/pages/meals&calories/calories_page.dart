import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';


class CaloriesPage extends StatelessWidget {
  const CaloriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 255, 247, 251),
      appBar: AppBar(
        title: const Text("Calorie Summary"),
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
         backgroundColor: const Color.fromARGB(255, 248, 115, 197),
      ),
      body: Consumer<MealProvider>(
        builder: (context, provider, _) {
          if (!provider.isLoaded) {
            
            return const Center(child: CircularProgressIndicator());
          }

          final totalCalories = provider.todayCalories;
          final meals = provider.todayMeals;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Colors.green.shade50,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Calorie Intake",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "$totalCalories kcal",
                          style: TextStyle(
                            fontSize: 36,
                            color: Color.fromARGB(255, 247, 168, 207),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${meals.length} meals added today",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Meals Today",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: meals.isEmpty
                      ? const Center(child: Text("No meals added today."))
                      : ListView.builder(
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            final meal = meals[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: Image.network(
                                  meal.thumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(meal.name),
                                subtitle: Text("${meal.calories} kcal"),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Clear Today Meals"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 247, 168, 207),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    provider.clearTodayMeals();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Today's meals cleared.")),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
