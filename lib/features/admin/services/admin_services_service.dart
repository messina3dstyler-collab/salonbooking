import '../models/admin_service_model.dart';
import '../repositories/admin_services_repository.dart';

class AdminServicesService {
  AdminServicesService(
      this._repository,
      );

  final AdminServicesRepository _repository;


  // =====================================================
  // GET SOLO SERVIZI ATTIVI
  // =====================================================

  Future<List<AdminServiceModel>> getServices(
      String salonId,
      ) {
    return _repository.getServices(
      salonId,
    );
  }


  // =====================================================
  // GET TUTTI I SERVIZI
  // =====================================================

  Future<List<AdminServiceModel>> getAllServices(
      String salonId,
      ) {
    return _repository.getAllServices(
      salonId,
    );
  }


  // =====================================================
  // CREATE SERVICE
  // =====================================================

  Future<String> createService(
      String salonId,
      AdminServiceModel service,
      ) {
    return _repository.createService(
      salonId,
      service,
    );
  }


  // =====================================================
  // UPDATE SERVICE
  // =====================================================

  Future<void> updateService(
      String salonId,
      String serviceId,
      Map<String, dynamic> data,
      ) async {
    await _repository.updateService(
      salonId,
      serviceId,
      data,
    );
  }


  // =====================================================
  // DISABLE SERVICE
  // =====================================================

  Future<void> deleteService(
      String salonId,
      String serviceId,
      ) async {
    await _repository.deleteService(
      salonId,
      serviceId,
    );
  }


  // =====================================================
  // RESTORE SERVICE
  // =====================================================

  Future<void> restoreService(
      String salonId,
      String serviceId,
      ) async {
    await _repository.restoreService(
      salonId,
      serviceId,
    );
  }
}