import 'package:flutter/material.dart';
import 'package:lab2/screens/categories_screen.dart';
import 'package:lab2/screens/favorites_screen.dart';
import 'package:lab2/screens/meal_detail_screen.dart';
import 'package:lab2/screens/meals_by_category_screen.dart';

void main() {
  runApp(MealsApp());
}


class MealsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: {
        '/': (ctx) => CategoriesScreen(),
        MealsByCategoryScreen.routeName: (ctx) => MealsByCategoryScreen(),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
        FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
