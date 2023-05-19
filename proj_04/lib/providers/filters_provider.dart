import 'package:flutter_riverpod/flutter_riverpod.dart';

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
