import 'package:flutter/foundation.dart';

import '../models/admin_dashboard_model.dart';
import '../services/admin_service.dart';

class AdminController extends ChangeNotifier {
  AdminController(this._service);

  final AdminService _service;

  bool _isLoading=false;
  String? _error;
  String? _salonId;

  AdminDashboardModel _dashboard=
  AdminDashboardModel.empty();

  bool get isLoading=>_isLoading;
  String? get error=>_error;
  String? get salonId=>_salonId;
  AdminDashboardModel get dashboard=>_dashboard;


  Future<void> loadDashboard({
    required String salonId,
  }) async {

    _isLoading=true;
    _error=null;
    _salonId=salonId;
    notifyListeners();

    try{

      _dashboard=
      await _service.getDashboard(
        salonId,
      );

    }catch(e,stack){

      _error=e.toString();

      debugPrint(
        'ADMIN DASHBOARD ERROR: $e',
      );

      debugPrintStack(
        stackTrace:stack,
      );

    }finally{

      _isLoading=false;
      notifyListeners();

    }
  }


  Future<void> refresh({
    required String salonId,
  })=>
      loadDashboard(
        salonId:salonId,
      );


  void clear(){

    _dashboard=
        AdminDashboardModel.empty();

    _error=null;
    _salonId=null;
    _isLoading=false;

    notifyListeners();
  }


  void clearError(){

    _error=null;
    notifyListeners();

  }
}