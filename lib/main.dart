import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_plan_final_app/cubit/favorites_cubit.dart';

import 'package:meal_plan_final_app/providers/meal_provider.dart';
import 'package:meal_plan_final_app/welcom_screen.dart';
import 'package:provider/provider.dart';



void main() {
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()),
        BlocProvider(create: (_) => FavoritesCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness & Health',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),

    );
  }
}
