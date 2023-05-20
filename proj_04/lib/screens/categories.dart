import 'package:flutter/material.dart';
import 'package:proj_04/data/dummy_data.dart';
import 'package:proj_04/models/category.dart';
import 'package:proj_04/models/meal.dart';
import 'package:proj_04/screens/meals.dart';
import 'package:proj_04/widgets/category/category_grid_item.dart';

//to have an explicit animations we need to work with StatefulWidget
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.meals});

  final List<Meal> meals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

//if we have multiple AnimationControllers -> use TickerProviderStateMixin
//if we have only 1 AnimationController -> use SingleTickerProviderStateMixin
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  //'late' keyword tells Dart that the variable will be init later at the 1st we time using it
  late AnimationController
      _animationController; //AnimationController cannot be created at the time class created => we will init it in initState()

  @override
  void initState() {
    super.initState();
    // _animationController will able to get frame rate information to fire animation once per frame(typically 60 times per second)
    _animationController = AnimationController(
      //vsync responsible for making sure that this animation executes for every frame (typically 60 times per second) to provide a smooth animation
      vsync: this,
      duration: const Duration(milliseconds: 300),
      //_animationController.value will be changed from lowerBound to upperBound
      lowerBound: 0,
      upperBound: 1,
    );

    //to start explicit Animation, we must manually start it
    _animationController.forward();
    // _animationController.repeat();
    // _animationController.stop();
  }

  @override
  void dispose() {
    //Do clean up works

    //make sure _animationController is removed from device memory when this 'CategoriesScreen' widget is removed
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final mealsByCat = widget.meals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: mealsByCat,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      //the child will not be rebuilt and reevaluated every 60 times per second
      child: GridView(
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
      ),

      //solution 1:
      //only Padding widget will be rebuilt on animation, not the child
      // builder: (ctx, child) => Padding(
      //   //_animationController.value will be changed from lowerBound to upperBound
      //   padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
      //   child: child,
      // ),

      //solution 2: using Transition
      //SlideTransition animates the movement of a widget from 1 position to another
      builder: (ctx, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3), //start with 30% offset down in y-axis
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            //curve determine how the transition between begin and end state will be spread over the available animation time
            //easeInOut - start slow - end slow => smoothly effect
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
    );
  }
}
