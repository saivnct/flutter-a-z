import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj_04/providers/meals_provider.dart';

enum Filter {
  glutenFee,
  lactoseFree,
  vegetarian,
  vegan,
}

const defaultFilters = {
  Filter.glutenFee: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  //pass initial data to super class
  FiltersNotifier() : super(defaultFilters);

  void updateFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final currentFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (currentFilters[Filter.glutenFee]! && !meal.isGlutenFree) {
      return false;
    }

    if (currentFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }

    if (currentFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }

    if (currentFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }

    return true;
  }).toList();
});
