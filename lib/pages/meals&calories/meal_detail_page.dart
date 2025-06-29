import 'package:flutter/material.dart';
import 'package:meal_plan_final_app/models/meal.dart';
import 'package:meal_plan_final_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class MealDetailPage extends StatelessWidget {
  final Meal meal;

  const MealDetailPage({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MealProvider>(context);
    final isFavorite = provider.isFavorite(meal);

    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 247, 251),
      appBar: AppBar(
        title: Text(meal.name),
         backgroundColor: const Color.fromARGB(255, 248, 115, 197),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              if (isFavorite) {
                provider.removeFavorite(meal);
                _showSnack(context, "Removed from favorites");
              } else {
                provider.addFavorite(meal);
                _showSnack(context, "Added to favorites");
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⬆️ صورة الوجبة
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    meal.thumbnail,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "${meal.calories} kcal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 247, 168, 207),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 💡 كروت الأكشن
            _ActionCard(
              color: const Color.fromARGB(255, 255, 197, 220),
              iconColor: const Color.fromARGB(255, 117, 77, 97),
              title: "Add to Today's Plan",
              subtitle: "Track it in your daily calories",
              icon: Icons.today,
              onTap: () {
                provider.addMealToToday(meal);
                _showSnack(context, "Meal added to today's plan");
              },
            ),
            const SizedBox(height: 14),
            _ActionCard(
              color: const Color.fromARGB(255, 255, 215, 230),
              iconColor: isFavorite
                  ? Colors.redAccent
                  : const Color.fromARGB(255, 247, 168, 207),
              title: isFavorite ? "Remove from Favorites" : "Add to Favorites",
              subtitle: isFavorite
                  ? "Remove from your saved meals"
                  : "Add to your favorite list",
              icon: isFavorite ? Icons.remove_circle : Icons.favorite,
              onTap: () {
                if (isFavorite) {
                  provider.removeFavorite(meal);
                  _showSnack(context, "Removed from favorites");
                } else {
                  provider.addFavorite(meal);
                  _showSnack(context, "Added to favorites");
                }
              },
            ),

            const SizedBox(height: 26),

            // 🧾 المكونات
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...meal.ingredients.map(
              (ing) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 242, 248),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: Color.fromARGB(255, 247, 168, 207)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ing,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionCard extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.color,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
