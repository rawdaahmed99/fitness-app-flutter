// lib/cubit/favorites_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/exercise.dart';

class FavoritesState {
  final List<Exercise> favorites;

  FavoritesState(this.favorites);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesState([])) {
    loadFavorites();
  }

  void addFavorite(Exercise exercise) {
    final updatedFavorites = List<Exercise>.from(state.favorites)..add(exercise);
    emit(FavoritesState(updatedFavorites));
    saveFavorites();
  }

  void removeFavorite(Exercise exercise) {
    final updatedFavorites =
        state.favorites.where((item) => item.id != exercise.id).toList();
    emit(FavoritesState(updatedFavorites));
    saveFavorites();
  }

  bool isFavorite(Exercise exercise) {
    return state.favorites.any((item) => item.id == exercise.id);
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteJsonList =
        state.favorites.map((exercise) => jsonEncode(exercise.toJson())).toList();
    await prefs.setStringList('favorites', favoriteJsonList);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteJsonList = prefs.getStringList('favorites');

    if (favoriteJsonList != null) {
      final loadedFavorites = favoriteJsonList
          .map((jsonStr) => Exercise.fromJson(jsonDecode(jsonStr)))
          .toList();
      emit(FavoritesState(loadedFavorites));
    }
  }
}
