import 'package:fitnessapp/features/add_meal/data/repository/products_repository.dart';
import 'package:fitnessapp/features/add_meal/domain/entity/meal_entity.dart';

class SearchProductByBarcodeUseCase {
  final ProductsRepository _productsRepository;

  SearchProductByBarcodeUseCase(this._productsRepository);

  Future<MealEntity> searchProductByBarcode(String barcode) async {
    return await _productsRepository.getOFFProductByBarcode(barcode);
  }
}
