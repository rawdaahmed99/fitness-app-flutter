import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/pages/meals&calories/category_meals_page.dart';
import 'package:meal_plan_final_app/services/meal_service.dart';
import 'package:meal_plan_final_app/widgets/drawer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 255, 247, 251),
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 248, 115, 197),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: const Text("All Meal Categories"),
      ),
      drawer: const DrawerWidget(),
      body: FutureBuilder<List<String>>(
        future: MealService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final category = snapshot.data![index];
              return ListTile(
                title: Text(category),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryMealsPage(category: category),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}