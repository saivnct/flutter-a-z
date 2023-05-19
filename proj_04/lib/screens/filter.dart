import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj_04/providers/filters_provider.dart';
// import 'package:proj_04/screens/tabs.dart';
// import 'package:proj_04/widgets/drawer/main_drawer.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() {
    return _FilterScreenState();
  }
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  //because we cannot access 'widget' here => we must override  initState() to access it!!!
  var _glutenFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegetarianFilterSet = false;
  var _veganFilterSet = false;

  // void _setScreen(DrawerPageIdentifier identifier) {
  //   //close the drawer
  //   Navigator.of(context).pop();
  //   if (identifier == DrawerPageIdentifier.meals) {
  //     //if we only use Navigator.push() -> new 'TabsScreen' will be push into Screen Stack ontop of current 'FilterScreen'
  //     //=> replace current 'FilterScreen' in Screen Stack by 'TabsScreen'
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (ctx) => const TabsScreen(),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final selectedFilters = ref.watch(filtersProvider);
    _glutenFreeFilterSet = selectedFilters[Filter.glutenFee]!;
    _lactoseFreeFilterSet = selectedFilters[Filter.lactoseFree]!;
    _vegetarianFilterSet = selectedFilters[Filter.vegetarian]!;
    _veganFilterSet = selectedFilters[Filter.vegan]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      // drawer: MainDrawer(onSelectScreen: _setScreen),

      //'WillPopScope' widget allow us to control Navigator.pop process
      body: WillPopScope(
        //onWillPop need return a Future<bool> => so we wrap this function in a 'async' keyword
        onWillPop: () async {
          //manually pop and pass a data(in Dictionary)
          Navigator.of(context).pop({
            Filter.glutenFee: _glutenFreeFilterSet,
            Filter.lactoseFree: _lactoseFreeFilterSet,
            Filter.vegetarian: _vegetarianFilterSet,
            Filter.vegan: _veganFilterSet,
          });

          //need a return that determine whether we want to navigate back or not
          return false; //we return false here because we've just call pop() above
        },
        child: Column(
          children: [
            SwitchListTile(
              value: _glutenFreeFilterSet,
              onChanged: (isCheked) {
                setState(() {
                  _glutenFreeFilterSet = isCheked;
                });
              },
              title: Text(
                'Gluten-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              subtitle: Text(
                'Only include gluten-free meals',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _lactoseFreeFilterSet,
              onChanged: (isCheked) {
                setState(() {
                  _lactoseFreeFilterSet = isCheked;
                });
              },
              title: Text(
                'Lactose-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              subtitle: Text(
                'Only include lactose-free meals',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _vegetarianFilterSet,
              onChanged: (isCheked) {
                setState(() {
                  _vegetarianFilterSet = isCheked;
                });
              },
              title: Text(
                'Vegetarian',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              subtitle: Text(
                'Only include vegetarian meals',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _veganFilterSet,
              onChanged: (isCheked) {
                setState(() {
                  _veganFilterSet = isCheked;
                });
              },
              title: Text(
                'Vegan',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              subtitle: Text(
                'Only include vegan meals',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
