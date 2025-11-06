// lib/core/network_caller/network_config.dart
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import '../../feature/auth/login/screen/signin_screen.dart';
import '../services_class/shared_preferences_helper.dart';

class NetworkResponse {
  final int statusCode;
  final Map<String, dynamic>? responseData;
  final String? errorMessage;
  final bool isSuccess;

  NetworkResponse({
    required this.statusCode,
    this.responseData,
    this.errorMessage = "Request failed !",
    required this.isSuccess,
  });
}

class NetworkCall {
  static final Logger _logger = Logger();

  // হেল্পার: টোকেন লোড + Bearer যোগ
  static Future<String?> _getAuthHeader() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return 'Bearer $token';
    }
    return null;
  }

  // হেল্পার: লগআউট
  static Future<void> _logOut() async {
    await SharedPreferencesHelper.clearAccessToken();
    Get.offAll(() => const SignInScreen());
  }

  /// GET request
  static Future<NetworkResponse> getRequest({
    required String url,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      String fullUrl = url;
      if (queryParams != null && queryParams.isNotEmpty) {
        fullUrl += '?';
        queryParams.forEach((key, value) {
          fullUrl += '$key=${Uri.encodeComponent(value.toString())}&';
        });
        fullUrl = fullUrl.substring(0, fullUrl.length - 1);
      }

      final Uri uri = Uri.parse(fullUrl);
      final Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      final authHeader = await _getAuthHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }

      _logRequest(fullUrl, headers);
      final Response response = await get(uri, headers: headers);
      _logResponse(fullUrl, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(statusCode: 401, isSuccess: false);
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }

  /// POST request
  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      final Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      final authHeader = await _getAuthHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }

      _logRequest(url, headers, requestBody: body);
      final Response response = await post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(statusCode: 401, isSuccess: false);
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }

  /// PATCH request
  static Future<NetworkResponse> patchRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      final Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      final authHeader = await _getAuthHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }

      _logRequest(url, headers, requestBody: body);
      final Response response = await patch(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(statusCode: 401, isSuccess: false);
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }

  /// PUT request
  static Future<NetworkResponse> putRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      final Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      final authHeader = await _getAuthHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }

      _logRequest(url, headers, requestBody: body);
      final Response response = await put(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(statusCode: 401, isSuccess: false);
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }

  /// DELETE request
  static Future<NetworkResponse> deleteRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      final Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      final authHeader = await _getAuthHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }

      _logRequest(url, headers, requestBody: body);
      final Response response = await delete(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(statusCode: 401, isSuccess: false);
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }

  /// Multipart POST/PUT request
  /// Multipart POST/PUT request
  static Future<NetworkResponse> multipartRequest({
    required String url,
    Map<String, String>? fields,
    File? imageFile,
    String methodType = 'POST',
    String imageFieldName = 'profileImage', // ← এটা যোগ করুন
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      final request = http.MultipartRequest(methodType, uri);

      final authHeader = await _getAuthHeader();
      if (authHeader != null) {
        request.headers['Authorization'] = authHeader;
      }

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          imageFieldName, // ← এখানে ব্যবহার
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      _logRequest(url, request.headers, requestBody: fields);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(statusCode: 401, isSuccess: false);
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }

  /*/// PUT Multipart request
  static Future<NetworkResponse> putMultipartRequest({
    required String url,
    required File file,
    String? fieldName = 'file',
    Map<String, String>? fields,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      final request = http.MultipartRequest('PUT', uri);

      request.headers['Accept'] = 'application/json';
      final authHeader = await _getAuthHeader();
      if (authHeader != null) {
        request.headers['Authorization'] = authHeader;
      }

      request.files.add(await http.MultipartFile.fromPath(fieldName!, file.path));

      if (fields != null) {
        request.fields.addAll(fields);
      }

      _logRequest(url, request.headers, requestBody: fields);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(statusCode: 401, isSuccess: false);
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          responseData: jsonDecode(response.body),
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }
*/
  /// Logging
  static void _logRequest(String url, Map<String, dynamic> headers, {Map<String, dynamic>? requestBody}) {
    _logger.i("REQUEST\nURL: $url\nHeaders: $headers\nBody: ${jsonEncode(requestBody)}");
  }

  static void _logResponse(String url, Response response) {
    _logger.i("RESPONSE\nURL: $url\nStatus: ${response.statusCode}\nBody: ${response.body}");
  }
}