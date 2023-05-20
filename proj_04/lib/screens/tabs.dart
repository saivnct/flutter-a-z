import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj_04/providers/favorites_provider.dart';
import 'package:proj_04/providers/filters_provider.dart';
import 'package:proj_04/screens/categories.dart';
import 'package:proj_04/screens/filter.dart';
import 'package:proj_04/screens/meals.dart';
import 'package:proj_04/widgets/drawer/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // void _setScreen(DrawerPageIdentifier identifier) async {
  //   //close the drawer
  //   Navigator.of(context).pop();
  //   if (identifier == DrawerPageIdentifier.filters) {
  //     //incase we want to setup a Drawer in 'FilterScreen'
  //     //if we only use Navigator.push() -> new 'FilterScreen' will be push into Screen Stack ontop of current 'TabsScreen'
  //     //replace current 'TabsScreen' in Screen Stack by 'FilterScreen'
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (ctx) => const FilterScreen(),
  //     //   ),
  //     // );

  //     //get the result wen navigate back from FilterScreen
  //     // final result = await Navigator.push<Map<Filter, bool>>(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (ctx) => const FilterScreen(),
  //     //   ),
  //     // );
  //   }
  // }

  void _setScreen(DrawerPageIdentifier identifier) {
    //close the drawer
    Navigator.of(context).pop();
    if (identifier == DrawerPageIdentifier.filters) {
      Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(
          builder: (ctx) => const FilterScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //'ref' is a property from riverpod
    final filteredMeals = ref.watch(filteredMealsProvider);
    String activePageTitle = 'Categories';
    Widget activePage = CategoriesScreen(meals: filteredMeals);

    if (_selectedPageIndex == 1) {
      final favoriteMeasl = ref.watch(favoriteMealsProvider);
      activePageTitle = 'Your Favorites';
      activePage = MealsScreen(meals: favoriteMeasl);
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
