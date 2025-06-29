import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/providers/meal_provider.dart';
import 'package:meal_plan_final_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Color _getBarColor(double ratio) {
    if (ratio < 0.6) return Colors.blue;
    if (ratio < 1.0) return Colors.green;
    if (ratio <= 1.2) return Colors.orange;
    return Colors.red;
  }

  String _getStatusText(double ratio) {
    if (ratio < 0.6) return "Too Low";
    if (ratio < 1.0) return "Good";
    if (ratio <= 1.2) return "High";
    return "Exceeded";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MealProvider>(context);
    final history = provider.getMealHistory();
    final limit = provider.dailyCalorieLimit;

    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 255, 247, 251),
      appBar: AppBar(
        title: const Text("Meal History"),
          backgroundColor: const Color.fromARGB(255, 248, 115, 197),
      ),
      drawer: const DrawerWidget(),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No meal history yet.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history.entries.elementAt(index);
                final date = entry.key;
                final meals = entry.value;
                final totalCalories =
                    meals.fold<int>(0, (sum, m) => sum + m.calories);
                final ratio = totalCalories / limit;
                final barColor = _getBarColor(ratio);
                final status = _getStatusText(ratio);

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // التاريخ والسعرات والحالة
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  "$totalCalories kcal",
                                  style: TextStyle(
                                    color: barColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  ratio > 1.0
                                      ? Icons.warning_amber
                                      : Icons.check_circle,
                                  color: ratio > 1.0
                                      ? Colors.red
                                      : Colors.green,
                                  size: 20,
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ✅ Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: ratio.clamp(0.0, 1.2),
                            minHeight: 14,
                            backgroundColor: Colors.grey.shade300,
                            color: barColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Status: $status",
                          style: TextStyle(
                            fontSize: 13,
                            color: barColor,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ✅ الوجبات
                        Column(
                          children: meals
                              .map(
                                (meal) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      meal.thumbnail,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    meal.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text("${meal.calories} kcal"),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
