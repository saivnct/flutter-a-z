import 'package:flutter/material.dart';
import 'package:proj_04/data/dummy_data.dart';
import 'package:proj_04/models/meal.dart';
import 'package:proj_04/screens/categories.dart';
import 'package:proj_04/screens/filter.dart';
import 'package:proj_04/screens/meals.dart';
import 'package:proj_04/widgets/drawer/main_drawer.dart';

const defaultFilters = {
  Filter.glutenFee: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = defaultFilters;

  void _showInfoMsg(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMsg('Meal is no longer a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMsg('Mark as a favorite');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(DrawerPageIdentifier identifier) async {
    //close the drawer
    Navigator.of(context).pop();
    if (identifier == DrawerPageIdentifier.filters) {
      //incase we want to setup a Drawer in 'FilterScreen'
      //if we only use Navigator.push() -> new 'FilterScreen' will be push into Screen Stack ontop of current 'TabsScreen'
      //replace current 'TabsScreen' in Screen Stack by 'FilterScreen'
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (ctx) => const FilterScreen(),
      //   ),
      // );

      //get the result wen navigate back from FilterScreen
      final result = await Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? defaultFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFee]! && !meal.isGlutenFree) {
        return false;
      }

      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }

      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }

      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }

      return true;
    }).toList();

    String activePageTitle = 'Categories';
    Widget activePage = CategoriesScreen(
        meals: filteredMeals, onToggleFavorite: _toggleMealFavoriteStatus);

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Your Favorites';
      activePage = MealsScreen(
        onToggleFavorite: _toggleMealFavoriteStatus,
        meals: _favoriteMeals,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
