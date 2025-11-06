/*
import 'package:get/get.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/services_class/shared_preferences_data_helper.dart';
import '../../../core/network_path/natwork_path.dart';

class DeleteApiController extends GetxController {
  Future<bool> deleteApiMethod(String id) async {
    bool isSuccess = false;
    try {
      print("🔹 Delete API called for ID: $id");

      NetworkResponse response =
      await NetworkCall.deleteRequest(url: Urls.usersDeleteAccount(id));

      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.responseData}");

      if (response.isSuccess) {
        isSuccess = true;
        await AuthController.getUserData();
      } else {
        print("❌ Delete failed: ${response.errorMessage}");
      }

    } catch (e) {
      print("⚠️ Delete API error: $e");
    }
    return isSuccess;
  }
}
*/
