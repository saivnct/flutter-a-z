import 'package:flutter/material.dart';
import 'package:proj_04/data/dummy_data.dart';
import 'package:proj_04/models/category.dart';
import 'package:proj_04/models/meal.dart';
import 'package:proj_04/screens/meals.dart';
import 'package:proj_04/widgets/category/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key, required this.meals, required this.onToggleFavorite});

  final List<Meal> meals;

  final void Function(Meal meal) onToggleFavorite;

  void _selectCategory(BuildContext context, Category category) {
    final mealsByCat =
        meals.where((meal) => meal.categories.contains(category.id)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: mealsByCat,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () => {
              _selectCategory(context, category),
            },
          )
      ],
    );
  }
}
