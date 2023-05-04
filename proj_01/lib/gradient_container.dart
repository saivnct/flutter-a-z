import 'package:flutter/material.dart';
import 'package:proj_01/dice_roller.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

/*
StatelessWidget 
- widget that has internal data never changed
- only update the screen if parent Widgets were updated("re-rendered")
- we should use as often as possible
*/
class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key, required this.colors});

  const GradientContainer.purple({super.key})
      : colors = const [
          Colors.deepPurple,
          Colors.indigo,
        ];

  final List<Color> colors;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: const Center(
        child: DiceRoller(),
      ),
    );
  }
}
