import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_main.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

final readerViewAbstract = ValueNotifier<ViewAbstract?>(null);

class QrCodeReader extends StatefulWidget {
  Function(dynamic qr) onRead;
  bool getViewAbstract;
  double currentHeight;
  QrCodeReader(
      {super.key,
      required this.onRead,
      this.getViewAbstract = true,
      this.currentHeight = 0});

  @override
  State<QrCodeReader> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  double currentContainerHeight = 0;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void didUpdateWidget(covariant QrCodeReader oldWidget) {
    if (currentContainerHeight != widget.currentHeight) {
      currentContainerHeight = widget.currentHeight;
      if (currentContainerHeight == 0) {
        controller?.stopCamera();
      } else {
        controller?.resumeCamera();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  bool hasScanedBefore(Barcode scanedResult) {
    if (result != null) {
      if (result?.code == scanedResult.code &&
          result!.format == scanedResult.format) {
        return true;
      }
    }
    result = scanedResult;
    return false;
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (hasScanedBefore(scanData)) return;
      QRCodeID? qrCodeID;
      if (scanData.format == BarcodeFormat.qrcode) {
        if (scanData.code != null) {
          qrCodeID = QRCodeID.init(scanData.code!);
          debugPrint("QrCodeReader $qrCodeID");
        }
      }
      if (qrCodeID != null) {
        // await controller.pauseCamera();
        if (widget.getViewAbstract) {
          ViewAbstract? v =
              context.read<AuthProvider>().getNewInstance(qrCodeID.action);

          v = await v?.viewCallGetFirstFromList(qrCodeID.iD);
          widget.onRead(v);
        } else {
          widget.onRead(qrCodeID);
        }
        // await controller.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
