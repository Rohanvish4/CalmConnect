import 'package:calm_connect/screens/home/controller/home_provider.dart';
import 'package:calm_connect/screens/resources/controller/resources_controller.dart';
import 'package:calm_connect/screens/self_care/controller/self_care_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../controller/auth_controller.dart';
import '../screens/chat/controller/chat_provider.dart';
import '../shared/shared_controller.dart';

class Appbinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<HomeProvider>(() => HomeProvider(), fenix: true);
    Get.lazyPut<SharedController>(() => SharedController(), fenix: true);
    Get.lazyPut<ChatProvider>(() => ChatProvider(), fenix: true);
    Get.lazyPut<SelfCareController>(() => SelfCareController(), fenix: true);
    Get.lazyPut<ResourcesController>(() => ResourcesController(), fenix: true);
  }
}
