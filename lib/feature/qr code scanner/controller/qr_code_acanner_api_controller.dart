import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRCodeScannerApiController extends GetxController {
  final String apiUrl = "https://your-api-endpoint.com/scan"; // Change this

  Future<bool> sendScannedDataToApi(String qrData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN', // If needed
        },
        body: jsonEncode({
          "qr_code": qrData,
          "timestamp": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("API Success: ${response.body}");
        return true;
      } else {
        debugPrint("API Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("API Exception: $e");
      return false;
    }
  }
}