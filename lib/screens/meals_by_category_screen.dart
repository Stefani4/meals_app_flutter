import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_model.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  static const routeName = '/meals-by-category';
  @override
  _MealsByCategoryScreenState createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService api = ApiService();
  List<MealModel> _meals = [];
  List<MealModel> _filtered = [];
  String _category = '';
  final _searchCtl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cat = ModalRoute.of(context)!.settings.arguments as String;
    if (cat != _category) {
      _category = cat;
      _loadMeals();
    }
  }

  void _loadMeals() async {
    final list = await api.fetchMealsByCategory(_category);
    setState(() {
      _meals = list;
      _filtered = list;
    });
  }

  void _onSearch(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _filtered = _meals);
      return;
    }

    final results = await api.searchMeals(q);
    final filtered = results.where((m) => m.name.toLowerCase().contains(q.toLowerCase())).where((m) => true).toList();
    final idsInCategory = _meals.map((e) => e.id).toSet();
    setState(() {
      _filtered = results.where((r) => idsInCategory.contains(r.id)).toList();
      if (_filtered.isEmpty) {
        _filtered = _meals.where((m) => m.name.toLowerCase().contains(q.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_category)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtl,
              decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search meals in this category'),
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final meal = _filtered[i];
                return GestureDetector(
                  onTap: () async {
                    final detail = await api.fetchMealDetail(meal.id);
                    Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: detail);
                  },
                  child: MealCard(meal: meal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}