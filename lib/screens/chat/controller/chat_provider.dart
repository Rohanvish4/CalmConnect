import 'package:get/get.dart';



class ChatProvider extends GetxController {
  bool isLoading = false;

  void updateLoadingStatus({required bool status, bool isUpdate = true}) {
    isLoading = status;
    if (isUpdate) update();
  }
}
