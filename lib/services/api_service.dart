
import 'package:dio/dio.dart';

import 'package:meal_plan_final_app/models/exercise.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://exercisedb.p.rapidapi.com',
      headers: {
        'X-RapidAPI-Key': '7211f35b0bmsh9c73c84fe01506dp11d891jsn2dd826b1ceba', 
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
      },
    ),
  );

  Future<List<Exercise>> fetchExercisesByBodyPart(String bodyPart) async {
    final response = await dio.get('/exercises/bodyPart/$bodyPart');
    return (response.data as List)
        .map((json) => Exercise.fromJson(json))
        .toList();
  }
}