import '../models/service_model.dart';
import '../repositories/service_repository.dart';

class ServiceService {
  ServiceService(this._repository);

  final ServiceRepository _repository;

  Future<List<ServiceModel>> getServices(String salonId) {
    return _repository.getServices(salonId);
  }
}
