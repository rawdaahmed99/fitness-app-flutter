import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/models/exercise.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  String getEnglishDescription(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('push')) {
      return 'A great upper body exercise targeting the chest, shoulders, and triceps.';
    } else if (lower.contains('squat')) {
      return 'An excellent compound movement to strengthen legs and glutes.';
    } else if (lower.contains('plank')) {
      return 'Perfect for building core strength and stability.';
    } else {
      return 'This exercise helps improve overall fitness and muscle tone.';
    }
  }

  String getVideoUrl(String name) {
    if (name.toLowerCase().contains('push')) {
      return 'https://www.youtube.com/watch?v=_l3ySVKYVJ8';
    } else if (name.toLowerCase().contains('squat')) {
      return 'https://www.youtube.com/watch?v=aclHkVaku9U';
    } else if (name.toLowerCase().contains('plank')) {
      return 'https://www.youtube.com/watch?v=B296mZDhrP4';
    } else {
      return 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(name + " exercise")}';
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final description = getEnglishDescription(exercise.name);
    final videoUrl = getVideoUrl(exercise.name);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 251),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 115, 197),
        elevation: 0.4,
        title: Text(
          exercise.name,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الكارت المعدل مع الظل
            Card(
              elevation: 8, // زيادة ارتفاع الظل
              shadowColor: Colors.pink.withOpacity(0.3), // لون الظل
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  exercise.gifUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 240,
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // بقية العناصر
            Card(
              elevation: 4,
              shadowColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 16, 
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shadowColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Repetitions',
                      style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '10 - 15 reps per set',
                      style: TextStyle(
                          fontSize: 16, 
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _launchURL(videoUrl),
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Watch Tutorial Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 248, 115, 197),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6, // ظل للزر
                  shadowColor: Colors.indigo.withOpacity(0.3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}