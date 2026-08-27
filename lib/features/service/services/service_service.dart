import '../models/service_model.dart';
import '../repositories/service_repository.dart';

class ServiceService {
  ServiceService(this._repository);

  final ServiceRepository _repository;

  Future<List<ServiceModel>> getServices(String salonId) {
    return _repository.getServices(salonId);
  }

  Future<ServiceModel?> getService({
    required String salonId,
    required String serviceId,
  }) {
    return _repository.getService(salonId: salonId, serviceId: serviceId);
  }
}
