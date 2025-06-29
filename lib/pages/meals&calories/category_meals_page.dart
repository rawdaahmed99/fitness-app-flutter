import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/models/meal.dart';
import 'package:meal_plan_final_app/services/meal_service.dart';
import 'meal_detail_page.dart';

class CategoryMealsPage extends StatelessWidget {
  final String category;
  const CategoryMealsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 251),
      appBar: AppBar(
        title: Text("$category Meals"),
     backgroundColor: const Color.fromARGB(255, 248, 115, 197),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
          ),
        ],
      ),
      body: Column(
        children: [
         
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: Row(
          //     children: const [
          //       Icon(Icons.filter_alt, color: Colors.green),
          //       SizedBox(width: 8),
          //       Text(
          //         "Filter options coming soon...",
          //         style: TextStyle(fontSize: 14, color: Colors.grey),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: MealService.getMealsByCategory(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No meals found."));
                }

                final meals = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MealDetailPage(meal: meal)),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              // صورة الخلفية
                              Image.network(
                                meal.thumbnail,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              // طبقة شفافة
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                              // اسم الوجبة والسهم
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        meal.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
