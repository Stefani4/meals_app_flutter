import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../services/api_service.dart';
import '../models/meal_model.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites';

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService favSvc = FavoritesService();
  final ApiService api = ApiService();

  List<MealModel> _favoriteMeals = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteMeals();
  }

  Future<void> _loadFavoriteMeals() async {
    setState(() => _loading = true);

    List<MealModel> meals = [];

    for (String id in favSvc.favorites) {
      try {
        final detail = await api.fetchMealDetail(id);
        meals.add(
          MealModel(id: detail.id, name: detail.name, thumb: detail.thumb),
        );
      } catch (_) {}
    }

    setState(() {
      _favoriteMeals = meals;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Meals")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _favoriteMeals.isEmpty
          ? Center(child: Text("No favorite meals yet ❤️"))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _favoriteMeals.length,
        itemBuilder: (ctx, i) {
          final meal = _favoriteMeals[i];
          return GestureDetector(
            onTap: () async {
              final detail = await api.fetchMealDetail(meal.id);
              Navigator.of(context).pushNamed(
                MealDetailScreen.routeName,
                arguments: detail,
              );
            },
            child: MealCard(meal: meal),
          );
        },
      ),
    );
  }
}
