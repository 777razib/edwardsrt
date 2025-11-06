import 'package:get/get.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../../../core/services_class/shared_preferences_data_helper.dart';
import '../../../../core/services_class/shared_preferences_helper.dart';
import '../../account text editing controller/account_text_editing_controller.dart';
import '../../model/user_model.dart';

class LoginApiRiderController extends GetxController {
  var isChecked = false.obs;
  var isPasswordHidden = true.obs;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final AccountTextEditingController userTextEditingController =
  Get.put(AccountTextEditingController());

  UserModel? userModel;

  Future<bool> loginApiRiderMethod() async {
    bool isSuccess = false;
    try {
      final Map<String, dynamic> mapBody = {
        "email": userTextEditingController.emailController.text.trim(),
        "password": userTextEditingController.passwordController.text.trim(),
      };

      final NetworkResponse response = await NetworkCall.postRequest(
        url: Urls.login,
        body: mapBody,
      );

      if (response.isSuccess) {
        final data = response.responseData!;

        final String? token = data['access_token'];
        if (token == null || token.isEmpty) {
          _errorMessage = 'Invalid token received';
          return false;
        }

        //UserModel userModel =  UserModel.fromJson(response.responseData!['data']);
        await AuthController.saveAccessToken(token);
        await SharedPreferencesHelper.saveAccessToken(token);
        await SharedPreferencesHelper.saveUserEmail( userTextEditingController.emailController.text);
       // await SharedPreferencesHelper.saveUserId(data['data']['id']); // await AuthController.setUserData(token, userModel);

        _errorMessage = null;
        isSuccess = true;
        update();
      } else {
        _errorMessage = response.errorMessage ??
            response.responseData?['message'] ??
            'Login failed';
      }
    } catch (e) {
      _errorMessage = 'Exception: $e';
      print(e);
    }
    return isSuccess;
  }
}
