import 'package:fitnessapp/core/data/repository/intake_repository.dart';
import 'package:fitnessapp/core/domain/entity/intake_entity.dart';

class AddIntakeUsecase {
  final IntakeRepository _intakeRepository;

  AddIntakeUsecase(this._intakeRepository);

  Future<void> addIntake(IntakeEntity intakeEntity) async {
    return await _intakeRepository.addIntake(intakeEntity);
  }
}
