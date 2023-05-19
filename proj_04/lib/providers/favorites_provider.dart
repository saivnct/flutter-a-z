import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj_04/models/meal.dart';

//StateNotifierProvider class is optimized for data that can be changed
//StateNotifierProvider class work together with StateNotifier class

class FavoriteMealsStateNotifier extends StateNotifier<List<Meal>> {
  //pass initial data to super class
  FavoriteMealsStateNotifier() : super([]);

  //NOTE: is riverpod to update state must pass "NEW STATE OBJECT", we cannot directly manipulate on "current state object"
  bool toggleMealFavoriteStatus(Meal meal) {
    final isExisting = state.contains(meal);

    if (isExisting) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsStateNotifier, List<Meal>>(
  (ref) => FavoriteMealsStateNotifier(),
);
