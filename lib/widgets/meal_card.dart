import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../models/meal_model.dart';
import '../services/favorites_service.dart';

class MealCard extends StatefulWidget {
  final MealModel meal;

  MealCard({required this.meal});

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  final FavoritesService favSvc = FavoritesService();

  @override
  Widget build(BuildContext context) {
    bool isFav = favSvc.isFavorite(widget.meal.id);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(widget.meal.thumb, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.meal.name, style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          LikeButton(
            isLiked: isFav,
            onTap: (liked) async {
              await favSvc.toggleFavorite(widget.meal.id);
              setState(() {});
              return !liked;
            },
          ),
        ],
      ),
    );
  }
}
