import 'package:dio/dio.dart';
import '../models/meal.dart';

class MealService {
  static final Dio _dio = Dio();

  static Future<List<String>> getCategories() async {
    try {
      final res = await _dio.get("https://www.themealdb.com/api/json/v1/1/list.php?c=list");
      final meals = res.data['meals'];
      if (meals != null && meals is List) {
        return meals.map<String>((e) => e['strCategory'] as String).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  static Future<List<Meal>> getMealsByCategory(String cat) async {
    try {
      final res = await _dio.get("https://www.themealdb.com/api/json/v1/1/filter.php?c=$cat");
      final meals = res.data['meals'];
      if (meals != null && meals is List) {
        return meals.map<Meal>((e) {
          return Meal(
            id: e['idMeal'],
            name: e['strMeal'],
            thumbnail: e['strMealThumb'],
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching meals for category '$cat': $e");
      return [];
    }
  }
}
