import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/pages/meals&calories/calories_page.dart';
import 'package:meal_plan_final_app/pages/meals&calories/favorites_page.dart';
import 'package:meal_plan_final_app/pages/meals&calories/history_page.dart';
import 'package:meal_plan_final_app/pages/meals&calories/home_page.dart';
import 'package:meal_plan_final_app/pages/meals&calories/meal_times_page.dart';
import 'package:meal_plan_final_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MealProvider(),
      child: MealPlannerApp(),
    ),
  );
}

class MealPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal Planner',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/', // ✅ 
      routes: {
        '/': (_) => MealTimesPage(),
        '/all': (_) => HomePage(),
        '/favorites': (_) => FavoritesPage(),
        '/calories': (_) => const CaloriesPage(), 
        '/history': (_) => HistoryPage(),
      },
    );
  }
}
