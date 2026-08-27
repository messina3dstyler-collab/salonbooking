import '../models/salon_model.dart';
import '../repositories/salon_repository.dart';

class SalonService {
  SalonService(this._repository);

  final SalonRepository _repository;

  Future<List<SalonModel>> getSalons() {
    return _repository.getSalons();
  }

  Future<SalonModel?> getSalon(String id) {
    return _repository.getSalon(id);
  }
}
