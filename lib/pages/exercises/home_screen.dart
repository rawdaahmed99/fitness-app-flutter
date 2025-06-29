import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_plan_final_app/cubit/favorites_cubit.dart';
import 'package:meal_plan_final_app/pages/exercises/exercises_screen.dart';
import 'package:meal_plan_final_app/pages/exercises/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TrainingPlan> plans = [
    TrainingPlan('Back', 'back', Icons.fitness_center, const Color.fromARGB(255, 150, 0, 87)),
    TrainingPlan('Cardio', 'cardio', Icons.favorite, Color.fromARGB(255, 253, 130, 216)),
    TrainingPlan('Chest', 'chest', Icons.self_improvement, Colors.blueGrey),
    TrainingPlan('Lower Arms', 'lower arms', Icons.pan_tool_alt, Colors.teal),
    TrainingPlan('Lower Legs', 'lower legs', Icons.directions_walk, const Color.fromARGB(255, 253, 130, 216)),
    TrainingPlan('Neck', 'neck', Icons.accessibility_new, Colors.brown),
    TrainingPlan('Shoulders', 'shoulders', Icons.sync_alt, Colors.blueGrey),
    TrainingPlan('Upper Arms', 'upper arms', Icons.front_hand, const Color.fromARGB(255, 150, 0, 87)),
    TrainingPlan('Upper Legs', 'upper legs', Icons.directions_run, Colors.cyan),
    TrainingPlan('Waist', 'waist', Icons.accessibility, Color.fromARGB(255, 253, 130, 216)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: plans.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2.5,
                ),
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: BlocProvider.of<FavoritesCubit>(context),
                            child: ExercisesScreen(bodyPart: plan.bodyPart),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: plan.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: plan.color.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(plan.icon, size: 34, color: plan.color),
                          const SizedBox(height: 10),
                          Text(
                            plan.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: plan.color.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
      
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
       
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.sports_gymnastics, size: 28, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'My Workouts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.favorite, size: 28, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const  FavoritesScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrainingPlan {
  final String title;
  final String bodyPart;
  final IconData icon;
  final Color color;

  TrainingPlan(this.title, this.bodyPart, this.icon, this.color);
}