import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj_04/data/dummy_data.dart';

//Provider class is often used for final static dummy data
final mealsProvider = Provider((ref) {
  return dummyMeals;
});
