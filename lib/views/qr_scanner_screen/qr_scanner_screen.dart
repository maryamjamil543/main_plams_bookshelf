import 'package:flutter/material.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../utils/colors.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanned = false;
  bool flashOn = false;
  bool frontCamera = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO :: app bar or qr scanner
      appBar: AppBar(
        title: Center(
          child: RalewayTextWidget(
            fontsize: 25.sp,
            fontWeight: FontWeight.w700,
            color: ColorUtils.blackColor,
            text:  qrScanner,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(flashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              await controller?.toggleFlash();
              bool? current = await controller?.getFlashStatus();
              setState(() {
                flashOn = current ?? false;
              });
            },
          ),
          IconButton(
            icon: Icon(frontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: () async {
              await controller?.flipCamera();
              CameraFacing? facing = await controller?.getCameraInfo();
              setState(() {
                frontCamera = facing == CameraFacing.front;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          //TODO :: based  on the isbn 13 they will capture and calling
          QRView(
            key: qrKey,
            onQRViewCreated: (QRViewController ctrl) {
              controller = ctrl;

              controller!.scannedDataStream.listen((scanData) {
                if (isScanned) return;
                isScanned = true;

                final code = scanData.code;
                if (code != null) {
                  Navigator.pop(context, code); // return scan result
                }
              });
            },
            overlay: QrScannerOverlayShape(
              borderColor: ColorUtils.blueColor,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          ),
          //TODO :: qr scanner detail showing text
          Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            child: RalewayTextWidget(
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: ColorUtils.whiteColor,
              text:  qrScannerDetail,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),

    );
  }
}
