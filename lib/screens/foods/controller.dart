import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'food_list.dart'; // Import your Food class and foodList

class FavoritesController extends GetxController {
  // Observable list of favorite items
  var favoriteFoods = <Food>[].obs;
  var mealList = <Map<String, String>>[].obs;

  final RxString selectedFoodName = ''.obs;
  final RxString selectedQuantity = ''.obs;
  var totalCalories = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    loadMealListFromPrefs();
    loadTotalCalories();
    loadMealList();
  }

  void addToFavorites(Food food) async {
    if (!favoriteFoods.contains(food)) {
      favoriteFoods.add(food);
      await saveFavorites();
    }
  }

  void addFoodItem(String name, String quantity) {
    mealList.add({'name': name, 'quantity': quantity});
    saveMealListToPrefs();
    calculateAndSaveCalories();
  }

  void removeFoodItem(int index) async {
    if (index >= 0 && index < mealList.length) {
      mealList.removeAt(index);
      calculateAndSaveCalories(); // 🔄 recalculate after removal
      await saveMealList();
    }
  }

  Future<void> saveMealList() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        mealList.map((e) => '${e['name']}|${e['quantity']}').toList();
    await prefs.setStringList('mealList', encoded);
  }

  Future<void> loadMealList() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList('mealList') ?? [];

    mealList.value = encoded.map((entry) {
      final parts = entry.split('|');
      return {'name': parts[0], 'quantity': parts[1]};
    }).toList();

    calculateAndSaveCalories();
  }

  void saveReminder() async {
    final String name = selectedFoodName.value;
    final String quantity = selectedQuantity.value;

    final exists =
        foodList.any((food) => food.name.toLowerCase() == name.toLowerCase());

    if (!exists) {
      Get.snackbar('Food Not Found', 'Food "$name" does not exist in database');
      return;
    }

    final alreadyExists = mealList
        .any((item) => item['name']?.toLowerCase() == name.toLowerCase());
    if (alreadyExists) {
      Get.snackbar('Duplicate Food', 'Food "$name" is already in your list');
      return;
    }

    addFoodItem(name, quantity);
    Get.snackbar('Added!', 'Food "$name" added successfully');
  }

  Future<void> saveMealListToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mealJsonList =
        mealList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('mealList', mealJsonList);
  }

  Future<void> loadMealListFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mealJsonList = prefs.getStringList('mealList') ?? [];

    mealList.value = mealJsonList
        .map((jsonString) => Map<String, String>.from(jsonDecode(jsonString)))
        .toList();
  }

  // Optional: clear all meals
  Future<void> clearMealList() async {
    mealList.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mealList');
  }

  Future<void> saveTotalCalories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalCalories', totalCalories.value);
  }

  Future<void> loadTotalCalories() async {
    final prefs = await SharedPreferences.getInstance();
    totalCalories.value = prefs.getDouble('totalCalories') ?? 0.0;
  }

  void removeFromFavorites(Food food) async {
    favoriteFoods.remove(food);
    await saveFavorites();
  }

  // Save favorites to SharedPreferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Save the names of favorite foods
    final favoriteNames = favoriteFoods.map((food) => food.name).toList();
    prefs.setStringList('favoriteFoods', favoriteNames);
  }

  // Load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Get saved food names
    final favoriteNames = prefs.getStringList('favoriteFoods') ?? [];
    // Match saved names with the `foodList`
    favoriteFoods.value =
        foodList.where((food) => favoriteNames.contains(food.name)).toList();
  }

  void calculateAndSaveCalories() {
    double total = 0.0;

    for (var item in mealList) {
      final name = item['name']?.toLowerCase().trim() ?? '';
      final quantity = double.tryParse(item['quantity'] ?? '0') ?? 0;

      final matched = foodList.firstWhereOrNull(
        (food) => food.name.toLowerCase().trim() == name,
      );

      if (matched != null) {
        final cal = double.tryParse(
              matched.calorie.replaceAll(RegExp(r'[^0-9.]'), ''),
            ) ??
            0.0;

        final added = cal * quantity / 100;
        total += added;

        print(
            '✅ $name | $quantity g → ${cal.toStringAsFixed(1)} kcal → ${added.toStringAsFixed(1)} kcal');
      }
    }

    totalCalories.value = total;
    saveTotalCalories();
    print('🔥 Total Calories: ${totalCalories.value.toStringAsFixed(2)} kcal');
  }
}

class SetgoalsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadReminder();
    loadWaterCon();
// Load favorites when the app starts
  }

  var selectedWaterCap = ''.obs;
  var selectedTimeValue = ''.obs;
  var fromTime = ''.obs;
  var toTime = ''.obs;
  var quantityInterval = ''.obs;
  var selectedWaterCon = '0 ml'.obs;

  void setWaterCap(String value) async {
    selectedWaterCap.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('waterCap', value);
  }

  void setTimeInterval(String value) async {
    selectedTimeValue.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('timeInterval', value);
  }

  void setFromTime(String time) async {
    fromTime.value = time;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fromTime', time);
  }

  void setToTime(String time) async {
    toTime.value = time;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('toTime', time);
  }

  void setQuantity(String value) async {
    quantityInterval.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('quantityInterval', value);
  }

  void setWatercon(String value) async {
    selectedWaterCon.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('waterCon', value);
  }

  void saveReminder() {
    // You could save this to a database or shared preferences instead
    print('Water Cap: ${selectedWaterCap.value}');
    print('Interval: ${selectedTimeValue.value}');
    print('From: ${fromTime.value}');
    print('To: ${toTime.value}');
  }

  void loadReminder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedWaterCap.value = prefs.getString('waterCap') ?? '';
    selectedTimeValue.value = prefs.getString('timeInterval') ?? '';
    fromTime.value = prefs.getString('fromTime') ?? '';
    toTime.value = prefs.getString('toTime') ?? '';
    quantityInterval.value = prefs.getString('quantityInterval') ?? '';
  }

  void loadWaterCon() async {
    final prefs = await SharedPreferences.getInstance();
    selectedWaterCon.value = prefs.getString('waterCon') ?? '0 ml';
  }
}

class NutrientsController extends GetxController {
  var favoriteFoods = <Food>[].obs;
  var mealList = <Map<String, String>>[].obs;

  // New: Total calories observable
  var totalCalories = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMealList();
    loadTotalCalories();
  }

  void addFoodItem(String name, String quantity) async {
    mealList.add({'name': name, 'quantity': quantity});
    calculateTotalCalories(); // recalculate after adding
    await saveMealList();
  }

  void removeFoodItem(int index) async {
    if (index >= 0 && index < mealList.length) {
      mealList.removeAt(index);
      calculateTotalCalories(); // recalculate after removal
      await saveMealList();
    }
  }

  void calculateTotalCalories() {
    double total = 0.0;

    for (var item in mealList) {
      final name = item['name']?.toLowerCase().trim() ?? '';
      final quantity = double.tryParse(item['quantity'] ?? '0') ?? 0;

      final matched = foodList.firstWhereOrNull(
        (food) => food.name.toLowerCase().trim() == name,
      );

      if (matched != null) {
        final cleanedCalorie =
            matched.calorie.replaceAll(RegExp(r'[^0-9.]'), '');
        final cal = double.tryParse(cleanedCalorie) ?? 0.0;

        final added = cal * quantity / 100;
        total += added;

        print(
            '→ $name: $quantity g ${cal.toStringAsFixed(1)} = ${added.toStringAsFixed(1)} kcal');
      } else {
        print('No match for "$name" in foodList.');
      }
    }
    print('total :$total ');
    totalCalories.value = total;
    print('🔥 Total Calories = ${totalCalories.value.toStringAsFixed(2)} kcal');
    saveTotalCalories();
  }

  Future<void> saveTotalCalories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalCalories', totalCalories.value);
  }

  Future<void> loadTotalCalories() async {
    final prefs = await SharedPreferences.getInstance();
    totalCalories.value = prefs.getDouble('totalCalories') ?? 0.0;
  }

  // Persist meal list
  Future<void> saveMealList() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        mealList.map((e) => '${e['name']}|${e['quantity']}').toList();
    await prefs.setStringList('mealList', encoded);
  }

  Future<void> loadMealList() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList('mealList') ?? [];

    mealList.value = encoded.map((entry) {
      final parts = entry.split('|');
      return {'name': parts[0], 'quantity': parts[1]};
    }).toList();

    calculateTotalCalories(); // Refresh total calories
  }
}
