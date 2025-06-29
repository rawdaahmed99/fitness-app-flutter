import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_plan_final_app/cubit/favorites_cubit.dart';
import 'package:meal_plan_final_app/models/exercise.dart';
import 'package:meal_plan_final_app/pages/exercises/exercise_detail_screen.dart';
import 'package:meal_plan_final_app/services/api_service.dart';

class ExercisesScreen extends StatefulWidget {
  final String bodyPart;
  const ExercisesScreen({super.key, required this.bodyPart});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late Future<List<Exercise>> _exercisesFuture;

  final Map<String, String> bodyPartTitles = {
    'back': 'Back Exercises',
    'cardio': 'Cardio & Fitness',
    'chest': 'Chest Exercises',
    'lower arms': 'Lower Arms',
    'lower legs': 'Lower Legs',
    'neck': 'Neck Exercises',
    'shoulders': 'Shoulders',
    'upper arms': 'Upper Arms',
    'upper legs': 'Upper Legs',
    'waist': 'Waist & Abs',
    'abs': 'Abs',
  };

  String capitalizeEachWord(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _apiService.fetchExercisesByBodyPart(widget.bodyPart);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = context.read<FavoritesCubit>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 251),
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 115, 197),
        
        title: Text(
          bodyPartTitles[widget.bodyPart] ?? 'Exercises',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
       
        elevation: 0.4,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No exercises found.'));
          }

          final exercises = snapshot.data!;
          return BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  final isFavorite = favoritesCubit.isFavorite(exercise);
                  final exerciseName = capitalizeEachWord(exercise.name);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExerciseDetailScreen(exercise: exercise),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Image.network(
                              exercise.gifUrl,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                width: 110,
                                height: 110,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exerciseName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Reps: 10 - 15',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite ? const Color.fromARGB(255, 248, 115, 197) : Colors.grey,
                            ),
                            onPressed: () {
                              isFavorite
                                  ? favoritesCubit.removeFavorite(exercise)
                                  : favoritesCubit.addFavorite(exercise);
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
