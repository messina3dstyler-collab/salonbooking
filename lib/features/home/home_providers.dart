import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../user/user_providers.dart';
import 'controller/home_controller.dart';

final homeControllerProvider = ChangeNotifierProvider<HomeController>(
  (ref) => HomeController(ref.read(userServiceProvider)),
);
