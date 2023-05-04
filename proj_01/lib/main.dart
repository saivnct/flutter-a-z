import 'package:flutter/material.dart';
import 'package:proj_01/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        // body: GradientContainer(
        //   colors: [
        //     Colors.deepPurple,
        //     Color.fromARGB(255, 156, 126, 208),
        //   ],
        // ),

        body: GradientContainer.purple(),
      ),
    ),
  );
}
