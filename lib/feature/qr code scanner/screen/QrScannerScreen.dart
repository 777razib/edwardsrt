import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controller/qr_code_acanner_api_controller.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool isScanning = true;

  late final QRCodeScannerApiController qrController;

  final MobileScannerController scannerController = MobileScannerController(
    torchEnabled: false,
    facing: CameraFacing.back,
  );

  @override
  void initState() {
    super.initState();
    isScanning = true;
    qrController = Get.find<QRCodeScannerApiController>();
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) async {
              // ^7.0.0+ এর জন্য: capture হলো BarcodeCapture?
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty || !isScanning) return;

              setState(() => isScanning = false);

              final String? code = barcodes.first.rawValue;
              if (code == null || code.isEmpty) {
                setState(() => isScanning = true);
                return;
              }

              debugPrint('QR Code Scanned: $code');

              final success = await qrController.sendScannedDataToApi(code);

              if (!mounted) return;

              Get.snackbar(
                success ? "Success" : "Failed",
                success ? "QR processed successfully!" : "Failed to send data.",
                backgroundColor: success ? Colors.green : Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );

              if (success) {
                Get.back();
              } else {
                setState(() => isScanning = true);
              }
            },
          ),

          // Scanner Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Instruction
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Align QR code within the frame",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}