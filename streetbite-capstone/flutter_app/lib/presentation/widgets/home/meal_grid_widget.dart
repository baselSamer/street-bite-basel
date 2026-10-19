import 'package:flutter/material.dart';

import '../../../domain/entities/home/meal_entity.dart';
import 'meal_card_widget.dart';

class MealGridWidget extends StatelessWidget {
  final List<MealEntity> meals;

  const MealGridWidget({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: width >= 600 ? 0.9 : 0.65,
      ),
      itemCount: meals.length,
      itemBuilder: (context, index) => MealCardWidget(meal: meals[index]),
    );
  }
}
