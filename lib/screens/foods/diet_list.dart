import 'package:fitnessapp/screens/foods/controller.dart';
import 'package:fitnessapp/screens/foods/diet_records.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitnessapp/screens/foods/food_list.dart';

class DietList extends StatefulWidget {
  const DietList({super.key});

  @override
  State<DietList> createState() => _DietListState();
}

class _DietListState extends State<DietList> {
  final FavoritesController controller = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          title: const Text('Your Diet List'),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        body: Obx(() {
          if (controller.mealList.isEmpty) {
            return const Center(child: Text('No food items added yet.'));
          }

          return ListView.builder(
            itemCount: controller.mealList.length,
            itemBuilder: (context, index) {
              final item = controller.mealList[index];
              final String foodName = item['name']?.trim() ?? '';
              // Find match in predefined foodList
              final matchedFood = foodList.any(
                (food) => food.name.toLowerCase() == foodName.toLowerCase(),
              )
                  ? foodList.firstWhere(
                      (food) =>
                          food.name.toLowerCase() == foodName.toLowerCase(),
                    )
                  : null;

              double quantity = double.tryParse(item['quantity'] ?? '0') ?? 0;

              final String proteinText = matchedFood != null
                  ? 'Protein: ${(matchedFood.proteinvalue * quantity / 100).toStringAsFixed(2)} g'
                  : 'Food "$foodName" does not exist';

              final String carbsText = matchedFood != null
                  ? 'Carbs: ${(matchedFood.carbsvalue * quantity / 100).toStringAsFixed(2)} g'
                  : 'Food "$foodName" does not exist';

              final String calorieText = matchedFood != null
                  ? 'Calorie: ${(double.tryParse(matchedFood.calorie.replaceAll(RegExp(r'[^0-9.]'), ''))! * quantity / 100).toStringAsFixed(0)} Kcal'
                  : 'Food "$foodName" does not exist';

              final String fatText = matchedFood != null
                  ? 'Fats: ${(matchedFood.fatsvalue * quantity / 100).toStringAsFixed(2)} g'
                  : 'Food "$foodName" does not exist';

              return Card(
                color: Theme.of(context)
                    .primaryColorLight, // ✅ Keep original background
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: matchedFood != null
                            ? Image.asset(
                                matchedFood.image1,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantity: ${item['quantity']} g',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              proteinText,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              carbsText,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              fatText,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              calorieText,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            _showDeleteDialog(context, controller, index),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: SizedBox(
          height: 60,
          width: 100,
          child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColorLight,
              child: const Text('ADD MEAL'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DietRoutine()),
                );
              }),
        ));
  }
}

void _showDeleteDialog(
    BuildContext context, FavoritesController controller, int index) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove Item'),
      content: const Text('Are you sure you want to remove this food item?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            controller.removeFoodItem(index);

            Navigator.pop(context);
            Get.snackbar('Removed', 'Food item has been removed.',
                snackPosition: SnackPosition.BOTTOM);
          },
          child: const Text('Remove'),
        ),
      ],
    ),
  );
}
