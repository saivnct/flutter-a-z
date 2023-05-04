import 'dart:math';
import 'package:flutter/material.dart';

final radomizer = Random();

/*
StatefulWidget 
- widget that has internal data changed frequently
- when state changes, the widget is re-rendered & the UI is updated
- when creating StatefulWidget - we always need 2 classes
*/
class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

/*
- the "_" means this is private class, access only in this file
*/
class _DiceRollerState extends State<DiceRoller> {
  var currentDiceRoll = 1;

  rollDice() {
    setState(() {
      //tell the class to re-execute 'build()'
      currentDiceRoll = radomizer.nextInt(6) + 1;
      // print('Changing img...');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/dice-$currentDiceRoll.png',
          width: 200,
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
              // padding: const EdgeInsets.all(20),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 28,
              )),
          child: const Text('Roll Dice'),
        )
      ],
    );
  }
}
