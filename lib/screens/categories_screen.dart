import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import '../widgets/category_card.dart';
import 'meals_by_category_screen.dart';
import 'meal_detail_screen.dart';


class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService api = ApiService();
  late Future<List<CategoryModel>> categoriesFuture;
  List<CategoryModel> _all = [];
  List<CategoryModel> _filtered = [];
  final _searchCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoriesFuture = api.fetchCategories();
    categoriesFuture.then((value) {
      setState(() {
        _all = value;
        _filtered = value;
      });
    });
  }

  void _onSearch(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = _all.where((c) => c.name.toLowerCase().contains(lower) || c.description.toLowerCase().contains(lower)).toList();
    });
  }

  void _openRandom() async {
    final meal = await api.fetchRandomMeal();
    Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(onPressed: _openRandom, icon: Icon(Icons.shuffle)
          ),
      IconButton(
        icon: Icon(Icons.favorite, color: Colors.red),
        onPressed: () {
          Navigator.pushNamed(context, '/favorites');
          // or FavoritesScreen.routeName if you registered it:
          // Navigator.pushNamed(context, FavoritesScreen.routeName);
        },
      )],
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: categoriesFuture,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));


          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchCtl,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search categories'),
                  onChanged: _onSearch,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9, crossAxisSpacing: 8, mainAxisSpacing: 8),
                  itemCount: _filtered.length,
                  itemBuilder: (ctx, i) {
                    final cat = _filtered[i];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(MealsByCategoryScreen.routeName, arguments: cat.name),
                      child: CategoryCard(category: cat),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}