import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class MealProvider extends ChangeNotifier {
  Map<String, List<Meal>> _dailyMeals = {};
  List<Meal> _favorites = [];

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _dailyCalorieLimit = 2000;
  int get dailyCalorieLimit => _dailyCalorieLimit;

  late Future<void> loadComplete;

  MealProvider() {
    loadComplete = _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    final favList = prefs.getString('favorites');
    if (favList != null) {
      final list = jsonDecode(favList);
      _favorites = List<Map<String, dynamic>>.from(list)
          .map((e) => Meal.fromJson(e))
          .toList();
    }

    final daily = prefs.getString('dailyMeals');
    if (daily != null) {
      final map = jsonDecode(daily) as Map<String, dynamic>;
      _dailyMeals = map.map((date, mealsJson) {
        final meals =
            (mealsJson as List).map((e) => Meal.fromJson(e)).toList();
        return MapEntry(date, meals);
      });
    }

    _dailyCalorieLimit = prefs.getInt('dailyCalorieLimit') ?? 2000;

    _isLoaded = true;
    notifyListeners();
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'favorites',
      jsonEncode(_favorites.map((m) => m.toJson()).toList()),
    );
    prefs.setString(
      'dailyMeals',
      jsonEncode(
        _dailyMeals.map(
          (key, meals) =>
              MapEntry(key, meals.map((m) => m.toJson()).toList()),
        ),
      ),
    );
    prefs.setInt('dailyCalorieLimit', _dailyCalorieLimit);
  }

  void setDailyCalorieLimit(int newLimit) async {
    _dailyCalorieLimit = newLimit;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyCalorieLimit', _dailyCalorieLimit);
    notifyListeners();
  }

  int getTotalCaloriesForDay(String date) {
    final meals = _dailyMeals[date] ?? [];
    return meals.fold(0, (sum, m) => sum + m.calories);
  }

  List<Meal> get favorites => _favorites;

  List<Meal> get todayMeals {
    final today = _getTodayKey();
    return _dailyMeals[today] ?? [];
  }

  int get todayCalories =>
      todayMeals.fold(0, (sum, meal) => sum + meal.calories);

  Map<String, int> get allDaysCalories {
    return _dailyMeals.map((key, meals) =>
        MapEntry(key, meals.fold(0, (sum, meal) => sum + meal.calories)));
  }

  Map<String, List<Meal>> getMealHistory() {
    return Map.from(_dailyMeals);
  }

  void addMealToToday(Meal meal) {
    final today = _getTodayKey();
    _dailyMeals.putIfAbsent(today, () => []);
    _dailyMeals[today]!.add(meal);
    _save();
    notifyListeners();
  }

  void removeMealFromToday(Meal meal) {
    final today = _getTodayKey();
    _dailyMeals[today]?.removeWhere((m) => m.id == meal.id);
    _save();
    notifyListeners();
  }

  void clearTodayMeals() {
    final today = _getTodayKey();
    _dailyMeals[today]?.clear();
    _save();
    notifyListeners();
  }

  void addFavorite(Meal meal) {
    if (!_favorites.any((m) => m.id == meal.id)) {
      _favorites.add(meal);
      _save();
      notifyListeners();
    }
  }

  void removeFavorite(Meal meal) {
    _favorites.removeWhere((m) => m.id == meal.id);
    _save();
    notifyListeners();
  }

  bool isFavorite(Meal meal) =>
      _favorites.any((m) => m.id == meal.id);

  void clearFavorites() {
    _favorites.clear();
    _save();
    notifyListeners();
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
